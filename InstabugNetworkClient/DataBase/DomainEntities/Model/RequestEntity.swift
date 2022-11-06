//
//  RequestEntity.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation

public class RequestEntity: DomainBaseEntity {
    public var method: String?
    public var url: URL?
    public var payload: Data?
    
    public init(method: String? = nil, url: URL? = nil, payload: Data? = nil) {
        self.method = method
        self.url = url
        self.payload = payload
    }
}
