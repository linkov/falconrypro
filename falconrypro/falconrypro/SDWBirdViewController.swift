//
//  SDWBirdViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import ImageRow
import Eureka
import Networking

class SDWBirdViewController: FormViewController {

    var birdtypes = [TypeDisplayItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBirdTypes()
        let addButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finish(_:)))
        addButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = addButton
        
        form
        +++  Section()
            <<< ImageRow() {
                $0.title = "Bird photo"
                $0.sourceTypes = .PhotoLibrary
                $0.clearAction = .no
                }
                .cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            }
            
            +++ Section()
            <<< TextRow(){ row in
                row.title = "Name"
            }
            <<< DateRow(){
                $0.title = "Birthdate"
                $0.value = Date()
                }
        
            
            <<< ActionSheetRow<String>() {
                $0.title = "Sex"
                $0.selectorTitle = "Pick a sex"
                $0.options = ["Male","Female"]
            }
            
            <<< DecimalRow(){ row in
                row.title = "Fat Weight"
            }
            <<< DecimalRow(){
                $0.title = "Hunting Weight"
        }
        
            <<< TextRow(){
                $0.title = "Bird code"
        }
        

            <<< PushRow<TypeDisplayItem> {
                $0.tag = "species"
                $0.title = "Species"
                $0.displayValueFor = { value in
                    return value?.name
                }
                
                }.cellUpdate { cell, row in
                    row.options = self.birdtypes
        }
        
    
    }
    
    
    func loadBirdTypes() {
        
        let networking = Networking(baseURL: Constants.server.BASEURL)
        
        let token = UserDefaults.standard.value(forKey: "access-token")
        let expires = UserDefaults.standard.value(forKey: "expiry")
        let client = UserDefaults.standard.value(forKey: "client")
        let uid = UserDefaults.standard.value(forKey: "uid")
        
        var array = [TypeDisplayItem]()
        
        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
        
        
        networking.get("/bird_types")  { result in
          
            switch result {
            case .success(let response):
                print(response)
                print(response.arrayBody)
                for item in response.arrayBody {
                    
                    let object = TypeDisplayItem()
                    object.name = item["name"] as? String
                    object.latin = item["latin"] as? String
        
                    
                    array.append(object)
                    
                    
                }
                self.birdtypes = array
                self.form.rowBy(tag: "species")?.reload()
                
            case .failure(let response):
                print(response)
            }
            
        }
        
    }
    
    
    func finish(_ sender: Any) {
        let valuesDictionary = form.values()
        print(valuesDictionary)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
