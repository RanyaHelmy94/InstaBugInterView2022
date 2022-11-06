//
//  NetworkRequest.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation

public class NetworkRequest: DomainBaseEntity {
    public var createDate: Date?
    public var request: RequestEntity?
    public var response: ResponseEntity?
    
    public required init(request: RequestEntity? = nil, response: ResponseEntity? = nil) {
        self.request = request
        self.response = response
        self.createDate = Date()
    }
    
    static func create(urlRequest: URLRequest, data: Data?, response: HTTPURLResponse?, error: NSError?) -> NetworkRequest {
        let requestBodyPayload = PayloadValidator.validate(data: urlRequest.httpBody)
        let responseBodyPayload = PayloadValidator.validate(data: data)
        let responseStatusCode = response?.statusCode ?? 0
        let errorEntity = ErrorEntity(errorDomain: error?.domain, errorCode: error?.code ?? 0)
        let successEntity = SuccessEntity(statusCode: responseStatusCode, payload: responseBodyPayload)
        let response = ResponseEntity(error: errorEntity, success: successEntity)
        let request = RequestEntity(method: urlRequest.httpMethod, url: urlRequest.url, payload: requestBodyPayload)
        let networkRequest = NetworkRequest(request: request, response: response)
        return networkRequest
    }
}
