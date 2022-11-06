//
//  ErrorEntity.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation

public class ErrorEntity: DomainBaseEntity {
    public var errorDomain: String?
    public var errorCode: String
    
    public init(errorDomain: String?, errorCode: Int) {
        self.errorCode = "\(errorCode)"
        self.errorDomain = errorDomain
    }
}
