//
//  SDWQuarryType+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping


@objc(SDWQuarryType)
public class SDWQuarryType: NSManagedObject, SDWObjectMapping {
    
    
    class func entityName() -> String {
        return "SDWQuarryType"
    }
    
    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWQuarryType")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "name", keyPath: "name")
        
        
        
        return mapping
    }

}
