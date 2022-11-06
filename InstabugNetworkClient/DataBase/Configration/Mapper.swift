//
//  Mapper.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 04/11/2022.
//

import Foundation
import CoreData

class Mapper {
    
    class func mapToDomain(from dbEntity: NetworkRequestDBEntity, target domainEntity: inout NetworkRequest){
        //MARK: - Request:
        domainEntity.createDate = dbEntity.createDate
        domainEntity.objectID = dbEntity.objectID
       //REquest
        domainEntity.request?.payload = dbEntity.request?.payload
        domainEntity.request?.url = dbEntity.request?.url
        domainEntity.request?.method = dbEntity.request?.method
        domainEntity.request?.objectID = dbEntity.request?.objectID
        
        //MARK: -  Response:
        domainEntity.response?.objectID = dbEntity.response?.objectID
        //Success
        domainEntity.response?.success?.payload = dbEntity.response?.success?.payload
        domainEntity.response?.success?.statusCode = dbEntity.response?.success?.statusCode
        domainEntity.response?.success?.objectID   = dbEntity.response?.success?.objectID
        //Error
        domainEntity.response?.error?.errorCode = dbEntity.response?.error?.errorCode ?? ""
        domainEntity.response?.error?.errorDomain = dbEntity.response?.error?.errorDomain
        domainEntity.response?.error?.objectID =  dbEntity.response?.error?.objectID
    }
    
    class func mapToDB(from domainEntity: NetworkRequest, target dbEntity: inout NetworkRequestDBEntity, context: NSManagedObjectContext){
        //MARK: - response:
        let success = SuccessDBEntity(context: context)
        success.payload = domainEntity.response?.success?.payload
        success.statusCode = domainEntity.response?.success?.statusCode
        
        let error = ErrorDBEntity(context: context)
        error.errorCode = domainEntity.response?.error?.errorCode
        error.errorDomain = domainEntity.response?.error?.errorDomain
        
        let response = ResponseDBEntity(context: context)
        response.success = success
        response.error = error
        
        
        //MARK: - Request:
        let request = RequestDBEntity(context: context)
        request.payload = domainEntity.request?.payload
        request.url     = domainEntity.request?.url
        request.method  = domainEntity.request?.method
        
        dbEntity.createDate = domainEntity.createDate
        dbEntity.request    = request
        dbEntity.response   = response
  
    }

}
