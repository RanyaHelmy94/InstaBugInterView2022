//
//  PayloadValidator.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation

class PayloadValidator {
    static func validate(data: Data?) -> Data? {
        guard let payLoadData = data else {
            return Data()
        }

        guard payLoadData.getSizeInMB() > 1 else {
            return data
        }
        
        let newValidData = Data("payload too large".utf8)
        return newValidData
    }
}
