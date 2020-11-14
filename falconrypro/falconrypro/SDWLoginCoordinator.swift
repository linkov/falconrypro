//
//  SDWLoginCoordinator.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/11/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Foundation

import Networking
import PKHUD


class SDWLoginCoordinator: LoginCoordinator {

    // MARK: - LoginCoordinator
    var networking:Networking = Networking(baseURL: Constants.server.BASEURL)
    let networkManager = NetworkManager.sharedInstance
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    override func start() {
        super.start()
        configureAppearance()
        

    }
    
    override func finish() {
        
         PKHUD.sharedHUD.show()
        self.dataStore.prefetchData { (objects, error) in
             PKHUD.sharedHUD.hide()
            if (error == nil) {
                super.finish()
            }
        }
        
    }
    
    // MARK: - Setup
    
    func configureAppearance() {
        // Customize LoginKit. All properties have defaults, only set the ones you want.
        
        // Customize the look with background & logo images
//        backgroundImage = #imageLiteral(resourceName: "signupbg1")
        // mainLogoImage =
        // secondaryLogoImage =
        
        // Change colors
        tintColor = AppUtility.app_color_black
        errorTintColor = AppUtility.app_color_offWhite
        
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
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
    }
    
    // MARK: - Completion Callbacks
    
    override func login(email: String, password: String) {
       
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        // Handle login via your API
        
        dataStore.pullUserWith(email: email, password: password) { (result, error) in
            
            PKHUD.sharedHUD.hide()
            
            if (error != nil) {
                PKHUD.sharedHUD.contentView = PKHUDErrorView(title: nil, subtitle: error?.localizedDescription)
                PKHUD.sharedHUD.show()
            } else {
                
                self.finish()
            }
            
            
            
        }

    }
    
    override func signup(email: String, password: String) {
        // Handle signup via your API
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        dataStore.pushUserWith(email: email, password: password) { (result, error) in
            
            PKHUD.sharedHUD.hide()
            
            if (error == nil) {
                
                self.login(email: email, password: password)
            } else {
               PKHUD.sharedHUD.contentView = PKHUDErrorView(title: nil, subtitle: error?.localizedDescription)
                PKHUD.sharedHUD.show()
            }
        }

        
    }

    
    override func enterWithFacebook(profile: FacebookProfile) {
        // Handle Facebook login/signup via your API
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        networking.get("/auth/facebook_access_token/callback?access_token="+profile.facebookToken)  { result in
            
            PKHUD.sharedHUD.hide()

            switch result {
            case .success(let response):
                let json = response.dictionaryBody
                print(json)
                
                
                self.networkManager.configureHeaders(json: json as NSDictionary,isFacebook:true)
                
                self.finish()
                break
                
                
            case .failure(let response):
                PKHUD.sharedHUD.contentView = PKHUDErrorView(title: nil, subtitle: response.error.localizedDescription)
                PKHUD.sharedHUD.show()
            }
            
        }
        
    }
    
    override func recoverPassword(email: String) {
        // Handle password recovery via your API
        print("Recover password with: email =\(email)")
    }
}
