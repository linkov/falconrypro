//
//  Models.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit


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
