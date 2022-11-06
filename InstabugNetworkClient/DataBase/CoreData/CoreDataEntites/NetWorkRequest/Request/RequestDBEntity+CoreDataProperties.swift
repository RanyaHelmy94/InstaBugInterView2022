//
//  RequestDBEntity+CoreDataProperties.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation
import CoreData

extension RequestDBEntity{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RequestDBEntity> {
        return NSFetchRequest<RequestDBEntity>(entityName: "RequestDBEntity")
    }
    
    @NSManaged public var method: String?
    @NSManaged public var url: URL?
    @NSManaged public var payload: Data?
    
}

extension RequestDBEntity : Identifiable {

}

