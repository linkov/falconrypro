//
//  SDWDiaryPhoto+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/15/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(SDWDiaryPhoto)
public class SDWDiaryPhoto: NSManagedObject, SDWObjectMapping {

    class func entityName() -> String {
        return "SDWDiaryPhoto"
    }
    
    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWDiaryPhoto")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        
        mapping.addAttribute(FEMAttribute.latlongAttribute(withProperty: "long", keyPath: "long"))
        mapping.addAttribute(FEMAttribute.latlongAttribute(withProperty: "lat", keyPath: "lat"))
        
        mapping.addAttribute(withProperty: "photoUrl", keyPath: "photo.url")
        mapping.addAttribute(withProperty: "thumbUrl", keyPath: "photo.thumb.url")
        
        mapping.addAttribute(FEMAttribute.dateAttribute(withProperty: "createdAt", keyPath: "created_at"))
        
        
        return mapping
    }
}
