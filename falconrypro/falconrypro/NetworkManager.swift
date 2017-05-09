//
//  NetworkManager.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/7/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Networking

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
    
    
    public func createBirdWith(code:String?,
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
            "fat_weight": fatWeight,
            "hunting_weight": huntingWeight,
            "birthday": birthday.toString(),
            
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
    
    
    public func updateBirdWith(code:String?,
                               sex:Bool,
                               name:String,
                               birthday:Date,
                               fatWeight:Int,
                               huntingWeight:Int,
                               image:NSData?, completion:@escaping sdw_id_error_block) {
        
        
        
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
        
    }
}
