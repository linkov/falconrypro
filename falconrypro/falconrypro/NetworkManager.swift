//
//  NetworkManager.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/7/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Networking


enum BirdStatusNetworkAction: Int {
    case delete, sell, kill, undelete, unkill, unsell
}


public typealias sdw_id_error_block = (Any?, Error?) -> Swift.Void

class NetworkManager: NSObject {
    
    static let sharedInstance : NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()

    
    let networking:Networking = Networking(baseURL: Constants.server.BASEURL)
    
    public func signInWith(email:String,password:String, completion:@escaping sdw_id_error_block) {
        
        networking.post("/auth/sign_in",parameters: ["email" : email, "password" : password])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                self.configureHeaders(json: response.headers as NSDictionary)
                completion(response.dictionaryBody["data"],nil)
                
                
            case .failure(let response):
                completion(nil,response.error.localizedDescription as? Error)
                print(response)
            }
            
        }
    }

    
    public func signUpWith(email:String,password:String, completion:@escaping sdw_id_error_block) {
    
        networking.post("/auth",parameters: ["email" : email, "password" : password, "password_confirmation":password])  { result in
            switch result {
            case .success(let response):
                let json = response.headers
                self.configureHeaders(json: json as NSDictionary)
                completion(response.dictionaryBody["data"],nil)
                                
                
                
                
            case .failure(let response):
                print(response)
                completion(nil,response.error)
            }
            
        }
    }
    
    public func fetchBirdTypes(completion:@escaping sdw_id_error_block) {
        
        networking.get("/bird_types")  { result in
            
            switch result {
            case .success(let response):
                
                completion(response.arrayBody,nil)
                
            case .failure(let response):
                print(response)
                completion(nil,response.error)
            }
            
        }
    }
    
    public func fetchPinItemTypes(completion:@escaping sdw_id_error_block) {
        
        networking.get("/pin_item_types")  { result in
            
            switch result {
            case .success(let response):
                
                completion(response.arrayBody,nil)
                
            case .failure(let response):
                print(response)
                completion(nil,response.error)
            }
            
        }
    }
    
    public func createDiaryItemWith(season_id:String, foodItems:Array<DiaryFoodItemDisplayItem>?,weightItems:Array<DiaryWeightItemDisplayItem>?,pinItems:Array<PinItemDisplayItem>?, birdID:String, quarryTypeIDs:Array<String>?,note:String?, createdDate:Date?,
                                    completion:@escaping sdw_id_error_block) {
        self.setupRequestHeaders()
        
        var dict: [String: Any] = [
            "bird_id": birdID,
            "season_id":season_id,
            
        ]
        
        
        if let cdate = createdDate {
            dict["created_date"] = cdate.toString()
        }
        
        if let quarry = quarryTypeIDs {
            dict["quarry_type_ids"] = quarry
        }
        
        if let note = note {
            dict["note"] = note
        }
        
        
        if let foods = foodItems {
            
            var arrFood = [Dictionary<String,Any>]()
            for ff in foods {
                let itm = ff.serialization()
                arrFood.append(itm)
            }
            
            if (arrFood.count > 0) {
                dict["diary_foods_attributes"] = arrFood
            } else {
                dict["diary_foods_attributes"] = []
            }
        }
        
        if let weights = weightItems {
            
            var arrWeight = [Dictionary<String,Any>]()
            for ff in weights {
                let itm = ff.serialization()
                arrWeight.append(itm)
            }
            
            if(arrWeight.count > 0) {
                dict["diary_weights_attributes"] = arrWeight
            } else {
                dict["diary_weights_attributes"] = []
            }
        }
        
        
        if let pins = pinItems {
            
            var arrPin = [Dictionary<String,Any>]()
            for ff in pins {
                let itm = ff.serialization()
                arrPin.append(itm)
            }
            
            if (arrPin.count > 0) {
                 dict["pin_items_attributes"] = arrPin
            } else {
                dict["pin_items_attributes"] = []
            }
           
        }
        
        
        networking.post("/diary_items", parameters: ["diary_item":dict])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                completion(response.dictionaryBody,nil)
                
                
                
                
            case .failure(let response):
                print(response.dictionaryBody)
                completion(nil,response.error)
            }
            
        }
        
    }
    
    public func updateDiaryItemWith(foodItems:Array<DiaryFoodItemDisplayItem>?,weightItems:Array<DiaryWeightItemDisplayItem>?,pinItems:Array<PinItemDisplayItem>?, itemID:String, quarryTypeIDs:Array<String>?,note:String?,
                                    completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        var dict: [String: Any] = [:]
        
        if let quarry = quarryTypeIDs {
            dict["quarry_type_ids"] = quarry
        }
        
        if let note = note {
            dict["note"] = note
        }
        
        if let foods = foodItems {
            
            var arrFood = [Dictionary<String,Any>]()
            for ff in foods {
                let itm = ff.serialization()
                arrFood.append(itm)
            }
            
            if (arrFood.count > 0) {
                dict["diary_foods_attributes"] = arrFood
            } else {
                dict["diary_foods_attributes"] = []
            }
            
        }
        
        if let weights = weightItems {
            
            var arrWeight = [Dictionary<String,Any>]()
            for ff in weights {
                let itm = ff.serialization()
                arrWeight.append(itm)
            }
            if(arrWeight.count > 0) {
                dict["diary_weights_attributes"] = arrWeight
            } else {
                dict["diary_weights_attributes"] = []
            }
            
        }
        
        
        if let pins = pinItems {
            
            var arrPin = [Dictionary<String,Any>]()
            for ff in pins {
                let itm = ff.serialization()
                arrPin.append(itm)
            }
            
            if (arrPin.count > 0) {
                dict["pin_items_attributes"] = arrPin
            } else {
                dict["pin_items_attributes"] = []
            }
        }
        
        networking.put("/diary_items/"+itemID, parameters: ["diary_item":dict])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                completion(response.dictionaryBody,nil)
                
                
                
                
            case .failure(let response):
                print(response.dictionaryBody)
                completion(nil,response.error)
            }
            
        }
        
    }
    
    
    public func createBirdWith(birdTypeIDs:Array<String>,
                               code:String?,
                             sex:Bool,
                             name:String,
                             birthday:Date,
                             fatWeight:Int,
                             huntingWeight:Int,
                             image:NSData?, completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        let dict: [String: Any] = [
            "name": name,
            "sex": sex,
            "code": code ?? "",
            "fat_weight": fatWeight,
            "hunting_weight": huntingWeight,
            "birthday": birthday.toString(),
            "bird_type_ids":birdTypeIDs
            
            ]
        
        networking.post("/birds", parameters: ["bird":dict])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                completion(response.dictionaryBody,nil)
                
                
                
                
            case .failure(let response):
                print(response.dictionaryBody)
                completion(nil,response.error)
            }
            
        }
        
    }
    
    public func updateBirdStatus(bird_id:String, status:BirdStatusNetworkAction , completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        var dict: [String: Any] = [:]
        
        switch status {
        case .delete:
            dict["deleted"] = Date().toString()
            break;
        case .undelete:
            dict["deleted"] = ""
            break;
        case .kill:
            dict["dead"] = Date().toString()
            break;
        case .unkill:
            dict["dead"] = ""
            break;
        case .sell:
            dict["sold"] = Date().toString()
            break;
        case .unsell:
            dict["sold"] = ""
            break;

        }
        
        
        networking.put("/birds/"+bird_id, parameters: ["bird":dict])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                completion(response.dictionaryBody,nil)
                
                
                
                
            case .failure(let response):
                print(response.dictionaryBody)
                completion(nil,response.error)
            }
            
        }
        
    }
    
    
    public func updateBirdWith(bird_id:String, birdTypeIDs:Array<String>,
                               code:String?,
                               sex:Bool,
                               name:String,
                               birthday:Date,
                               fatWeight:Int,
                               huntingWeight:Int,
                               image:NSData?, completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        let dict: [String: Any] = [
            "name": name,
            "sex": sex,
            "code": code ?? "",
            "fat_weight": fatWeight,
            "hunting_weight": huntingWeight,
            "birthday": birthday.toString(),
            "bird_type_ids":birdTypeIDs
            
        ]
        
        networking.put("/birds/"+bird_id, parameters: ["bird":dict])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                completion(response.dictionaryBody,nil)
                
                
                
                
            case .failure(let response):
                print(response.dictionaryBody)
                completion(nil,response.error)
            }
            
        }
        
    }
    
    public func createSeasonWith(bird_id:String, start:Date,end:Date?,isBetween:Bool,completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        var dict: [String: Any] = [
            "start": start.toString(),
            "between": isBetween
            
        ]
        
        
        if let endDate = end  {
            dict["end"] = endDate.toString()
        }
        
        networking.post("/seasons?bird_id="+bird_id, parameters: ["season":dict])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                completion(response.dictionaryBody,nil)
                
                
                
                
            case .failure(let response):
                print(response.dictionaryBody)
                completion(nil,response.error)
            }
            
        }
        
    }
    
    
    public func createFoodWith(name:String,completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        let dict: [String: Any] = [
            "name": name
        ]
        

        networking.post("/foods", parameters: ["food":dict])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                completion(response.dictionaryBody,nil)
                
                
                
                
            case .failure(let response):
                print(response.dictionaryBody)
                completion(nil,response.error)
            }
            
        }
        
    }
    
    public func createQuarryWith(name:String,completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        let dict: [String: Any] = [
            "name": name
        ]
        
        
        networking.post("/quarry_types", parameters: ["quarry_type":dict])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                completion(response.dictionaryBody,nil)
                
                
                
                
            case .failure(let response):
                print(response.dictionaryBody)
                completion(nil,response.error)
            }
            
        }
        
    }
    
    
    public func updateSeasonWith(season_id:String, bird_id:String, start:Date,end:Date?,isBetween:Bool,completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        var dict: [String: Any] = [
            "start": start.toString(),
            "between": isBetween
            
        ]
        
        if let endDate = end  {
            dict["end"] = endDate.toString()
        }
        
        networking.put("/seasons/"+season_id+"?bird_id="+bird_id, parameters: ["season":dict])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                completion(response.dictionaryBody,nil)
                
                
                
                
            case .failure(let response):
                print(response.dictionaryBody)
                completion(nil,response.error)
            }
            
        }
        
    }
    
    
    public func fetchBirds(completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()

        self.networking.get("/birds")  { result in
  
            switch result {
            case .success(let response):
                print(response)
                print(response.arrayBody)
                completion(response.arrayBody,nil)

                
            case .failure(let response):
                completion(nil,response.error)
                print(response)
            }
            
        }
        
    }
    
    public func fetchFoods(completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        self.networking.get("/foods")  { result in
            
            switch result {
            case .success(let response):
                print(response)
                print(response.arrayBody)
                completion(response.arrayBody,nil)
                
                
            case .failure(let response):
                completion(nil,response.error)
                print(response)
            }
            
        }
        
    }
    
    public func fetchQuarryTypes(completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        self.networking.get("/quarry_types")  { result in
            
            switch result {
            case .success(let response):
                print(response)
                print(response.arrayBody)
                completion(response.arrayBody,nil)
                
                
            case .failure(let response):
                completion(nil,response.error)
                print(response)
            }
            
        }
        
    }
    
    public func fetchDiaryItemsForSeason(seasonID:String, completion:@escaping sdw_id_error_block) {
        
        self.setupRequestHeaders()
        
        self.networking.get("/diary_items?season_id="+seasonID)  { result in
            
            switch result {
            case .success(let response):
                print(response)
                print(response.arrayBody)
                completion(response.arrayBody,nil)
                
                
            case .failure(let response):
                completion(nil,response.error)
                print(response)
            }
            
        }
        
    }
    
    
    
    func setupRequestHeaders() {
        
        if ((UserDefaults.standard.value(forKey: "access-token")) == nil) {
            return
        }
        
        let token = UserDefaults.standard.value(forKey: "access-token")
        let expires = UserDefaults.standard.value(forKey: "expiry")
        let client = UserDefaults.standard.value(forKey: "client")
        let uid = UserDefaults.standard.value(forKey: "uid")
        
        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
        
    }
    
    
    func configureHeaders(json: NSDictionary, isFacebook: Bool? = false) {
        
        var token:Any
        var expires:Any
        var client:Any
        var uid:Any
        
        if (Constants.server.BASEURL == Constants.server.PROD) {
            token = json["access-token"]!
            expires = json["expiry"]!
            client = json["client"]!
            uid = json["uid"]!
        } else {
            
            if (isFacebook == true) {
                token = json["access-token"]!
                expires = json["expiry"]!
                client = json["client"]!
                uid = json["uid"]!
            } else {
                token = json["Access-Token"]!
                expires = json["Expiry"]!
                client = json["Client"]!
                uid = json["Uid"]!
            }
            
            
            
        }
        
        
        
        networking.setAuthorizationHeader(headerKey: "access-token", headerValue:token as! String)
        networking.setAuthorizationHeader(headerKey: "client", headerValue:client as! String)
        networking.setAuthorizationHeader(headerKey: "uid", headerValue:uid as! String)
        networking.setAuthorizationHeader(headerKey: "expiry", headerValue:expires as! String)
        
        self.networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
        
        UserDefaults.standard.setValue(token, forKey: "access-token")
        UserDefaults.standard.setValue(expires, forKey: "expiry")
        UserDefaults.standard.setValue(client, forKey: "client")
        UserDefaults.standard.setValue(uid, forKey: "uid")
        UserDefaults.standard.synchronize()
        
    }
}

