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
import PureLayout


class SDWDiaryItemViewController: FormViewController, SDWPageable {
    
    var foodItems = [DiaryFoodItemDisplayItem]()
    var weightItems = [DiaryWeightItemDisplayItem]()
    var note:String?
    var pastCreated:Date?
    
    
    var index:NSInteger = 0
    let networking = Networking(baseURL: Constants.server.BASEURL)
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance

    var diaryItem:DiaryItemDisplayItem?
    var isPastItem:Bool = false
    var weightFormatter = NumberFormatter()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func changeTimeframe(timeframe:ChartTimeFrame) {
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d yyyy" //Your New Date format as per requirement change it own
        
        self.view.backgroundColor = UIColor.clear
        
        self.tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 20))
        self.tableView.layer.cornerRadius = 8
        self.tableView.layer.masksToBounds = true

        
        self.tableView.backgroundColor = .white
        

        form
            
        +++ Section(){ section in
            var header = HeaderFooterView<SDWDiaryCardHeaderView>(.nibFile(name: "SDWDiaryCardHeaderView", bundle: nil))
            header.height = {52}
            header.onSetupView = { view, _ in

                view.mainImageView.image = #imageLiteral(resourceName: "check-circle")
            }
            section.header = header
            }
            
            +++ Section("Past date"){
                $0.hidden = Condition.function([], { form in
                    return !self.isPastItem
                })
                    

                
            }
            
            <<< DateInlineRow(){
                $0.tag = "past_created"
                $0.title = "Date"
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            
            
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Weight",
                               footer: "") { section in

                                section.tag = "weightitem"
//                                section.multivaluedRowToInsertAt = { index in
//                                    return SDWWeightItemRow(){
//                                        $0.tag = "\(index+1)_newweightitem"
//                                        $0.title = "just added:"
//                                        $0.displayValueFor = { value in
//                                            return  "\(value?.weight ?? 0) grm. - \(value?.timeString ?? "")"
//
//                                        }
//
//                                        }.cellSetup({ (cell,row) in
//                                            AppUtility.delay(delay: 0.3, closure: {
//                                                row.didSelect()
//                                            })
//
//
//                                        })
//                                }
                                if(self.diaryItem != nil && (self.diaryItem?.weights!.count)! > 0) {
                                    
                                    
                                    for (index, weightItem) in (self.diaryItem?.weights)!.enumerated() {
                                        
                                        
//                                        section <<< SDWWeightItemRow() {
//                                            $0.tag = "\(index+1)_weightitem"
//                                            $0.value = weightItem
//                                            $0.title = "\($0.value?.weight ?? 0) grm. - \($0.value?.timeString ?? "")"
//                                            $0.displayValueFor = { value in
//                                                return  ""
//
//                                            }
//                                        }
                                        
                                    }
                                }
                                
                                
                                
            }
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Food",
                               footer: "") { section in
                                section.tag = "fooditem"

//                                section.multivaluedRowToInsertAt = { index in
//                                    return SDWFoodItemRow(){
//                                        $0.tag = "\(index+1)_newfooditem"
//                                        $0.title = "just added:"
//                                        $0.displayValueFor = { value in
//                                            return  "\(value?.amountEaten ?? 0) grm. - \(value?.timeString ?? "")"
//                                        }
//
//                                        }.cellSetup({ (cell,row) in
//                                            AppUtility.delay(delay: 0.3, closure: {
//                                                row.didSelect()
//                                            })
//
//                                        })
//                                }
                                if(self.diaryItem != nil && (self.diaryItem?.foods!.count)! > 0) {
                                    
                                    
                                    for (index, foodItem) in (self.diaryItem?.foods)!.enumerated() {
                                        
                                        
//                                        section <<< SDWFoodItemRow() {
//                                            $0.tag = "\(index+1)_fooditem"
//                                            $0.value = foodItem
//                                            $0.title = "\($0.value?.amountEaten ?? 0) grm. - \($0.value?.timeString ?? "")"
//                                            $0.displayValueFor = { value in
//                                                return  ""
//                                                
//                                            }
//                                        }
                                        
                                    }
                                }
                                
                                
                                
            }
            
            +++ Section("Notes"){
                $0.tag = "notes"

            }

        
            <<< TextAreaRow(){ row in
                row.value = diaryItem?.note
                row.placeholder = "Notes"
                row.tag = "note"
                row.title = "Notes"
        }
            
            

            
            

            
            
                


    
    }
    


    
    func updateDiaryItem() {
        

        
        let note: TextAreaRow? = form.rowBy(tag: "note")
        let pastCreated: DateInlineRow? = form.rowBy(tag: "past_created")
        
        self.note = note?.value
        self.pastCreated = pastCreated?.value

        let valuesDictionary = form.values()


        
        for (key, value) in valuesDictionary {
            if(key.hasSuffix("fooditem")) {
                let item:DiaryFoodItemDisplayItem = value as! DiaryFoodItemDisplayItem
                foodItems.append(item)
            }
            
        }
        
        
        
        for (key, value) in valuesDictionary {
            if(key.hasSuffix("weightitem")) {
                let item:DiaryWeightItemDisplayItem = value as! DiaryWeightItemDisplayItem
                weightItems.append(item)
            }
            
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    
    
    
    func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    



}
