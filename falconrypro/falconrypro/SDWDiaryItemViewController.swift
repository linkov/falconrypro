//
//  SDWDiaryItemViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/29/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Eureka
import Networking
import SDWebImage
import PKHUD


class SDWDiaryItemViewController: FormViewController {
    
    
    let networking = Networking(baseURL: Constants.server.BASEURL)
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    var bird:BirdDisplayItem?
    var diaryItem:DiaryItemDisplayItem?
    var foods = [TypeDisplayItem]()
    var weightFormatter = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        self.loadFoods();
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d yyyy" //Your New Date format as per requirement change it own
        
        if(self.diaryItem != nil) {
            self.title = self.diaryItem?.created
        } else {
            self.title = "Today"
        }
        
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(finish(_:)))
        addButton.tintColor = UIColor.black
        
//        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
//        cancelButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = addButton
//        self.navigationItem.leftBarButtonItem = cancelButton
        
        weightFormatter.locale = Locale.current
        weightFormatter.numberStyle = .none

        form
            
            +++ Section("Diary entry")
            
//            <<< IntRow(){ row in
//                
//                row.value = diaryItem?.model?["weight"] as? Int
//                row.tag = "weight"
//                row.title = "Weight"
//                row.placeholder = "weight in gramms"
//                row.formatter = self.weightFormatter
//                
//            }
//            
//            <<< IntRow(){ row in
//                row.value = diaryItem?.model?["diet_offered"] as? Int
//                row.tag = "d_offered"
//                row.title = "Diet offered"
//                row.placeholder = "weight in gramms"
//                row.formatter = self.weightFormatter
//                
//            }
//            
//            <<< IntRow(){
//                $0.value = diaryItem?.model?["diet_eaten"] as? Int
//                $0.tag = "d_eaten"
//                $0.title = "Diet eaten"
//                $0.placeholder = "weight in gramms"
//                $0.formatter = self.weightFormatter
//            }
//        
//            <<< SearchablePushRow<TypeDisplayItem>("name") {
//                $0.baseValue = diaryItem?.foodDisplayItem
//                $0.tag = "food"
//                $0.title = "Food eaten"
//                $0.displayValueFor = { value in
//                    return value?.name
//                }
//                
//                }.cellUpdate { cell, row in
//                    row.options = self.foods
//        }
        
        
            <<< TextAreaRow(){ row in
                row.value = diaryItem?.note
                row.placeholder = "Notes"
                row.tag = "note"
                row.title = "Notes"
        }
        
        +++
            
        MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                           header: "Quarry caught",
                           footer: "") { section in
                            section.tag = "quarry"
                            section.multivaluedRowToInsertAt = { index in
                                return SearchablePushRow<QuarryTypeDisplayItem>(){
                                    $0.tag = "\(index+1)_newquarry"
                                    $0.title = "Quarry"
                                    $0.displayValueFor = { value in
                                        return value?.name
                                    }
                                    $0.options = self.dataStore.allQuarryTypes()
                                }
                            }
                            if(self.diaryItem != nil && (self.diaryItem?.quarryTypes!.count)! > 0) {

                                
                                for (index, quarry) in (self.diaryItem?.quarryTypes)!.enumerated() {
                                    
                                    
                                     section <<< SearchablePushRow<QuarryTypeDisplayItem>() {
                                        $0.tag = "\(index+1)_quarry"
                                        $0.value = quarry
                                        $0.title = "Quarry"
                                        $0.displayValueFor = { value in
                                            return value?.name
                                        }
                                        
                                        }.cellUpdate { cell, row in
                                            row.options = self.dataStore.allQuarryTypes()
                                    }
                                    
                                }
                            }


                            
            }
        
        

        

//        +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete, .Reorder],
//                           header: "Multivalued Push Selector example",
//                           footer: "") {
//                            $0.multivaluedRowToInsertAt = { index in
//                                return SearchablePushRow<QuarryTypeDisplayItem>("name") {
//                                    $0.title = "Quarry caught"
//                                    $0.displayValueFor = { value in
//                                        return value?.name
//                                    }
//
//                                    }.cellUpdate { cell, row in
//                                        row.options = self.dataStore.allQuarryTypes()
//                                }
//
//                            }
//        }
        
//        }
//        

        self.tableView?.backgroundColor = UIColor.white
    
    }
    
    func loadFoods() {

//        let token = UserDefaults.standard.value(forKey: "access-token")
//        let expires = UserDefaults.standard.value(forKey: "expiry")
//        let client = UserDefaults.standard.value(forKey: "client")
//        let uid = UserDefaults.standard.value(forKey: "uid")
//        
//        var array = [TypeDisplayItem]()
//        
//        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
//        
//        
//        networking.get("/foods")  { result in
//
//            switch result {
//            case .success(let response):
//                
//                for item in response.arrayBody {
//                    
//                    let object = TypeDisplayItem()
//                    object.name = item["name"] as? String
//                    object.model = item
//                    
//                    
//                    array.append(object)
//                    
//                    
//                }
//                self.foods = array
//                self.form.rowBy(tag:"food")?.reload()
//                
//            case .failure(let response):
//                print(response)
//            }
//            
//        }
//        
    }
    
    
    func updateDiaryItem() {
        
        let note: TextAreaRow? = form.rowBy(tag: "note")
        let bird_id = self.bird?.remoteID
        

        let valuesDictionary = form.values()
        var quarry = [QuarryTypeDisplayItem]()
        
        for (key, value) in valuesDictionary {
            if(key.hasSuffix("quarry")) {
                let item:QuarryTypeDisplayItem = value as! QuarryTypeDisplayItem
                quarry.append(item)
            }
            
        }
        
        if (self.diaryItem != nil) {
            
            self.dataStore.updateDiaryItemWith(itemID:self.diaryItem!.remoteID, note: note?.value, quarryTypes: quarry) { (object, error) in
                
                if (error == nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        } else {
            
            self.dataStore.pushDiaryItemWith(birdID:bird_id!, note: note?.value, quarryTypes: quarry) { (object, error) in
                
                if (error == nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        


        
        
    }
    
    
    func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func finish(_ sender: Any) {
        self.updateDiaryItem()

        
    }


}
