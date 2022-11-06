//
//  ResponseEntity.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation

public class ResponseEntity: DomainBaseEntity {
    public var error: ErrorEntity?
    public var success: SuccessEntity?
    
    public init(error: ErrorEntity?, success: SuccessEntity?) {
        self.error = error
        self.success = success
    }
}
