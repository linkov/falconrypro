//
//  SDWFood+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(SDWFood)
public class SDWFood: NSManagedObject, SDWObjectMapping {
    
    class func entityName() -> String {
        return "SDWFood"
    }
    
    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWFood")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "name", keyPath: "name")
        
        return mapping
    }

}
