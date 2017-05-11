//
//  SDWDiaryFood+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/10/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(SDWDiaryFood)
public class SDWDiaryFood: NSManagedObject, SDWObjectMapping {
    
    class func entityName() -> String {
        return "SDWDiaryFood"
    }
    
    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWDiaryFood")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "amountEaten", keyPath: "eaten")
        mapping.addAttribute(FEMAttribute.dateAttribute(withProperty: "time", keyPath: "time"))
        
        let foodRelationshipMapping:FEMRelationship = FEMRelationship(property: "food", keyPath: "food", mapping: SDWFood.defaultMapping())
        mapping.addRelationship(foodRelationshipMapping)
        
        
        return mapping
    }

}
