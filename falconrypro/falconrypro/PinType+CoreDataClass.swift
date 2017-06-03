//
//  PinType+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/2/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(PinType)

public class PinType: NSManagedObject, SDWObjectMapping {

    class func entityName() -> String {
        return "PinType"
    }
    
    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "PinType")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "title", keyPath: "title")
        
        
        return mapping
    }
}
