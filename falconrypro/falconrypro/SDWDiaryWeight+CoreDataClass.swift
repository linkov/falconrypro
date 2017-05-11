//
//  SDWDiaryWeight+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/10/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(SDWDiaryWeight)
public class SDWDiaryWeight: NSManagedObject, SDWObjectMapping {
    
    class func entityName() -> String {
        return "SDWDiaryWeight"
    }
    
    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWDiaryWeight")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "weight", keyPath: "weight")
        mapping.addAttribute(FEMAttribute.dateAttribute(withProperty: "time", keyPath: "time"))
        

        
        return mapping
    }

}
