//
//  SDWDiaryHuntViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Eureka
import Networking
import SDWebImage
import PKHUD
import PureLayout

class SDWDiaryHuntViewController: FormViewController, SDWPageable {
    
    
    var quarry = [QuarryTypeDisplayItem]()
    var pinItems = [PinItemDisplayItem]()
    
    var index:NSInteger = 0
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    var diaryItem:DiaryItemDisplayItem?
    var weightFormatter = NumberFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        form
            
            +++ Section(){ section in
                var header = HeaderFooterView<SDWDiaryCardHeaderView>(.nibFile(name: "SDWDiaryCardHeaderView", bundle: nil))
                
                // Will be called every time the header appears on screen
                header.height = {52}
                header.onSetupView = { view, _ in
                    view.mainImageView.image = #imageLiteral(resourceName: "target")
                }
                section.header = header
            }
        
            +++
            
            
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Pins",
                               footer: "") { section in
                                section.tag = "pinitem"
//                                section.multivaluedRowToInsertAt = { index in
//                                    return SDWPinRow(){
//                                        $0.tag = "\(index+1)_newpinitem"
//                                        $0.title = "Just added:"
//                                        $0.displayValueFor = { value in
//                                            return  "\(value?.pintype?.title ?? "")"
//                                            
//                                        }
//                                        
//                                        }.cellSetup({ (cell,row) in
//                                            AppUtility.delay(delay: 0.3, closure: {
//                                                row.didSelect()
//                                            })
//                                            
//                                        })
//                                }
                                if(self.diaryItem != nil && (self.diaryItem?.pins!.count)! > 0) {
                                    
                                    
                                    for (index, pinItem) in (self.diaryItem?.pins)!.enumerated() {
                                        
                                        
//                                        section <<< SDWPinRow() {
//                                            $0.tag = "\(index+1)_pinitem"
//                                            $0.value = pinItem
//                                            $0.title = "\($0.value?.pintype?.title ?? "")"
//                                            $0.displayValueFor = { value in
//                                                return  ""
//                                            }
//
//                                        }
                                        
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
                                        $0.title = "Just added:"
                                        $0.displayValueFor = { value in
                                            return value?.name
                                        }
                                        $0.options = self.dataStore.allQuarryTypes()
                                        }.cellSetup({ (cell,row) in
                                            AppUtility.delay(delay: 0.3, closure: {
                                                row.didSelect()
                                            })
                                            
                                        })
                                }
                                if(self.diaryItem != nil && (self.diaryItem?.quarryTypes!.count)! > 0) {
                                    
                                    
                                    for (index, quarry) in (self.diaryItem?.quarryTypes)!.enumerated() {
                                        
                                        
                                        section <<< SearchablePushRow<QuarryTypeDisplayItem>() {
                                            $0.tag = "\(index+1)_quarry"
                                            $0.value = quarry
                                            $0.title = $0.value?.name
                                            $0.displayValueFor = { value in
                                                return ""
                                            }
                                            
                                            }.cellUpdate { cell, row in
                                                row.options = self.dataStore.allQuarryTypes()
                                        }
                                        
                                    }
                                }
                                
                                
                                
        }
        
        
        self.view.backgroundColor = UIColor.clear
        
        self.tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 40, left: 20, bottom: 20, right: 20))
        self.tableView.layer.cornerRadius = 8
        self.tableView.layer.masksToBounds = true

        
        self.tableView.backgroundColor = .white


    }
    
    
    func changeTimeframe(timeframe:ChartTimeFrame) {
        
    }
    
    
    func updateDiaryItem() {
        
        
        
        
        let valuesDictionary = form.values()
       
        
        for (key, value) in valuesDictionary {
            if(key.hasSuffix("quarry")) {
                let item:QuarryTypeDisplayItem = value as! QuarryTypeDisplayItem
                quarry.append(item)
            }
            
        }
        
        
        for (key, value) in valuesDictionary {
            if(key.hasSuffix("pinitem")) {
                let item:PinItemDisplayItem = value as! PinItemDisplayItem
                pinItems.append(item)
            }
            
        }
        
        

        
        
        
        
    }



}
