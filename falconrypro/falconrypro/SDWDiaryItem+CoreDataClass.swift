//
//  SDWDiaryItem+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(SDWDiaryItem)
public class SDWDiaryItem: NSManagedObject, SDWObjectMapping {
    
    class func entityName() -> String {
        return "SDWDiaryItem"
    }
    
    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWDiaryItem")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "note", keyPath: "note")
        mapping.addAttribute(FEMAttribute.dateAttribute(withProperty: "createdAt", keyPath: "created_at"))
        
        mapping.add(toManyRelationshipMapping: SDWDiaryWeight.defaultMapping(), forProperty: "weights", keyPath: "diary_weights")
        mapping.add(toManyRelationshipMapping: SDWDiaryFood.defaultMapping(), forProperty: "foods", keyPath: "diary_foods")
        
        return mapping
    }
    

}
