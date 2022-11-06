//
//  NetworkRequestDBEntity+CoreDataProperties.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation
import CoreData


extension NetworkRequestDBEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NetworkRequestDBEntity> {
        return NSFetchRequest<NetworkRequestDBEntity>(entityName: "NetworkRequestDBEntity")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var request: RequestDBEntity?
    @NSManaged public var response: ResponseDBEntity?

}

extension NetworkRequestDBEntity : Identifiable {

}
