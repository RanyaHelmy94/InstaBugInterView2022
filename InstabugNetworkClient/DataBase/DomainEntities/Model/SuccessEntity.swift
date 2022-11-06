//
//  SuccessEntity.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation

public class SuccessEntity: DomainBaseEntity {
    public var statusCode: String?
    public var payload: Data?
 
    public init(statusCode: Int, payload: Data?) {
        self.statusCode = "\(statusCode)"
        self.payload = payload
    }
}
