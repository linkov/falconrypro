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
        backgroundImage = #imageLiteral(resourceName: "mike-wilson-191639 copy")
        // mainLogoImage =
        // secondaryLogoImage =
        
        // Change colors
        tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
        
        // Change placeholder & button texts, useful for different marketing style or language.
        loginButtonText = "Sign In"
        signupButtonText = "Create Account"
        facebookButtonText = "Login with Facebook"
        forgotPasswordButtonText = "Forgot password?"
        recoverPasswordButtonText = "Recover"
        namePlaceholder = "Name"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Password!"
        repeatPasswordPlaceholder = "Confirm password!"
    }
    
    // MARK: - Completion Callbacks
    
    override func login(email: String, password: String) {
        // Handle login via your API
        PKHUD.sharedHUD.show()
        
        let networking = Networking(baseURL: "http://localhost:3000/api/v1")
        networking.post("/auth/sign_in",parameters: ["email" : email, "password" : password])  { result in
             PKHUD.sharedHUD.hide()
            switch result {
            case .success(let response):
                print(response)
                let json = response.dictionaryBody
                let token = response.headers["Access-Token"]
                let expires = response.headers["Expiry"]
                let client = response.headers["Client"]
                let uid = response.headers["Uid"]
                
                
                UserDefaults.standard.setValue(token, forKey: "access-token")
                UserDefaults.standard.setValue(expires, forKey: "expiry")
                UserDefaults.standard.setValue(client, forKey: "client")
                UserDefaults.standard.setValue(uid, forKey: "uid")

                
                self.finish()
                
                
            case .failure(let response):
                print(response)
            }
            
        }
    }
    
    override func signup(name: String, email: String, password: String) {
        // Handle signup via your API
        PKHUD.sharedHUD.show()
        
        let networking = Networking(baseURL: "http://localhost:3000/api/v1")
        networking.post("/auth",parameters: ["email" : email, "password" : password, "password_confirmation":password])  { result in
            
            switch result {
            case .success(let response):
                let json = response.dictionaryBody
                let token = response.headers["Access-Token"]
                let expires = response.headers["Expiry"]
                let client = response.headers["Client"]
                let uid = response.headers["Uid"]
                
                
                UserDefaults.standard.setValue(token, forKey: "access-token")
                UserDefaults.standard.setValue(expires, forKey: "expiry")
                UserDefaults.standard.setValue(client, forKey: "client")
                UserDefaults.standard.setValue(uid, forKey: "uid")
                
                self.login(email: email, password: password)
                
                
                
                
            case .failure(let response):
                 print(response)
            }

        }
    }
    
    override func enterWithFacebook(profile: FacebookProfile) {
        // Handle Facebook login/signup via your API
        PKHUD.sharedHUD.show()
        
        let networking = Networking(baseURL: "http://localhost:3000/api/v1")
        networking.get("/auth/facebook_access_token/callback?access_token="+profile.facebookToken)  { result in
            PKHUD.sharedHUD.hide()
            switch result {
            case .success(let response):
                let json = response.dictionaryBody
                print(json)
                let token = json["token"]
                let expires = json["expiry"]
                let client = json["client"]
                let uid = json["uid"]

                UserDefaults.standard.setValue(token, forKey: "access-token")
                UserDefaults.standard.setValue(expires, forKey: "expiry")
                UserDefaults.standard.setValue(client, forKey: "client")
                UserDefaults.standard.setValue(uid, forKey: "uid")
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
