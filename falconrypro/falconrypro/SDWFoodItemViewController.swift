//
//  SDWFoodItemViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/24/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Eureka

class SDWFoodItemViewController : FormViewController, TypedRowControllerType {
    
    public var row: RowOf<DiaryFoodItemDisplayItem>!
    public var onDismissCallback: ((UIViewController) -> ())?
    public var currentItem:DiaryFoodItemDisplayItem?
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience public init(_ callback: ((UIViewController) -> ())?){
        self.init(nibName: nil, bundle: nil)
        onDismissCallback = callback
        
        

        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(SDWFoodItemViewController.tappedDone(_:)))
        button.title = "Save"
        navigationItem.rightBarButtonItem = button
        
        if let item = row.value  {
             currentItem = item
        }
        
        form
            
            +++ Section("")
            
            <<< IntRow(){ row in
                row.value =  currentItem?.amountEaten != nil ?  Int((currentItem?.amountEaten!)!)  : nil
                row.tag = "eaten"
                row.title = "Diet"
                row.add(rule: RuleRequired())
                row.placeholder = "weight in gramms"
                row.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }
                
                
                
        }
        
            <<< DateTimeInlineRow(){
                $0.tag = "time"
                $0.title = "When"
                $0.add(rule: RuleRequired())
                $0.value = currentItem?.time != nil ? currentItem?.time : Date()
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }
        
            <<< SearchablePushRow<FoodDisplayItem>("name") {
                $0.tag = "food"
                $0.value = (self.currentItem?.food != nil) ? self.currentItem?.food : nil
                $0.title = "Diet Type"
                $0.add(rule: RuleRequired())
                $0.displayValueFor = { value in
                    return value?.name
                }
                
                }.cellUpdate { cell, row in
                    row.options = self.dataStore.allFoods().sorted { $0.popular && !$1.popular }
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }
        

        
    }
    
    @objc func tappedDone(_ sender: UIBarButtonItem){
        
        let errors = form.validate()
        self.tableView.reloadData()
        if (errors.count > 0) {
            return
        }
        
        let eatenRow: IntRow? = form.rowBy(tag: "eaten")
        let timeRow: DateTimeInlineRow? = form.rowBy(tag: "time")
        let foodRow: SearchablePushRow<FoodDisplayItem>? = form.rowBy(tag: "food")
        
        
        if (currentItem == nil) {
            currentItem = DiaryFoodItemDisplayItem(amount: Int16((eatenRow?.value)!), food: foodRow?.baseValue as! FoodDisplayItem, time: (timeRow?.baseValue as? Date)!)
        } else {
            currentItem?.amountEaten = Int16((eatenRow?.value)!)
            currentItem?.food = foodRow?.baseValue as! FoodDisplayItem
            currentItem?.time = timeRow?.baseValue as? Date
          
        }
        

        
        row.value = currentItem
        onDismissCallback?(self)
    }


}
