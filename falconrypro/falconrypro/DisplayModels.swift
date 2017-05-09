//
//  Models.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit


class BirdDisplayItem: NSObject {
    
    var remoteID:String
    var sex:Bool?
    var name:String?
    var birthdayString:String?
    var birthday:Date?
    var code:String?
    var thumbURL:String?
    var imageUrl:String?
    var gender:String?
    var fatWeight:Int16?
    var huntingWeight:Int16?
    public private(set) var model:SDWBird
    
    var birthdayDateFormatter = DateFormatter()
    
    init(model:SDWBird) {
        self.model = model
        
        birthdayDateFormatter.dateStyle = .none
        birthdayDateFormatter.dateFormat = "yyyy-mm-dd"
        
        self.remoteID = model.remoteID!
        self.sex = model.isMale
        self.birthday = model.birthday as Date?
        self.code = model.code
        self.huntingWeight = model.huntingWeight
        self.imageUrl = model.imageURL
        self.thumbURL = model.thumbURL
        self.name = model.name
        self.birthdayString = self.birthdayDateFormatter.string(from: self.birthday!)
        
        
        
        
    }
}

class BirdTypeDisplayItem: NSObject, SearchableItem {
    
    var name:String?
    var remoteID:String
    
    public private(set) var model:SDWBird
    
    var birthdayDateFormatter = DateFormatter()
    
    override var description: String {
        return name!
    }
    
    
    func matchesSearchQuery(_ query: String) -> Bool {
        
        let tmp: String = name!
        let range = tmp.range(of: query, options: NSString.CompareOptions.caseInsensitive)
        return range?.isEmpty == false
    }
    
    init(model:SDWBird) {
        self.model = model
        self.remoteID = model.remoteID!
        self.name = model.name
        
        
        
        
    }
}

class DiaryListDisplayItem: NSObject {
    
    var note:String?
    var foodDisplayItem:TypeDisplayItem?
    var created:String?
    var model:Dictionary<String,Any>?
    
    override init() {
        super.init()
        
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
