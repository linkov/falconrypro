//
//  SDWUser+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(SDWUser)
public class SDWUser: NSManagedObject, SDWObjectMapping {
    
    
    class func entityName() -> String {
        return "SDWUser"
    }

    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWUser")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "name", keyPath: "name")
        mapping.addAttribute(withProperty: "email", keyPath: "email")
        mapping.addAttribute(withProperty: "metric", keyPath: "metric")
        
        
        return mapping
    }
}
