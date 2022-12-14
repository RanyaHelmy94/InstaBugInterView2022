//
//  NetworkRequestDao.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 04/11/2022.
//

import Foundation
import UIKit

class NetworkRequestDao{
    
    private var storageContext: StorageContext
    required init(storageCotext: StorageContext){
        self.storageContext = storageCotext
    }
    
    //MARK: - save object
    func save(object: NetworkRequest) {
        var dbEntity: NetworkRequestDBEntity?
        if object.objectID != nil{
            dbEntity = storageContext.objectWithObjectId(objectId: object.objectID!)
        }else{
            dbEntity = storageContext.create(NetworkRequestDBEntity.self)
        }
        
        Mapper.mapToDB(from: object, target: &dbEntity!, context: storageContext.managedContext!)
        do{
            try storageContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //MARK: - getExceededRecord
    func getExceededRecord(_ recordsLimitCount: Int = 1000) -> NetworkRequestDBEntity?  {
        do {
            let sort = Sort.init(key: "createDate")
            let entites = try storageContext.fetchAll(NetworkRequestDBEntity.self, sort: sort)
            guard let entitiesCount = entites?.count, entitiesCount >= recordsLimitCount  else {
                return nil
            }
            guard let firstEntity = entites?.first else {
                return nil
            }
            return firstEntity
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - delete object
    func delete(_ entity: NetworkRequestDBEntity?) {
        do {
            guard let entity = entity else {
                return
            }
            try storageContext.delete(entity)
            try storageContext.save()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - delete all objects from database
    func reset() {
        do{
            try storageContext.deleteAll(NetworkRequestDBEntity.self)
        }catch{
            print(error.localizedDescription)
        }
    }

    //MARK: - fetch all objects from database
    func fetchAll(_ sort: Sort? = nil) -> [NetworkRequest] {
        do {
            var requests = [NetworkRequest]()
            let sort = Sort.init(key: "createDate")
            let entites = try storageContext.fetchAll(NetworkRequestDBEntity.self, sort: sort)
            entites?.forEach({ entity in
                var request = NetworkRequest()
                Mapper.mapToDomain(from: entity, target: &request)
                requests.append(request)
            })
            return requests
        }catch {
            print(error.localizedDescription)
            return []
        }
    }
    
}
