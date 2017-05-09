//
//  SDWDataStore.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import CoreData
import FastEasyMapping

class SDWDataStore: NSObject {
    
    
    let dataModelManager = DataModelManager.sharedInstance
    let networkManager = NetworkManager.sharedInstance
    
    static let sharedInstance : SDWDataStore = {
        let instance = SDWDataStore()
        return instance
    }()
    
    
    public func pullUserWith(email:String,password:String,completion:@escaping sdw_id_error_block) {
        
        self.networkManager .signInWith(email: email, password: password) { (object, error) in
            
            guard let data = object, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
            let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWUser()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
            self.dataModelManager.saveContext()
            
            completion(mappedObject,nil)
            
        }
    }
    
    
    
    public func pushUserWith(email:String,password:String,completion:@escaping sdw_id_error_block) {
        
        self.networkManager .signUpWith(email: email, password: password) { (object, error) in
            
            guard let data = object, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
            let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWUser()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
            self.dataModelManager.saveContext()
            
            completion(mappedObject,nil)
            
        }
    }
    
    public func removeBird(remoteID:String) {
        
        let predicate = NSPredicate(format: "%K = %K", "remoteID", remoteID)
        
        self.dataModelManager.fetch(entityDescription: SDWBird.entity(), predicate: predicate, context: self.dataModelManager.viewContext) { (object, error) in
            
            let bird:SDWBird = object as! SDWBird
            self.dataModelManager.viewContext.delete(bird)
        }

    }

    public func pushBirdWith(code:String?,
                             sex:Bool,
                             name:String,
                             birthday:Date,
                             fatWeight:Int,
                             huntingWeight:Int,
                             image:NSData?,
                             completion:@escaping sdw_id_error_block) {
        
        self.networkManager.createBirdWith(code: code, sex: sex, name: name, birthday: birthday, fatWeight: fatWeight, huntingWeight: huntingWeight, image: image, completion: {(object, error) in
            
            
            guard let data = object, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
            
            let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWBird()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
            self.dataModelManager.saveContext()
            
            completion(mappedObject,nil)
            
        })
        
    }
    
    public func pullAllBirdTypes(currentData:sdw_id_error_block,fetchedData:@escaping sdw_id_error_block) {
        
        
        
        self.dataModelManager.fetchAll(entityName:SDWBirdType.entityName(), predicate: nil, context: self.dataModelManager.viewContext) { (objects, error) in
            
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                currentData(nil,error)
                return
            }
            
            
            let arr:Array<SDWBird> = data as! Array
            var displayItemsArray = [BirdTypeDisplayItem]()
            
            
            for obj in arr {
                let displayItem:BirdTypeDisplayItem = BirdTypeDisplayItem(model: obj)
                displayItemsArray.append(displayItem)
            }
            
            currentData(displayItemsArray,nil)
            
            self.networkManager.fetchBirdTypes(completion: { (objects, error) in
                
                
                guard let data = objects, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    fetchedData(nil,error)
                    return
                }
                
                
                let mappedObjects = SDWMapper.ez_arrayOfObjects(withClass: type(of: SDWBirdType()) as SDWObjectMapping.Type, fromJSON: data as! Array<Any>, context: self.dataModelManager.viewContext)
                
                
                
                var displayItemsArray = [BirdTypeDisplayItem]()
                
                
                for obj in mappedObjects {
                    let displayItem:BirdTypeDisplayItem = BirdTypeDisplayItem(model: obj as! SDWBird)
                    displayItemsArray.append(displayItem)
                }
                
                
                fetchedData(displayItemsArray,nil)
                
                
                
                
            })
            
            
        }
    }
    
    public func pullAllBirds(currentData:sdw_id_error_block,fetchedData:@escaping sdw_id_error_block) {
        

        
        self.dataModelManager.fetchAll(entityName:SDWBird.entityName(), predicate: nil, context: self.dataModelManager.viewContext) { (objects, error) in
            
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                currentData(nil,error)
                return
            }
            
            
            let arr:Array<NSManagedObject> = data as! Array
            
            currentData(arr,nil)
            
            for obj in arr {
                print(obj)
            }
            
            self.networkManager.fetchBirds(completion: { (objects, error) in
                
                
                guard let data = objects, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    fetchedData(nil,error)
                    return
                }
                
                
               let mappedObjects = SDWMapper.ez_arrayOfObjects(withClass: type(of: SDWUser()) as SDWObjectMapping.Type, fromJSON: data as! Array<Any>, context: self.dataModelManager.viewContext)
                
                
                
                
                fetchedData(mappedObjects,nil)
                
                
                
                
            })
            
            
        }
    }


}
