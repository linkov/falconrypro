//
//  SDWMapping.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import CoreData
import FastEasyMapping

class SDWMapper: NSObject {
    
    class func ez_arrayOfObjects(withClass:SDWObjectMapping.Type, fromJSON:Array<Any>, context:NSManagedObjectContext) -> Array<Any> {
        
        let interimArray:Array =  [FEMDeserializer.collection(fromRepresentation: fromJSON, mapping: withClass.defaultMapping(), context: context)]

        return interimArray[0]
    }
    
    
    class func ez_object(withClass:SDWObjectMapping.Type, fromJSON:Dictionary<AnyHashable, Any>, context:NSManagedObjectContext) -> Any {
        
        return [FEMDeserializer.object(fromRepresentation: fromJSON, mapping: withClass.defaultMapping(), context: context)];
    }



}
