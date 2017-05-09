//
//  Protocols.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import FastEasyMapping

@objc protocol SDWObjectMapping {
    static func defaultMapping() -> FEMMapping
    static func entityName() -> String
}
