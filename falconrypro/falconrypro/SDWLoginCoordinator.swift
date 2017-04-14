//
//  SDWLoginCoordinator.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/11/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Foundation
import ILLoginKit
import Networking
import PKHUD


class SDWLoginCoordinator: ILLoginKit.LoginCoordinator {

    // MARK: - LoginCoordinator
    var networking:Networking = Networking(baseURL: Constants.server.BASEURL)
    
    override func start() {
        super.start()
        configureAppearance()
    }
    
    override func finish() {
        super.finish()
    }
    
    // MARK: - Setup
    
    func configureAppearance() {
        // Customize LoginKit. All properties have defaults, only set the ones you want.
        
        // Customize the look with background & logo images
        backgroundImage = #imageLiteral(resourceName: "f3")
        // mainLogoImage =
        // secondaryLogoImage =
        
        // Change colors
        tintColor = UIColor.black
        errorTintColor = UIColor.lightGray
        
        // Change placeholder & button texts, useful for different marketing style or language.
        loginButtonText = "Sign In"
        signupButtonText = "Create Account"
        facebookButtonText = "Login with Facebook"
        forgotPasswordButtonText = "Forgot password?"
        recoverPasswordButtonText = "Recover"
        namePlaceholder = "Name"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Password"
        repeatPasswordPlaceholder = "Confirm password"
    }
    
    // MARK: - Completion Callbacks
    
    override func login(email: String, password: String) {
        // Handle login via your API
        
        networking.post("/auth/sign_in",parameters: ["email" : email, "password" : password])  { result in
            
            switch result {
            case .success(let response):
                print(response)
                self.configureHeaders(json: response.headers as NSDictionary)
                self.finish()
                
                
            case .failure(let response):
                print(response)
            }
            
        }
    }
    
    override func signup(name: String, email: String, password: String) {
        // Handle signup via your API

        
        networking.post("/auth",parameters: ["email" : email, "password" : password, "password_confirmation":password])  { result in
            
            switch result {
            case .success(let response):
                let json = response.headers
                self.configureHeaders(json: json as NSDictionary)
                
                self.login(email: email, password: password)
                
                
                
                
            case .failure(let response):
                 print(response)
            }

        }
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
            token = json["Access-Token"]!
            expires = json["Expiry"]!
            client = json["Client"]!
            uid = json["Uid"]!
        }
        
        if (isFacebook == true) {
            token = json["access-token"]!
        }

        
        networking.setAuthorizationHeader(headerKey: "access-token", headerValue:token as! String)
        networking.setAuthorizationHeader(headerKey: "client", headerValue:client as! String)
        networking.setAuthorizationHeader(headerKey: "uid", headerValue:uid as! String)
        networking.setAuthorizationHeader(headerKey: "expiry", headerValue:expires as! String)
        
        UserDefaults.standard.setValue(token, forKey: "access-token")
        UserDefaults.standard.setValue(expires, forKey: "expiry")
        UserDefaults.standard.setValue(client, forKey: "client")
        UserDefaults.standard.setValue(uid, forKey: "uid")

    }
    
    override func enterWithFacebook(profile: FacebookProfile) {
        // Handle Facebook login/signup via your API
      
        
        networking.get("/auth/facebook_access_token/callback?access_token="+profile.facebookToken)  { result in

            switch result {
            case .success(let response):
                let json = response.dictionaryBody
                print(json)
                
                self.configureHeaders(json: json as NSDictionary,isFacebook:true)
                
                self.finish()
                
                
            case .failure(let response):
                print(response)
            }
            
        }
        
    }
    
    override func recoverPassword(email: String) {
        // Handle password recovery via your API
        print("Recover password with: email =\(email)")
    }
}
