//
//  Sort.swift
//  InstabugNetworkClient
//
//  Created by Ranya Helmy on 03/11/2022.
//

import Foundation
import CoreData

/* Query options */
public struct Sort {
    var key: String
    var ascending: Bool = true
}

extension Sort {
    func sortDecriptor() -> NSSortDescriptor  {
        NSSortDescriptor.init(key: key, ascending: ascending)
    }
}
