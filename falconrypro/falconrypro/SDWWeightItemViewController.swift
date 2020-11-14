//
//  SDWWeightItemViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/24/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Eureka

class SDWWeightItemViewController: FormViewController, TypedRowControllerType {
    
    public var row: RowOf<DiaryWeightItemDisplayItem>!
    public var onDismissCallback: ((UIViewController) -> ())?
    public var currentItem:DiaryWeightItemDisplayItem?
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
                row.value =  currentItem?.weight != nil ?  Int((currentItem?.weight!)!)  : nil
                row.tag = "eaten"
                row.title = "Weight"
                row.add(rule: RuleRequired())
                row.placeholder = "weight in gramms"
                
                
                
                
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }
            
            <<< DateTimeInlineRow(){
                $0.add(rule: RuleRequired())
                $0.tag = "time"
                $0.title = "When"
                $0.value = currentItem?.time != nil ? currentItem?.time : Date()
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }

        
        
        
    }
    
    func tappedDone(_ sender: UIBarButtonItem){
        
        let errors = form.validate()
        self.tableView.reloadData()
        if (errors.count > 0) {
            return
        }
        
        let eatenRow: IntRow? = form.rowBy(tag: "eaten")
        let timeRow: DateTimeInlineRow? = form.rowBy(tag: "time")
        
        if (currentItem == nil) {
            currentItem = DiaryWeightItemDisplayItem(weight: Int16((eatenRow?.value)!), time: (timeRow?.baseValue as? Date)!)
        } else {
            currentItem?.weight = Int16((eatenRow?.value)!)
            currentItem?.time = timeRow?.baseValue as? Date
        }
        

        
        row.value = currentItem
        onDismissCallback?(self)
    }


}
