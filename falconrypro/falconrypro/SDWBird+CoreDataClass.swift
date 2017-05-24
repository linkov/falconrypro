//
//  SDWBird+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(SDWBird)
public class SDWBird: NSManagedObject, SDWObjectMapping {
    
    class func entityName() -> String {
       return "SDWBird"
    }

    class func defaultMapping() -> FEMMapping {

        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWBird")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "name", keyPath: "name")
        mapping.addAttribute(withProperty: "isMale", keyPath: "sex")
        mapping.addAttribute(withProperty: "code", keyPath: "code")
        mapping.addAttribute(withProperty: "imageURL", keyPath: "pic")
        mapping.addAttribute(withProperty: "thumbURL", keyPath: "thumb")
        mapping.addAttribute(withProperty: "fatWeight", keyPath: "fat_weight")
        mapping.addAttribute(withProperty: "huntingWeight", keyPath: "hunting_weight")
        mapping.addAttribute(FEMAttribute.bdayDateAttribute(withProperty: "birthday", keyPath: "birthday"))
        
        let userMapping:FEMMapping = FEMMapping(entityName: "SDWUser")
        userMapping.primaryKey = "remoteID"
        userMapping.addAttribute(withProperty: "remoteID", keyPath: nil)
        
        let userRelationshipMapping:FEMRelationship = FEMRelationship(property: "owner", keyPath: "owner", mapping: userMapping)
        userRelationshipMapping.weak = true
        mapping.addRelationship(userRelationshipMapping)
        
        mapping.add(toManyRelationshipMapping: SDWBirdType.defaultMapping(), forProperty: "types", keyPath: "bird_types")
        mapping.add(toManyRelationshipMapping: SDWSeason.defaultMapping(), forProperty: "seasons", keyPath: "seasons")

        
        return mapping
    }
}
