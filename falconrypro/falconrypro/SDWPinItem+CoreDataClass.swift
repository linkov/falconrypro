//
//  SDWPinItem+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/1/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping


@objc(SDWPinItem)
public class SDWPinItem: NSManagedObject, SDWObjectMapping {

    class func entityName() -> String {
        return "SDWPinItem"
    }
    
    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWPinItem")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "note", keyPath: "note")

        mapping.addAttribute(FEMAttribute.latlongAttribute(withProperty: "long", keyPath: "long"))
        mapping.addAttribute(FEMAttribute.latlongAttribute(withProperty: "lat", keyPath: "lat"))
        
        mapping.addAttribute(withProperty: "imageURL", keyPath: "photo.url")
        mapping.addAttribute(withProperty: "thumbURL", keyPath: "photo.thumb.url")
        mapping.addAttribute(withProperty: "pinTypeName", keyPath: "pin_type_name")
        
        
        let typeMapping:FEMMapping = FEMMapping(entityName: "PinType")
        typeMapping.primaryKey = "remoteID"
        typeMapping.addAttribute(withProperty: "remoteID", keyPath: nil)
        
        let typeRelationshipMapping:FEMRelationship = FEMRelationship(property: "pintype", keyPath: "pin_type", mapping: typeMapping)
        typeRelationshipMapping.weak = true
        mapping.addRelationship(typeRelationshipMapping)
        
        return mapping
    }
}
