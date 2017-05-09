//
//  SDWBirdType+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping


@objc(SDWBirdType)
public class SDWBirdType: NSManagedObject, SDWObjectMapping {

    class func entityName() -> String {
        return "SDWBirdType"
    }
    
    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWBirdType")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "name", keyPath: "name")
        mapping.addAttribute(withProperty: "latin", keyPath: "latin")
        
        return mapping
    }
}
