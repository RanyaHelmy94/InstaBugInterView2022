//
//  ErrorDBEntity+CoreDataProperties.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation
import CoreData

extension ErrorDBEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ErrorDBEntity> {
        return NSFetchRequest<ErrorDBEntity>(entityName: "ErrorDBEntity")
    }

    @NSManaged public var errorCode: String?
    @NSManaged public var errorDomain: String?

}

extension ErrorDBEntity : Identifiable {

}

