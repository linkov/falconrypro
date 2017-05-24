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
    
    
    public func allQuarryTypes() -> [QuarryTypeDisplayItem] {
        let quarryTypes = self.dataModelManager.fetchAll(entityName: SDWQuarryType.entityName(), predicate: nil, context: self.dataModelManager.viewContext) as! [SDWQuarryType]
        let quarryDisplayItems = quarryTypes.map({ (item: SDWQuarryType) -> QuarryTypeDisplayItem in
            QuarryTypeDisplayItem(model: item)
        })
        return quarryDisplayItems
    }
    
    public func allFoods() -> [FoodDisplayItem] {
        let quarryTypes = self.dataModelManager.fetchAll(entityName: SDWFood.entityName(), predicate: nil, context: self.dataModelManager.viewContext) as! [SDWFood]
        let quarryDisplayItems = quarryTypes.map({ (item: SDWFood) -> FoodDisplayItem in
            FoodDisplayItem(model: item)
        })
        return quarryDisplayItems
    }

    
    public func prefetchData(completion:@escaping sdw_id_error_block) {
        
        self.pullAllFoods(currentData: { (objects, error) in
     
            guard let _ = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
        }) { (objects, error) in
            
            guard let _ = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
            self.pullAllQuarryTypes(currentData: { (objects, error) in
                
                guard let _ = objects, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(nil,error)
                    return
                }
                
            }) { (objects, error) in
                
                guard let _ = objects, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(nil,error)
                    return
                }
                
                self.pullAllBirdTypes(currentData: { (objects, error) in
                    
                    guard let _ = objects, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        completion(nil,error)
                        return
                    }
                    
                    
                }, fetchedData: { (objects, error) in
                    
                    
                    guard let data = objects, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        completion(nil,error)
                        return
                    }
                    self.dataModelManager.saveContext()
                    completion(data,nil)
                    
                })
                
  
                
            }
            
        }
        

    }
    
    public func logout() {
        
        UserDefaults.standard.removeObject(forKey: "access-token")
        UserDefaults.standard.removeObject(forKey: "expiry")
        UserDefaults.standard.removeObject(forKey: "client")
        UserDefaults.standard.removeObject(forKey: "uid")
        
        
        self.dataModelManager.fetch(entityDescription: SDWUser.entity(), predicate: nil, context: self.dataModelManager.viewContext) { (user, error) in
            
//            let birds = (user as! SDWUser).birds
//            let seasons = (user as! SDWUser).seasons
//            
//            for bird in birds! {
//                self.dataModelManager.viewContext.delete(bird as! NSManagedObject)
//            }
//            
//            
//            for season in seasons! {
//                self.dataModelManager.viewContext.delete(season as! NSManagedObject)
//            }
//            
            self.dataModelManager.viewContext.delete(user as! NSManagedObject)
            self.dataModelManager.viewContext.processPendingChanges()
            
            
            
            self.dataModelManager.saveContext()
        }
        
        
    }
    
    
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
    
    
    public func updateDiaryItemWith(itemID:String,
                                  note:String?,
                                  quarryTypes:[QuarryTypeDisplayItem]?,
                                  completion:@escaping sdw_id_error_block) {
        
        
        var quarryTypeIDs = [String]()
        if let quarry = quarryTypes {
            quarryTypeIDs = quarry.map({ (item: QuarryTypeDisplayItem) -> String in
                item.remoteID
            })
        }
        
        
        self.networkManager.updateDiaryItemWith(itemID:itemID, quarryTypeIDs:quarryTypeIDs, note:note, completion: {(object, error) in
            
            
            guard let data = object, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
            
            let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWDiaryItem()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
            self.dataModelManager.saveContext()
            
            completion(mappedObject,nil)
            
        })
        
    }
    
    public func pushDiaryItemWith(birdID:String,
                                  note:String?,
                                  quarryTypes:[QuarryTypeDisplayItem]?,
                                  completion:@escaping sdw_id_error_block) {
        
        
        var quarryTypeIDs = [String]()
        if let quarry = quarryTypes {
            quarryTypeIDs = quarry.map({ (item: QuarryTypeDisplayItem) -> String in
                item.remoteID
            })
        }

        
        self.networkManager.createDiaryItemWith(birdID:birdID, quarryTypeIDs:quarryTypeIDs, note:note, completion: {(object, error) in
            
            
            guard let data = object, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
            
            let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWDiaryItem()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
            self.dataModelManager.saveContext()
            
            completion(mappedObject,nil)
            
        })
        
    }

    public func pushBirdWith(code:String?,
                             sex:Bool,
                             name:String,
                             birthday:Date,
                             fatWeight:Int,
                             huntingWeight:Int,
                             image:NSData?,
                             birdTypes:Array<BirdTypeDisplayItem>,
                             completion:@escaping sdw_id_error_block) {
        

        
        let birdTypeIDs = birdTypes.map({ (item: BirdTypeDisplayItem) -> String in
            item.remoteID
        })
        
        self.networkManager.createBirdWith(birdTypeIDs:birdTypeIDs, code: code, sex: sex, name: name, birthday: birthday, fatWeight: fatWeight, huntingWeight: huntingWeight, image: image, completion: {(object, error) in
            
            
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
            
            
            let arr:Array<SDWBirdType> = data as! Array
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
                    let displayItem:BirdTypeDisplayItem = BirdTypeDisplayItem(model: obj as! SDWBirdType)
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
            
            
            let arr:Array<SDWBird> = data as! Array
            var displayItemsArray = [BirdDisplayItem]()
            
            
            for obj in arr {
                let displayItem:BirdDisplayItem = BirdDisplayItem(model: obj )
                displayItemsArray.append(displayItem)
            }
            
            currentData(displayItemsArray,nil)
            

            
            self.networkManager.fetchBirds(completion: { (objects, error) in
                
                
                guard let data = objects, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    fetchedData(nil,error)
                    return
                }
                
                
               let mappedObjects = SDWMapper.ez_arrayOfObjects(withClass: type(of: SDWBird()) as SDWObjectMapping.Type, fromJSON: data as! Array<Any>, context: self.dataModelManager.viewContext)
                
                
                var displayItemsArray = [BirdDisplayItem]()
                
                
                for obj in mappedObjects {
                    let displayItem:BirdDisplayItem = BirdDisplayItem(model: obj as! SDWBird )
                    displayItemsArray.append(displayItem)
                }
                
                self.dataModelManager.saveContext()
                
                fetchedData(displayItemsArray,nil)
                
                
                
                
            })
            
            
        }
    }
    
    public func pullAllFoods(currentData:sdw_id_error_block,fetchedData:@escaping sdw_id_error_block) {
        
        
        self.dataModelManager.fetchAll(entityName:SDWFood.entityName(), predicate: nil, context: self.dataModelManager.viewContext) { (objects, error) in
            
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                currentData(nil,error)
                return
            }
            
            
            let arr:Array<SDWFood> = data as! Array
            var displayItemsArray = [FoodDisplayItem]()
            
            
            for obj in arr {
                let displayItem:FoodDisplayItem = FoodDisplayItem(model: obj )
                displayItemsArray.append(displayItem)
            }
            
            currentData(displayItemsArray,nil)
            
            
            
            self.networkManager.fetchFoods(completion: { (objects, error) in
                
                
                guard let data = objects, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    fetchedData(nil,error)
                    return
                }
                
                
                let mappedObjects = SDWMapper.ez_arrayOfObjects(withClass: type(of: SDWFood()) as SDWObjectMapping.Type, fromJSON: data as! Array<Any>, context: self.dataModelManager.viewContext)
                
                
                var displayItemsArray = [FoodDisplayItem]()
                
                
                for obj in mappedObjects {
                    let displayItem:FoodDisplayItem = FoodDisplayItem(model: obj as! SDWFood )
                    displayItemsArray.append(displayItem)
                }
                
                
                fetchedData(displayItemsArray,nil)
                
                
                
                
            })
            
            
        }
    }
    
    
    public func pullAllQuarryTypes(currentData:sdw_id_error_block,fetchedData:@escaping sdw_id_error_block) {
        
        
        self.dataModelManager.fetchAll(entityName:SDWQuarryType.entityName(), predicate: nil, context: self.dataModelManager.viewContext) { (objects, error) in
            
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                currentData(nil,error)
                return
            }
            
            
            let arr:Array<SDWQuarryType> = data as! Array
            var displayItemsArray = [QuarryTypeDisplayItem]()
            
            
            for obj in arr {
                let displayItem:QuarryTypeDisplayItem = QuarryTypeDisplayItem(model: obj )
                displayItemsArray.append(displayItem)
            }
            
            currentData(displayItemsArray,nil)
            
            
            
            self.networkManager.fetchQuarryTypes(completion: { (objects, error) in
                
                
                guard let data = objects, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    fetchedData(nil,error)
                    return
                }
                
                
                let mappedObjects = SDWMapper.ez_arrayOfObjects(withClass: type(of: SDWQuarryType()) as SDWObjectMapping.Type, fromJSON: data as! Array<Any>, context: self.dataModelManager.viewContext)
                
                
                var displayItemsArray = [QuarryTypeDisplayItem]()
                
                
                for obj in mappedObjects {
                    let displayItem:QuarryTypeDisplayItem = QuarryTypeDisplayItem(model: obj as! SDWQuarryType )
                    displayItemsArray.append(displayItem)
                }
                
                
                fetchedData(displayItemsArray,nil)
                
                
                
                
            })
            
            
        }
    }
    
    public func pullAllDiaryItemsForSeason(seasonID:String, currentData:sdw_id_error_block,fetchedData:@escaping sdw_id_error_block) {
        

        let predicate = NSPredicate(format: "season.remoteID == %@",seasonID)
        
        self.dataModelManager.fetchAll(entityName:SDWDiaryItem.entityName(), predicate: predicate, context: self.dataModelManager.viewContext) { (objects, error) in
            
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                currentData(nil,error)
                return
            }
            
            
            let arr:Array<SDWDiaryItem> = data as! Array
            var displayItemsArray = [DiaryItemDisplayItem]()
            
            
            for obj in arr {
                let displayItem:DiaryItemDisplayItem = DiaryItemDisplayItem(model: obj )
                displayItemsArray.append(displayItem)
            }
            
            currentData(displayItemsArray,nil)
            
            
            
            self.networkManager.fetchDiaryItemsForSeason(seasonID: seasonID, completion: { (objects, error) in
                
                
                guard let data = objects, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    fetchedData(nil,error)
                    return
                }
                
                
                let mappedObjects = SDWMapper.ez_arrayOfObjects(withClass: type(of: SDWDiaryItem()) as SDWObjectMapping.Type, fromJSON: data as! Array<Any>, context: self.dataModelManager.viewContext)
                
                
                var displayItemsArray = [DiaryItemDisplayItem]()
                
                
                for obj in mappedObjects {
                    let displayItem:DiaryItemDisplayItem = DiaryItemDisplayItem(model: obj as! SDWDiaryItem )
                    displayItemsArray.append(displayItem)
                }
                
                self.dataModelManager.saveContext()
                fetchedData(displayItemsArray,nil)
                
                
                
                
            })
            
            
        }
    }


}
