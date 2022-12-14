//
//  NetworkClient.swift
//  InstabugNetworkClient
//
//  Created by Yousef Hamza on 1/13/21.
//

import Foundation

public class NetworkClient {
    public static var shared = NetworkClient()
    private var recordingEnabled: Bool = false
    private var networkRequestDB: NetworkRequestDao?
    private var recordsLimitCount: Int = 1000
    
    private init() {
        
    }
    
    //Concurrent Queueu for thread safe operations
    private let concurrentQueue = DispatchQueue(label: "InstabugConcurrentQueue", attributes: .concurrent)

    // MARK: Network requests
    public func get(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "GET", payload: nil, completionHandler: completionHandler)
    }

    public func post(_ url: URL, payload: Data?=nil, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "POSt", payload: payload, completionHandler: completionHandler)
    }

    public func put(_ url: URL, payload: Data?=nil, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "PUT", payload: payload, completionHandler: completionHandler)
    }

    public func delete(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "DELETE", payload: nil, completionHandler: completionHandler)
    }

    func executeRequest(_ url: URL, method: String, payload: Data?, completionHandler: @escaping (Data?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = payload
        
        URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, error in
            guard let self = self else {return}
            //1. validate for records limit and remove the old one if limit exceeded
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            self.validateRecordsLimit {
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {[weak self]  in
                //2. save network request record with async barrier flag
                self?.recordRequest(
                    urlRequest: urlRequest,
                    data: data,
                    response: response as? HTTPURLResponse,
                    error: error as NSError?
                )
                
                //3. sync call back
                self?.concurrentQueue.sync {
                    completionHandler(data)
                }
            }
        }.resume()
    }

}

// MARK: Network recording
extension NetworkClient {
    //MARK: - enableRecording
    public func enableRecording(with context: CoreDataStorageContext, withRecordsLimit limit: Int) {
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            self?.recordsLimitCount = limit
            self?.recordingEnabled = true
            self?.networkRequestDB = NetworkRequestDao(storageCotext: context)
            self?.networkRequestDB?.reset()
        }
    }
    
    //MARK: - resetRecords
    public func resetRecords() {
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            self?.networkRequestDB?.reset()
        }
    }
    
    //MARK: - setRecordsLimit
    public func setRecordsLimit(_ limit: Int) {
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            self?.recordsLimitCount = limit
        }
    }
    
    //MARK: - fetch allNetworkRequests
    public func allNetworkRequests(_ completionHandler: @escaping ([NetworkRequest]) -> Void) {
        guard recordingEnabled else {
            fatalError("You must call enableRecording function to configure the StoreContext before accessing any dao")
        }
        
        concurrentQueue.sync { [weak self] in
            guard let requests = self?.networkRequestDB?.fetchAll() else { return }
            completionHandler(requests)
        }
    }
    
    //MARK: - recordRequest
    public func recordRequest(urlRequest: URLRequest, data: Data?, response: HTTPURLResponse?,error: NSError?) {
        guard recordingEnabled else {
            return
        }
        
        self.concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else {return}
            let networkRequest = NetworkRequest.create(urlRequest: urlRequest, data: data, response: response, error: error)
            self.networkRequestDB?.save(object: networkRequest)
        }
    }
    
    //MARK: - validateRecordsLimit
    public func validateRecordsLimit(_ completionHandler: @escaping () -> Void){
        var entity: NetworkRequestDBEntity?
        
        //1. search for old exceededRecord
        let group = DispatchGroup()
        group.enter()
        concurrentQueue.sync { [weak self] in
            entity = self?.networkRequestDB?.getExceededRecord(self?.recordsLimitCount ?? 0)
            group.leave()
        }
        
        group.wait()
        
        //2. check if not exceed the limit
        guard entity != nil else {
            completionHandler()
            return
        }
        
        //3. delete the old object with async barrier flag to avoid not thread safe of signleton when read and write on the same time on database
        //Barrier flag in GrandDispatchQueue to convert all concurrent threads to serial untill complete its block then reverse it to concurrent again
        self.concurrentQueue.async(flags: .barrier) {[weak self] in
            self?.networkRequestDB?.delete(entity)
        }
    }

}
