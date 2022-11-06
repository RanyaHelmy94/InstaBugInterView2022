//
//  InstabugNetworkClientTests.swift
//  InstabugNetworkClientTests
//
//  Created by Yousef Hamza on 1/13/21.
//

import XCTest
@testable import InstabugNetworkClient

class InstabugNetworkClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testGGGG() {
        //
    }
    
    //MARK: - test Recording and loading Rrequests
    func testRecordingAndLoadingRequests() throws {
        NetworkClient.shared.enableRecording(with: CoreDataStorageContext(), withRecordsLimit: 1000)
        var numberOfRequests = 0
        let expectation = expectation(description: "records requests count is not zero")
        NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
            NetworkClient.shared.allNetworkRequests { requests in
                numberOfRequests = requests.count
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10)
        XCTAssertNotEqual(numberOfRequests, 0)
    }
    
 //MARK: - test  Post Request
    func testPostRequest() throws{
        NetworkClient.shared.enableRecording(with: CoreDataStorageContext(), withRecordsLimit: 1000)
        var payload: Data?
        let expectation = expectation(description: "post request")
        NetworkClient.shared.post(URL(string: "https://httpbin.org/post")!, payload: nil) { data in
            if data != nil{
                payload = data
                expectation.fulfill()
            }else{
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(payload, "payload not nil")
    }
    
    //MARK: - test Get Request
    func testGetRequest() throws {
        NetworkClient.shared.enableRecording(with: CoreDataStorageContext(), withRecordsLimit: 1000)
        var payload: Data?
        let expectation = expectation(description: "get request")
        NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
            if data != nil{
                payload = data
                expectation.fulfill()
            }else{
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertFalse(payload == nil,"payload is not nil")
    }

    //MARK: - test Delete Request
    func testDeleteRequest() {
        NetworkClient.shared.enableRecording(with: CoreDataStorageContext(), withRecordsLimit: 1000)
        var payload: Data?
        let expectation = expectation(description: "delete request")
        NetworkClient.shared.delete(URL(string: "https://httpbin.org/delete")!) { data in
            if data != nil{
                payload =  data
                expectation.fulfill()
            }else{
               XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertTrue(payload != nil, "payload is not nil")
    }
    
    //MARK: -
    func testRecordLimitRequests() throws  {
        let limit = 5
        let expectation = expectation(description: "record limited")
        var numberOfRequests = 0
        
        NetworkClient.shared.get(URL(string: "https://httpbin.org/post")!) { data in
            if data == nil {
                XCTFail()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1,  execute: {
            NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
                if data == nil {
                    XCTFail()
                }
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2,  execute: {
            NetworkClient.shared.get(URL(string: "https://httpbin.org/delete")!) { data in
                if data == nil {
                    XCTFail()
                }
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3,  execute: {
            NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
                if data == nil {
                    XCTFail()
                }
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4,  execute: {
            NetworkClient.shared.get(URL(string: "https://httpbin.org/get")!) { data in
                if data == nil {
                    XCTFail()
                }
            }
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            NetworkClient.shared.allNetworkRequests { requests in
                numberOfRequests = requests.count
                expectation.fulfill()
            }
        }
        
        
        waitForExpectations(timeout: 10)
        //Then
        XCTAssertNotEqual(numberOfRequests, 0)
        XCTAssertEqual(numberOfRequests, limit)
    }
    
    override func tearDown() {
        
    }

}
