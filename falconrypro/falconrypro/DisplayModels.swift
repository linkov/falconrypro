//
//  Models.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit


class DiaryWeightItemDisplayItem: NSObject {
    var remoteID:String
    var time:Date?
    var weight:Int16?
    
    
    public private(set) var model:SDWDiaryWeight
    
    init(model:SDWDiaryWeight) {
        self.model = model
        self.weight = self.model.weight
        self.time = self.model.time! as Date
        self.remoteID = self.model.remoteID!
    }
    
}

class DiaryFoodItemDisplayItem: NSObject {
    var remoteID:String
    var time:Date?
    var food:FoodDisplayItem?
    var amountEaten:Int16?
    
    public private(set) var model:SDWDiaryFood
    
    init(model:SDWDiaryFood) {
        self.model = model
        self.amountEaten = self.model.amountEaten
        if (self.model.food != nil) {
            self.food = FoodDisplayItem(model: self.model.food!)
        }
        
        self.time = self.model.time as! Date
        self.remoteID = self.model.remoteID!
    }
    
}

class FoodDisplayItem: NSObject {
    var remoteID:String
    var name:String?
    public private(set) var model:SDWFood
    
    init(model:SDWFood) {
        self.model = model
        self.name = self.model.name
        self.remoteID = self.model.remoteID!
    }
    
}

class BirdDisplayItem: NSObject {
    
    var remoteID:String
    var sex:Bool?
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
    var birdTypes:Array<BirdTypeDisplayItem>?
    var seasons:Array<SeasonDisplayItem>?
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
        
        let seasonItems:Array = seasonArr.map({ (item: SDWSeason) -> SeasonDisplayItem in
            SeasonDisplayItem(model: item)
        })
        
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
        self.name = model.name
        self.gender = (self.sex == true) ? "Male" : "Female"
        self.birthdayString = self.birthdayDateFormatter.string(from: self.birthday!)
        
        
        
        
    }
}

class BirdTypeDisplayItem: NSObject, SearchableItem {
    
    
    var name:String?
    var remoteID:String
    
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
        
        
        
        
    }
}

class SeasonDisplayItem: NSObject {
    
    var dateFormatter = DateFormatter()

    
    var isBetweenSeason:Bool?
    var startDateString:String?
    var endDateString:String?
    var start:Date?
    var end:Date?
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
        
        self.isBetweenSeason = self.model.isBetweenSeason
        
        self.startDateString = self.model.startDateString
        self.endDateString = self.model.endDateString
        
        
        
    }
}


class DiaryItemDisplayItem: NSObject {
    
    var dateFormatter = DateFormatter()
    
    var note:String?
    var created:String
    var remoteID:String
    var foods:Array<DiaryFoodItemDisplayItem>?
    var weights:Array<DiaryWeightItemDisplayItem>?
    
    public private(set) var model:SDWDiaryItem
    
    var birthdayDateFormatter = DateFormatter()
    

    init(model:SDWDiaryItem) {
        
        dateFormatter.dateStyle = .none
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
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
