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
        
        return [FEMDeserializer.object(fromRepresentation: fromJSON, mapping: withClass.defaultMapping(), context: context)].first ?? [FEMDeserializer.object(fromRepresentation: fromJSON, mapping: withClass.defaultMapping(), context: context)];
    }
    
    
    class func ez_serializeObjects(withClass:SDWObjectMapping.Type, fromArray:Array<Any>, context:NSManagedObjectContext) -> Array<Any> {
        
        let interimArray:Array =  [FEMSerializer .serializeCollection(fromArray, using: withClass.defaultMapping())]
        return interimArray
    }
    
    
    class func ez_serializeObject(withClass:SDWObjectMapping.Type, fromObject:Any, context:NSManagedObjectContext) -> Any {
        
        return [FEMSerializer .serializeObject(fromObject, using: withClass.defaultMapping())]
    }



}
