//
//  SDWSeason+CoreDataClass.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData
import FastEasyMapping

@objc(SDWSeason)
public class SDWSeason: NSManagedObject, SDWObjectMapping {
    
    class func entityName() -> String {
        return "SDWSeason"
    }
    
    class func defaultMapping() -> FEMMapping {
        
        
        let mapping:FEMMapping = FEMMapping(entityName: "SDWSeason")
        mapping.primaryKey = "remoteID";
        mapping.addAttribute(FEMAttribute.falconryID())
        mapping.addAttribute(withProperty: "isBetweenSeason", keyPath: "between")
        mapping.addAttribute(withProperty: "startDateString", keyPath: "start_date")
        mapping.addAttribute(withProperty: "endDateString", keyPath: "end_date")
        mapping.addAttribute(FEMAttribute.bdayDateAttribute(withProperty: "startDate", keyPath: "start"))
        mapping.addAttribute(FEMAttribute.bdayDateAttribute(withProperty: "endDate", keyPath: "end"))
        
        return mapping
    }

}
