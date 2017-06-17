//
//  Models.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit


class DiaryWeightItemDisplayItem: NSObject {
    var remoteID:String?
    var time:Date?
    var weight:Int16?
    var timeFormatter = DateFormatter()
    var timeString:String?
    
    public private(set) var model:SDWDiaryWeight?
    
    init(weight:Int16,time:Date) {
        self.weight = weight
        self.time = time
        timeFormatter.dateStyle = .none
        timeFormatter.dateFormat = "H:mm"
        self.timeString = timeFormatter.string(from: self.time!)
    }
    
    init(model:SDWDiaryWeight) {
        self.model = model
        self.weight = self.model?.weight
        self.time = self.model?.time! as! Date
        self.remoteID = self.model?.remoteID!
        
        timeFormatter.dateStyle = .none
        timeFormatter.dateFormat = "H:mm"
        self.timeString = timeFormatter.string(from: self.time!)
    }
    
    func serialization() -> Dictionary<String, Any> {
        
        if (self.remoteID != nil) {
            return ["id":self.remoteID, "time":timeFormatter.string(from: self.time!),"weight":self.weight]
        }
        
        return ["time":timeFormatter.string(from: self.time!),"weight":self.weight]
    }
    
}

class DiaryFoodItemDisplayItem: NSObject {
    var remoteID:String?
    var time:Date?
    var food:FoodDisplayItem?
    var amountEaten:Int16?
    var timeFormatter = DateFormatter()
    var timeString:String?
    
    public private(set) var model:SDWDiaryFood?
    
    init(amount:Int16,food:FoodDisplayItem,time:Date) {
        self.amountEaten = amount
        self.food = food
        self.time = time
        timeFormatter.dateStyle = .none
        timeFormatter.dateFormat = "H:mm"
        self.timeString = timeFormatter.string(from: self.time!)
    }
    
    init(model:SDWDiaryFood) {
        self.model = model
        self.amountEaten = self.model?.amountEaten
        if (self.model?.food != nil) {
            self.food = FoodDisplayItem(model: (self.model?.food!)!)
        }
        
        timeFormatter.dateStyle = .none
        timeFormatter.dateFormat = "H:mm"
        
        self.time = self.model?.time! as! Date
        self.timeString = timeFormatter.string(from: self.time!)
        
        self.remoteID = self.model?.remoteID!
    }
    
    
    func serialization() -> Dictionary<String, Any> {
        
         if (self.remoteID != nil) {
            
            return ["id":self.remoteID,"time":timeFormatter.string(from: self.time!),"eaten":self.amountEaten,"food_id":self.food?.remoteID]
        }
        return ["time":timeFormatter.string(from: self.time!),"eaten":self.amountEaten,"food_id":self.food?.remoteID]
        
    }
    
}

class FoodDisplayItem: NSObject, SearchableItem {
    var remoteID:String
    var name:String?
    var popular:Bool = false
    public private(set) var model:SDWFood
    
    
    override var description: String {
        return name!
    }
    
    init(model:SDWFood) {
        self.model = model
        self.name = self.model.name
        self.popular = self.model.popular
        self.remoteID = self.model.remoteID!
    }
    
    func matchesSearchQuery(_ query: String) -> Bool {
        
        let tmp: String = name!
        let range = tmp.range(of: query, options: NSString.CompareOptions.caseInsensitive)
        return range?.isEmpty == false
    }
    
    
}


class PinTypeDisplayItem: NSObject {
    var remoteID:String?
    var title:String?
    public private(set) var model:PinType
    
    init(model:PinType) {
        self.model = model
        self.title = self.model.title
        self.remoteID = self.model.remoteID!
    }
    
    
    
}


class UserDisplayItem: NSObject {
    var remoteID:String?
    var name:String?
    var metric:Bool?
    var email:String?
    public private(set) var model:SDWUser
    
    init(model:SDWUser) {
        self.model = model
        self.name = self.model.name
        self.email = self.model.email
        self.metric = self.model.metric
        self.remoteID = self.model.remoteID!
    }
    
    
    
}


class PinItemDisplayItem: NSObject {
    var remoteID:String?
    var note:String?
    var typeName:String?
    var lat:Double?
    var long:Double?
    var thumbURL:String?
    var imageURL:String?
    var pintype: PinTypeDisplayItem?
    public private(set) var model:SDWPinItem?

    init(model:SDWPinItem) {
        self.model = model
        self.note = self.model?.note
        self.remoteID = self.model?.remoteID!
        self.imageURL = self.model?.imageURL
        self.thumbURL = self.model?.thumbURL
        self.lat = self.model?.lat as? Double
        self.long = self.model?.long as? Double
        self.typeName = self.model?.pinTypeName
        if (self.model?.pintype != nil) {
            self.pintype = PinTypeDisplayItem(model:(self.model?.pintype!)!)
        }
        
    }
    
    init(note:String?,type:PinTypeDisplayItem,lat:Double, long:Double) {
        self.note = note
        self.pintype = type
        self.long = long
        self.lat = lat
    }
    
    func serialization() -> Dictionary<String, Any> {
        
        if (self.remoteID != nil) {
            return ["id":self.remoteID, "lat":self.lat,"long":self.long,"note":self.note, "pin_item_type_id":self.pintype?.remoteID]
        }
        
        return ["lat":self.lat,"long":self.long,"note":self.note, "pin_item_type_id":self.pintype?.remoteID]
    }
    
}


class QuarryTypeDisplayItem: NSObject, SearchableItem {
    var remoteID:String
    var name:String?
    public private(set) var model:SDWQuarryType
    
    override var description: String {
        return name!
    }
    
    init(model:SDWQuarryType) {
        self.model = model
        self.name = self.model.name
        self.remoteID = self.model.remoteID!
    }
    
    func matchesSearchQuery(_ query: String) -> Bool {
        
        let tmp: String = name!
        let range = tmp.range(of: query, options: NSString.CompareOptions.caseInsensitive)
        return range?.isEmpty == false
        
    }
    
}

class BirdDisplayItem: NSObject {
    
    var remoteID:String
    var sex:Bool?
    var current:Bool?
    var name:String?
    var birthdayString:String?
    var birdTypesString:String?
    var birthday:Date?
    var code:String?
    var thumbURL:String?
    var imageURL:String?
    var gender:String?
    var fatWeight:Int16?
    var huntingWeight:Int16?
    var status:BirdStatus = .active
    var birdTypes:Array<BirdTypeDisplayItem>?
    var seasons = [SeasonDisplayItem]()
    public private(set) var model:SDWBird
    
    var birthdayDateFormatter = DateFormatter()
    
    init(model:SDWBird) {
        self.model = model
        
        birthdayDateFormatter.dateStyle = .none
        birthdayDateFormatter.dateFormat = "yyyy-mm-dd"
        
        let arr:Array<SDWBirdType> = self.model.types?.allObjects as! Array<SDWBirdType>
        
        let birdTypeStrings:Array = arr.map({ (item: SDWBirdType) -> String in
            item.name!
        })
        
        let birdTypeItems:Array = arr.map({ (item: SDWBirdType) -> BirdTypeDisplayItem in
            BirdTypeDisplayItem(model: item)
        })
        
        let seasonArr:Array<SDWSeason> = self.model.seasons?.allObjects as! Array<SDWSeason>
        
        var seasonItems:Array = seasonArr.map({ (item: SDWSeason) -> SeasonDisplayItem in
            SeasonDisplayItem(model: item)
        })
        
         seasonItems = seasonItems.filter({$0.wasDeleted == nil})
        
        self.seasons = seasonItems
        self.birdTypes = birdTypeItems
        
        self.birdTypesString = birdTypeStrings.joined(separator: ", ")
        self.remoteID = model.remoteID!
        self.sex = model.isMale
        self.birthday = model.birthday as Date?
        self.code = model.code
        self.fatWeight = model.fatWeight
        self.huntingWeight = model.huntingWeight
        self.imageURL = model.imageURL
        self.thumbURL = model.thumbURL
        self.current = self.model.current
        self.name = model.name
        self.gender = (self.sex == true) ? "Male" : "Female"
        if (self.birthday != nil) {
            self.birthdayString = self.birthdayDateFormatter.string(from: self.birthday!)
        }
        
        
        
        if (self.model.dead != nil) {
            self.status = .killed
        }
        
        if (self.model.wasDeleted != nil) {
            self.status = .deleted
        }
        
        if (self.model.sold != nil) {
            self.status = .sold
        }
        
    }
    
    
    public func currentSeasons() -> [SeasonDisplayItem] {
        let predicate = NSPredicate(format: "remoteID = %@", self.remoteID)
        
        let bird:SDWBird =  DataModelManager.sharedInstance.fetch(entityName: SDWBird.entityName(), predicate: predicate, context:  DataModelManager.sharedInstance.viewContext) as! SDWBird
        self.model = bird
        var seasonItems = [SeasonDisplayItem]()
        
        if ((self.model.seasons) != nil) {
            var seasonArr:Array<SDWSeason> = self.model.seasons?.allObjects as! Array<SDWSeason>
            seasonArr = seasonArr.filter({$0.wasDeleted == nil})
            
            seasonItems = seasonArr.map({ (item: SDWSeason) -> SeasonDisplayItem in
            SeasonDisplayItem(model: item)
            })
        }

        return seasonItems
    }
    
    public func currentDiaryItems() -> [DiaryItemDisplayItem] {
        let arr:Array<SDWDiaryItem> = self.model.diaryItems?.allObjects as! Array<SDWDiaryItem>
        
        let items:Array = arr.map({ (item: SDWDiaryItem) -> DiaryItemDisplayItem in
            DiaryItemDisplayItem(model: item)
        })
        return items
    }
    
    
    public func isViewOnly() -> Bool {
        
        return (self.model.dead != nil || self.model.sold != nil || self.model.wasDeleted != nil)
    }
}

class BirdTypeDisplayItem: NSObject, SearchableItem {
    
    
    var name:String?
    var remoteID:String
    var isPopular:Bool
    
    public private(set) var model:SDWBirdType
    
    var birthdayDateFormatter = DateFormatter()
    
    override var description: String {
        return name!
    }
    
    
    func matchesSearchQuery(_ query: String) -> Bool {
        
        let tmp: String = name!
        let range = tmp.range(of: query, options: NSString.CompareOptions.caseInsensitive)
        return range?.isEmpty == false
    }
    
    init(model:SDWBirdType) {
        self.model = model
        self.remoteID = model.remoteID!
        self.name = model.name
        self.isPopular = model.isPopular
        
        
        
    }
}

class SeasonDisplayItem: NSObject {
    
    var dateFormatter = DateFormatter()

    
    var isBetweenSeason:Bool?
    var current:Bool?
    var startDateString:String?
    var endDateString:String?
    var start:Date?
    var end:Date?
    var wasDeleted:NSDate?
    var remoteID:String
    
    public private(set) var model:SDWSeason
    
    var birthdayDateFormatter = DateFormatter()
    
    
    init(model:SDWSeason) {
        self.model = model
        self.remoteID = model.remoteID!
        
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        self.start = self.model.startDate as Date?
        self.end = self.model.endDate as Date?
        self.current = self.model.current
        self.wasDeleted = self.model.wasDeleted
        
        self.isBetweenSeason = self.model.isBetweenSeason
        
        self.startDateString = self.model.startDateString
        self.endDateString = self.model.endDateString
        
        
        
    }
    
    public func isViewOnly() -> Bool {
        
        return (self.model.wasDeleted != nil)
    }
}


class DiaryItemDisplayItem: NSObject {
    
    var dateFormatter = DateFormatter()
    
    var note:String?
    var created:String
    var remoteID:String
    var foods:Array<DiaryFoodItemDisplayItem>?
    var pins:Array<PinItemDisplayItem>?

    var weights:Array<DiaryWeightItemDisplayItem>?
    var quarryTypes:Array<QuarryTypeDisplayItem>?
    
    public private(set) var model:SDWDiaryItem
    
    var birthdayDateFormatter = DateFormatter()
    

    init(model:SDWDiaryItem) {
        
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        
        self.model = model
        self.remoteID = model.remoteID!
        self.note = model.note
        self.created = self.dateFormatter.string(from: self.model.createdAt! as Date)
        
        let foodsArr:Array<SDWDiaryFood> = self.model.foods?.allObjects as! Array<SDWDiaryFood>
        let foods:Array = foodsArr.map({ (item: SDWDiaryFood) -> DiaryFoodItemDisplayItem in
            DiaryFoodItemDisplayItem(model: item)
        })
        
        let weightsArr:Array<SDWDiaryWeight> = self.model.weights?.allObjects as! Array<SDWDiaryWeight>
        let weights:Array = weightsArr.map({ (item: SDWDiaryWeight) -> DiaryWeightItemDisplayItem in
            DiaryWeightItemDisplayItem(model: item)
        })
        
        let quarryArr:Array<SDWQuarryType> = self.model.quarryTypes?.allObjects as! Array<SDWQuarryType>
        let quarry:Array = quarryArr.map({ (item: SDWQuarryType) -> QuarryTypeDisplayItem in
            QuarryTypeDisplayItem(model: item)
        })
        
        
        let pinsArr:Array<SDWPinItem> = self.model.pins?.allObjects as! Array<SDWPinItem>
        let pins:Array = pinsArr.map({ (item: SDWPinItem) -> PinItemDisplayItem in
            PinItemDisplayItem(model: item)
        })
        
        self.pins = pins
        
        self.quarryTypes = quarry
        self.foods = foods
        self.weights = weights
        
        
        
        
        
    }
}



class ListDisplayItem: NSObject {
    
    var first:String?
    var sub:String?
    var imageURL:String?
    var model:Dictionary<String,Any>?
    
    override init() {
        super.init()
        
    }
}

class TypeDisplayItem: NSObject, SearchableItem {
    var name:String?
    var latin:String?
    var model:Dictionary<String,Any>?
    
    override var description: String {
        return name!
    }
    
    
    func matchesSearchQuery(_ query: String) -> Bool {
        
        let tmp: String = name!
        let range = tmp.range(of: query, options: NSString.CompareOptions.caseInsensitive)
        return range?.isEmpty == false
        
    }
}
