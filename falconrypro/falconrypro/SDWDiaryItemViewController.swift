//
//  SDWDiaryItemViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/29/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import ImageRow
import Eureka
import Networking
import SDWebImage
import PKHUD


class SDWDiaryItemViewController: FormViewController {
    
    
    let networking = Networking(baseURL: Constants.server.BASEURL)
    var bird:ListDisplayItem?
    var foods = [TypeDisplayItem]()
    var weightFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        self.loadFoods();
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: Date())
        self.title = newDate
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(finish(_:)))
        addButton.tintColor = UIColor.black
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        cancelButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = cancelButton
        
        weightFormatter.locale = Locale.current
        weightFormatter.numberStyle = .none

        form
            
            +++ Section("Diary entry")
            
            <<< IntRow(){ row in
                row.tag = "weight"
                row.title = "Weight"
                row.placeholder = "weight in gramms"
                row.formatter = self.weightFormatter
                
            }
            
            <<< IntRow(){ row in
                row.tag = "d_offered"
                row.title = "Diet offered"
                row.placeholder = "weight in gramms"
                row.formatter = self.weightFormatter
                
            }
            
            <<< IntRow(){
                $0.tag = "d_eaten"
                $0.title = "Diet eaten"
                $0.placeholder = "weight in gramms"
                $0.formatter = self.weightFormatter
            }
        
            <<< SearchablePushRow<TypeDisplayItem>("name") {
                $0.tag = "food"
                $0.title = "Food eaten"
                $0.displayValueFor = { value in
                    return value?.name
                }
                
                }.cellUpdate { cell, row in
                    row.options = self.foods
        }
        
        
            <<< TextAreaRow(){ row in
                row.placeholder = "Notes"
                row.tag = "note"
                row.title = "Notes"
        }
        

        self.tableView?.backgroundColor = UIColor.white
    
    }
    
    func loadFoods() {

        let token = UserDefaults.standard.value(forKey: "access-token")
        let expires = UserDefaults.standard.value(forKey: "expiry")
        let client = UserDefaults.standard.value(forKey: "client")
        let uid = UserDefaults.standard.value(forKey: "uid")
        
        var array = [TypeDisplayItem]()
        
        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
        
        
        networking.get("/foods")  { result in
            
            switch result {
            case .success(let response):
                
                for item in response.arrayBody {
                    
                    let object = TypeDisplayItem()
                    object.name = item["name"] as? String
                    object.model = item
                    
                    
                    array.append(object)
                    
                    
                }
                self.foods = array
                self.form.rowBy(tag:"food")?.reload()
                
            case .failure(let response):
                print(response)
            }
            
        }
        
    }
    
    
    func updateDiaryItem() {
        
        let note: TextAreaRow? = form.rowBy(tag: "note")
        let weight: IntRow? = form.rowBy(tag: "weight")
        let d_offered: IntRow? = form.rowBy(tag: "d_offered")
        let d_eaten: IntRow? = form.rowBy(tag: "d_eaten")

        let bird_id = self.bird?.model?["id"] as! String
        
        var dict: [String: Any] = [
            "note": (note?.value != nil) ? note?.value as! String : nil,
            "weight": (weight?.value)!,
            "diet_offered": (d_offered?.value)!,
            "diet_eaten": (d_eaten?.value)!,
            "bird_id": bird_id
            
            ]
        

        if let food_type_p = form.rowBy(tag:"food")?.baseValue {
            let food_type_id_p = (food_type_p as! TypeDisplayItem).model?["id"] as! String
            dict["food_id"] = food_type_id_p

        }
        
        
        
        
        PKHUD.sharedHUD.show()
        

            networking.post("/diary_items", parameters: ["diary_item":dict])  { result in
                PKHUD.sharedHUD.hide()
                switch result {
                case .success(let response):
                    print(response)
                     self.dismiss(animated: true, completion: nil)
                    
                    
                    
                case .failure(let response):
                    print(response.dictionaryBody)
                }
                
            }
        
        
        
    }
    
    
    func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func finish(_ sender: Any) {
        self.updateDiaryItem()

        
    }


}
