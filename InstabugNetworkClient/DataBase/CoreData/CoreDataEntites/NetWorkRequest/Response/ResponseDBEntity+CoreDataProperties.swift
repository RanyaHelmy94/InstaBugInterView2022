//
//  ResponseDBEntity+CoreDataProperties.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation
import CoreData


extension ResponseDBEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ResponseDBEntity> {
        return NSFetchRequest<ResponseDBEntity>(entityName: "ResponseDBEntity")
    }

    @NSManaged public var error: ErrorDBEntity?
    @NSManaged public var success: SuccessDBEntity?

}

extension ResponseDBEntity : Identifiable {

}
