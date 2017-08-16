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
import CoreLocation
import SwiftLocation
import Solar

enum BirdStatus: Int {
    case deleted,killed,sold,active
}


class SDWDataStore: NSObject {
    
    
    let dataModelManager = DataModelManager.sharedInstance
    let networkManager = NetworkManager.sharedInstance
    
    static let sharedInstance : SDWDataStore = {
        let instance = SDWDataStore()
        return instance
    }()
    
    public func currentUser() -> UserDisplayItem? {
        let predicate = NSPredicate(format: "%K = %@", "isAdmin", NSNumber(booleanLiteral: true))
        
        let currentModel = self.dataModelManager.fetch(entityName: SDWUser.entityName(), predicate: predicate, context: self.dataModelManager.viewContext) as? SDWUser
        
        if let model = currentModel {
            let currentItem = UserDisplayItem(model: model)
            return currentItem
        }
        
        return nil
        
    }
    
    
    public func currentBird() -> BirdDisplayItem? {
        let predicate = NSPredicate(format: "%K = %@", "current", NSNumber(booleanLiteral: true))
        
        let currentBird = self.dataModelManager.fetch(entityName: SDWBird.entityName(), predicate: predicate, context: self.dataModelManager.viewContext) as? SDWBird
        
        if let bird = currentBird {
            let currentBirdItem = BirdDisplayItem(model: bird)
            return currentBirdItem
        }
        
        return nil
        
    }
    
    public func setupCurrentBird(remoteID:String) {
        
        
        
        let birds:[SDWBird] = self.dataModelManager.fetchAll(entityName: SDWBird.entityName(), predicate: nil, context: self.dataModelManager.viewContext) as! [SDWBird]
        
        for b:SDWBird in birds {
            b.current = false
        }
        
        
        let predicate = NSPredicate(format: "remoteID = %@", remoteID)
        let bird:SDWBird = self.dataModelManager.fetch(entityName: SDWBird.entityName(), predicate: predicate, context: self.dataModelManager.viewContext) as! SDWBird
        
        bird.current = true

        self.dataModelManager.saveContext()
        
    }
    
    public func currentTodayItemForBird(bird_id:String, inSeason:String) -> DiaryItemDisplayItem? {
        
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)! // eg. 2016-10-11 00:00:00
        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

        
        let datePredicate = NSPredicate(format: "(%@ <= createdAt) AND (createdAt < %@) AND bird.remoteID == %@ AND season.remoteID == %@", argumentArray: [dateFrom, dateTo, bird_id, inSeason])
        

        
        let currentItem = self.dataModelManager.fetch(entityName: SDWDiaryItem.entityName(), predicate: datePredicate, context: self.dataModelManager.viewContext) as? SDWDiaryItem
        
        if let item = currentItem {
            return DiaryItemDisplayItem(model: item)
        }
        
        return nil
        
    }
    
    
    public func currentSeason() -> SeasonDisplayItem? {
        let predicate = NSPredicate(format: "%K = %@", "current", NSNumber(booleanLiteral: true))
        
        let currentSeason = self.dataModelManager.fetch(entityName: SDWSeason.entityName(), predicate: predicate, context: self.dataModelManager.viewContext) as? SDWSeason
        
        if let season = currentSeason {
            let currentSeasonItem = SeasonDisplayItem(model: season)
            return currentSeasonItem
        }
        
        return nil
        
    }
    
    public func removeCurrentDiaryItem() {
        
        let predicate = NSPredicate(format: "%K = %@", "current", NSNumber(booleanLiteral: true))
        
        let seasons = self.dataModelManager.fetchAll(entityName: SDWSeason.entityName(), predicate: predicate, context: self.dataModelManager.viewContext) as? [SDWSeason]
        
        
        for se:SDWSeason in seasons! {
            se.current = false
        }
        
        self.dataModelManager.saveContext()
        
        
        
    }
    
    
    public func removeCurrentSeason() {
        
        let predicate = NSPredicate(format: "%K = %@", "current", NSNumber(booleanLiteral: true))
        
        let seasons = self.dataModelManager.fetchAll(entityName: SDWSeason.entityName(), predicate: predicate, context: self.dataModelManager.viewContext) as? [SDWSeason]
        
        
        for se:SDWSeason in seasons! {
            se.current = false
        }
        
        self.dataModelManager.saveContext()
        
        
        
    }
    
    
    public func removeCurrentBird() {
        
        let predicate = NSPredicate(format: "%K = %@", "current", NSNumber(booleanLiteral: true))
        
        let birds = self.dataModelManager.fetchAll(entityName: SDWBird.entityName(), predicate: predicate, context: self.dataModelManager.viewContext) as? [SDWBird]
        
        
        for be:SDWBird in birds! {
            be.current = false
        }
        
        self.dataModelManager.saveContext()
        
        
        
    }
    
    
    public func setupCurrentSeason(remoteID:String) {
        
        let predicate = NSPredicate(format: "%K = %@", "current", NSNumber(booleanLiteral: true))
        
        let currentBird = self.dataModelManager.fetch(entityName: SDWBird.entityName(), predicate: predicate, context: self.dataModelManager.viewContext) as? SDWBird
        
        let birdSeasons:[SDWSeason] = currentBird?.seasons?.allObjects as! [SDWSeason]
        
        for se:SDWSeason in birdSeasons {
            se.current = false
        }
        
        let seasonPredicate = NSPredicate(format: "%K = %@", "remoteID", remoteID)
        let season:SDWSeason = self.dataModelManager.fetch(entityName: SDWSeason.entityName(), predicate: seasonPredicate, context: self.dataModelManager.viewContext) as! SDWSeason
        
        season.current = true
        
        self.dataModelManager.saveContext()
        
        
        
    }
    
    
    public func allPinTypes() -> [PinTypeDisplayItem] {
        let types = self.dataModelManager.fetchAll(entityName: PinType.entityName(), predicate: nil, context: self.dataModelManager.viewContext) as! [PinType]
        let items = types.map({ (item: PinType) -> PinTypeDisplayItem in
            PinTypeDisplayItem(model: item)
        })
        return items
    }
    
    
    public func allPins() -> [PinItemDisplayItem] {
        let types = self.dataModelManager.fetchAll(entityName: SDWPinItem.entityName(), predicate: nil, context: self.dataModelManager.viewContext) as! [SDWPinItem]
        let items = types.map({ (item: SDWPinItem) -> PinItemDisplayItem in
            PinItemDisplayItem(model: item)
        })
        return items
    }
    
    
    
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
                    
                    
                    guard let _ = objects, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        completion(nil,error)
                        return
                    }

                    self.pullAllPinItemTypes(currentData: { (objects, error) in
                        
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
                    
                })
                
  
                
            }
            
        }
        

    }
    
    public func logout() {
        
        UserDefaults.standard.removeObject(forKey: "access-token")
        UserDefaults.standard.removeObject(forKey: "expiry")
        UserDefaults.standard.removeObject(forKey: "client")
        UserDefaults.standard.removeObject(forKey: "uid")
        
        
        self.dataModelManager.deleteAllEntitiesWithName(name: "SDWSeason")
        self.dataModelManager.deleteAllEntitiesWithName(name: "SDWUser")
        self.dataModelManager.viewContext.processPendingChanges()
        self.dataModelManager.saveContext()
        
        
//        self.dataModelManager.fetch(entityDescription: SDWUser.entity(), predicate: nil, context: self.dataModelManager.viewContext) { (user, error) in
//            
////            let birds = (user as! SDWUser).birds
////            let seasons = (user as! SDWUser).seasons
////            
////            for bird in birds! {
////                self.dataModelManager.viewContext.delete(bird as! NSManagedObject)
////            }
////            
////            
////            for season in seasons! {
////                self.dataModelManager.viewContext.delete(season as! NSManagedObject)
////            }
////         
//            
//            self.dataModelManager.deleteAllEntitiesWithName(name: "SDWSeason")
////            self.dataModelManager.deleteAllEntitiesWithName(name: "SDWDiaryItem")
//            self.dataModelManager.viewContext.delete(user as! NSManagedObject)
//            self.dataModelManager.viewContext.processPendingChanges()
//            
//            
//            
////            self.dataModelManager.saveContext()
//        }
        
        
    }
    
    
    public func pullUserWithID(user_id:String,completion:@escaping sdw_id_error_block) {
        
        self.networkManager.fetchUserWithID(user_id:user_id) { (object, error) in
            
            guard let data = object, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
            let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWUser()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
            self.dataModelManager.saveContext()
            
            completion(UserDisplayItem.init(model:mappedObject as! SDWUser),nil)
            
        }
    }
    
    
    public func setSunsetTimeForCurrentUser() {
        
        Location.getLocation(accuracy: .block, frequency: .oneShot, success: { (request, location:CLLocation) -> (Void) in
            
            let currentUser = self.currentUser()
            let solar = Solar(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            currentUser?.model.sunsetTime = solar?.sunset
            self.dataModelManager.saveContext()
            
        }, error: { (request, location, error) -> (Void) in
            
            print(error.localizedDescription)
        })
    }

    
    public func pullCurrentUser() {
        
//        self.networkManager.fetchUserWithID(user_id:(self.currentUser()?.remoteID)!) { (object, error) in
//            
//            guard let data = object, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            
//            _ = SDWMapper.ez_object(withClass: type(of: SDWUser()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
//            self.dataModelManager.saveContext()
//            
//            
//        }
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
    
    
    public func updateCurrentUserWith(metric:Bool,completion:@escaping sdw_id_error_block) {
        
        self.networkManager.putUserWithID(user_id: (self.currentUser()?.remoteID)!, metric:metric) { (object, error) in
            
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
        
        let predicate = NSPredicate(format: "remoteID = %@", remoteID)
        
        self.dataModelManager.fetch(entityDescription: SDWBird.entity(), predicate: predicate, context: self.dataModelManager.viewContext) { (object, error) in
            
            let bird:SDWBird = object as! SDWBird
            self.dataModelManager.viewContext.delete(bird)
        }

    }
    
    
    public func updateDiaryItemWith(itemID:String,
                                  note:String?,
                                  quarryTypes:[QuarryTypeDisplayItem]?,
                                  foodItems:[DiaryFoodItemDisplayItem]?,
                                  weightItems:[DiaryWeightItemDisplayItem]?,
                                  pinItems:[PinItemDisplayItem]?,
                                  completion:@escaping sdw_id_error_block) {
        
        
        var quarryTypeIDs = [String]()
        if let quarry = quarryTypes {
            quarryTypeIDs = quarry.map({ (item: QuarryTypeDisplayItem) -> String in
                item.remoteID
            })
        }
        
        
        
        self.networkManager.updateDiaryItemWith(foodItems:foodItems,weightItems:weightItems,pinItems:pinItems, itemID:itemID, quarryTypeIDs:quarryTypeIDs, note:note, completion: {(object, error) in
            
            
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
                                  foodItems:[DiaryFoodItemDisplayItem]?,
                                  weightItems:[DiaryWeightItemDisplayItem]?,
                                  pinItems:[PinItemDisplayItem]?,
                                  createdDate:Date?,                                  completion:@escaping sdw_id_error_block) {
        
        
        var quarryTypeIDs = [String]()
        if let quarry = quarryTypes {
            quarryTypeIDs = quarry.map({ (item: QuarryTypeDisplayItem) -> String in
                item.remoteID
            })
        }

        
        self.networkManager.createDiaryItemWith(season_id:self.currentSeason()!.remoteID, foodItems:foodItems,weightItems:weightItems,pinItems:pinItems,birdID:birdID, quarryTypeIDs:quarryTypeIDs, note:note, createdDate: createdDate, completion: {(object, error) in
            
            
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
    
    public func pushFoodWith(name:String, completion:@escaping sdw_id_error_block) {
        
        
        

        self.networkManager.createFoodWith(name:name, completion: {(object, error) in
                
                
                guard let data = object, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(nil,error)
                    return
                }
                
                
                let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWFood()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
                self.dataModelManager.saveContext()
                
                completion(FoodDisplayItem.init(model: mappedObject as! SDWFood),nil)
                
            })
        
        
    }
    
    
    public func pushQuarryWith(name:String, completion:@escaping sdw_id_error_block) {
        
        
        
        
        self.networkManager.createQuarryWith(name:name, completion: {(object, error) in
            
            
            guard let data = object, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
            
            let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWQuarryType()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
            self.dataModelManager.saveContext()
            
            completion(QuarryTypeDisplayItem.init(model: mappedObject as! SDWQuarryType),nil)
            
        })
        
        
    }
    
    
    public func pushSeasonWith(season_id:String?, bird_id:String,
                             start:Date,
                             end:Date?,
                             isBetween:Bool,
                             completion:@escaping sdw_id_error_block) {
        
        
        
        if (season_id != nil) {
            
            
            self.networkManager.updateSeasonWith(season_id:season_id!, bird_id:bird_id,start:start,end:end,isBetween:isBetween, completion: {(object, error) in
                
                
                guard let data = object, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(nil,error)
                    return
                }
                
                
                let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWSeason()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
                self.dataModelManager.saveContext()
                
                completion(mappedObject,nil)
                
            })
            
        } else {
            self.networkManager.createSeasonWith(bird_id:bird_id,start:start,end:end,isBetween:isBetween, completion: {(object, error) in
                
                
                guard let data = object, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(nil,error)
                    return
                }
                
                
                let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWSeason()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
                self.dataModelManager.saveContext()
                
                completion(mappedObject,nil)
                
            })
        }
        

        
    }
    
    public func removeSeason(season_id:String, completion:@escaping sdw_id_error_block) {
        
        let block:sdw_id_error_block = { object, error in
            
            guard let data = object, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
            
            let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWSeason()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
            self.dataModelManager.saveContext()
            
            completion(SeasonDisplayItem.init(model: mappedObject as! SDWSeason),nil)
        }
        
        
        self.networkManager.deleteSeason(season_id: season_id, completion: block)
    }
    
    public func pushBirdStatus(birdItem:BirdDisplayItem, status:BirdStatus, completion:@escaping sdw_id_error_block) {
        
        let block:sdw_id_error_block = { object, error in
        
            guard let data = object, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(nil,error)
                return
            }
            
            
            let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWBird()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
            self.dataModelManager.saveContext()
            
            completion(BirdDisplayItem.init(model: mappedObject as! SDWBird),nil)
        }
        
        switch status {
        case .deleted:
            if(birdItem.model.wasDeleted == nil) {
                self.networkManager.updateBirdStatus(bird_id: birdItem.remoteID, status: .delete, completion: block)
            } else {
                self.networkManager.updateBirdStatus(bird_id: birdItem.remoteID, status: .undelete, completion: block)
            }
            break
        case .killed:
            if(birdItem.model.dead == nil) {
                self.networkManager.updateBirdStatus(bird_id: birdItem.remoteID, status: .kill, completion: block)
            } else {
                self.networkManager.updateBirdStatus(bird_id: birdItem.remoteID, status: .unkill, completion: block)
            }
            break
        case .sold:
            if(birdItem.model.sold == nil) {
                self.networkManager.updateBirdStatus(bird_id: birdItem.remoteID, status: .sell, completion: block)
            } else {
                self.networkManager.updateBirdStatus(bird_id: birdItem.remoteID, status: .unsell, completion: block)
            }
            break
        default:
            break
        }
    }

    public func pushBirdWith(bird_id:String?,
                             code:String?,
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
        
        
        if( bird_id != nil ) {
            
            self.networkManager.updateBirdWith(bird_id:bird_id!, birdTypeIDs:birdTypeIDs, code: code, sex: sex, name: name, birthday: birthday, fatWeight: fatWeight, huntingWeight: huntingWeight, image: image, completion: {(object, error) in
                
                
                guard let data = object, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(nil,error)
                    return
                }
                
                
                let mappedObject = SDWMapper.ez_object(withClass: type(of: SDWBird()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext)
                self.dataModelManager.saveContext()
                
                completion(BirdDisplayItem.init(model: mappedObject as! SDWBird),nil)
                
            })
            
        } else {
            self.networkManager.createBirdWith(birdTypeIDs:birdTypeIDs, code: code, sex: sex, name: name, birthday: birthday, fatWeight: fatWeight, huntingWeight: huntingWeight, image: image, completion: {(object, error) in
                
                
                guard let data = object, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(nil,error)
                    return
                }
                
                
                let mappedObject:SDWBird = SDWMapper.ez_object(withClass: type(of: SDWBird()) as SDWObjectMapping.Type, fromJSON: data as! Dictionary<AnyHashable, Any>, context: self.dataModelManager.viewContext) as! SDWBird
                self.dataModelManager.saveContext()
                
                completion(BirdDisplayItem.init(model: mappedObject),nil)
                
            })
        }
        

        
    }
    
    public func pullAllPinItemTypes(currentData:sdw_id_error_block,fetchedData:@escaping sdw_id_error_block) {
        
        
        
        self.dataModelManager.fetchAll(entityName:PinType.entityName(), predicate: nil, context: self.dataModelManager.viewContext) { (objects, error) in
            
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                currentData(nil,error)
                return
            }
            
            
            let arr:Array<PinType> = data as! Array
            var displayItemsArray = [PinTypeDisplayItem]()
            
            
            for obj in arr {
                let displayItem:PinTypeDisplayItem = PinTypeDisplayItem(model: obj)
                displayItemsArray.append(displayItem)
            }
            
            currentData(displayItemsArray,nil)
            
            self.networkManager.fetchPinItemTypes(completion: { (objects, error) in
                
                
                guard let data = objects, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    fetchedData(nil,error)
                    return
                }
                
                
                let mappedObjects = SDWMapper.ez_arrayOfObjects(withClass: type(of: PinType()) as SDWObjectMapping.Type, fromJSON: data as! Array<Any>, context: self.dataModelManager.viewContext)
                
                
                
                var displayItemsArray = [PinTypeDisplayItem]()
                
                
                for obj in mappedObjects {
                    let displayItem:PinTypeDisplayItem = PinTypeDisplayItem(model: obj as! PinType)
                    displayItemsArray.append(displayItem)
                }
                
                
                fetchedData(displayItemsArray,nil)
                
                
                
                
            })
            
            
        }
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
    
    
    public func pullAllPhotos(currentData:sdw_id_error_block,fetchedData:@escaping sdw_id_error_block) {
        
        
        self.dataModelManager.fetchAll(entityName:SDWDiaryPhoto.entityName(), predicate: nil, context: self.dataModelManager.viewContext) { (objects, error) in
            
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                currentData(nil,error)
                return
            }
            
            
            let arr:Array<SDWDiaryPhoto> = data as! Array
            var displayItemsArray = [DiaryPhotoDisplayItem]()
            
            
            for obj in arr {
                let displayItem:DiaryPhotoDisplayItem = DiaryPhotoDisplayItem(model: obj )
                displayItemsArray.append(displayItem)
            }
            
            currentData(displayItemsArray,nil)
            
            
            
            self.networkManager.fetchPhotosForBird(bird:self.currentBird()!, completion: { (objects, error) in
                
                
                guard let data = objects, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    fetchedData(nil,error)
                    return
                }
                
                
                let mappedObjects = SDWMapper.ez_arrayOfObjects(withClass: type(of: SDWDiaryPhoto()) as SDWObjectMapping.Type, fromJSON: data as! Array<Any>, context: self.dataModelManager.viewContext)
                
                
                var displayItemsArray = [DiaryPhotoDisplayItem]()
                
                
                for obj in mappedObjects {
                    let displayItem:DiaryPhotoDisplayItem = DiaryPhotoDisplayItem(model: obj as! SDWDiaryPhoto )
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
