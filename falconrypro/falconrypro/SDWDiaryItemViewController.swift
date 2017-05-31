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
            
            +++ Section("Notes")
            
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
                               header: "Weight measurements",
                               footer: "") { section in
                                section.tag = "weightitem"
                                section.multivaluedRowToInsertAt = { index in
                                    return SDWWeightItemRow(){
                                        $0.tag = "\(index+1)_newweightitem"
                                        $0.title = "Weight"
                                        $0.displayValueFor = { value in
                                            return  "\(value?.timeString ?? "")"

                                        }
                                        
                                    }
                                }
                                if(self.diaryItem != nil && (self.diaryItem?.weights!.count)! > 0) {
                                    
                                    
                                    for (index, weightItem) in (self.diaryItem?.weights)!.enumerated() {
                                        
                                        
                                        section <<< SDWWeightItemRow() {
                                            $0.tag = "\(index+1)_weightitem"
                                            $0.value = weightItem
                                            $0.title = "Weight"
                                            $0.displayValueFor = { value in
                                                return  "\(value?.timeString ?? "")"
                                            }
                                            
                                        }
                                        
                                    }
                                }
                                
                                
                                
            }
        
        +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Food given",
                               footer: "") { section in
                                section.tag = "fooditem"
                                section.multivaluedRowToInsertAt = { index in
                                    return SDWFoodItemRow(){
                                        $0.tag = "\(index+1)_newfooditem"
                                        $0.title = "Food"
                                        $0.displayValueFor = { value in
                                            return value?.timeString
                                        }

                                    }
                                }
                                if(self.diaryItem != nil && (self.diaryItem?.foods!.count)! > 0) {
                                    
                                    
                                    for (index, foodItem) in (self.diaryItem?.foods)!.enumerated() {
                                        
                                        
                                        section <<< SDWFoodItemRow() {
                                            $0.tag = "\(index+1)_fooditem"
                                            $0.value = foodItem
                                            $0.title = "Food"
                                            $0.displayValueFor = { value in
                                                return  value?.timeString
                                            }
                                            
                                            }
                                        
                                    }
                                }
                                
                                
                                
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
        


        self.tableView?.backgroundColor = UIColor.white
    
    }
    
    func loadFoods() {


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
        
        var foodItems = [DiaryFoodItemDisplayItem]()
        
        for (key, value) in valuesDictionary {
            if(key.hasSuffix("fooditem")) {
                let item:DiaryFoodItemDisplayItem = value as! DiaryFoodItemDisplayItem
                foodItems.append(item)
            }
            
        }
        
        var weightItems = [DiaryWeightItemDisplayItem]()
        
        for (key, value) in valuesDictionary {
            if(key.hasSuffix("weightitem")) {
                let item:DiaryWeightItemDisplayItem = value as! DiaryWeightItemDisplayItem
                weightItems.append(item)
            }
            
        }
        
        
        if (self.diaryItem != nil) {
            
            self.dataStore.updateDiaryItemWith(itemID:self.diaryItem!.remoteID, note: note?.value, quarryTypes: quarry,foodItems:foodItems,weightItems:weightItems) { (object, error) in
                
                if (error == nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        } else {
            
            self.dataStore.pushDiaryItemWith(birdID:bird_id!, note: note?.value, quarryTypes: quarry,foodItems:foodItems,weightItems:weightItems) { (object, error) in
                
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
