//
//  SDWPinViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/2/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import CoreLocation
import ImageRow
import Eureka

class SDWPinViewController: FormViewController, TypedRowControllerType {

    public var row: RowOf<PinItemDisplayItem>!
    public var onDismissCallback: ((UIViewController) -> ())?
    public var currentItem:PinItemDisplayItem?
    
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
        
        
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(SDWPinViewController.tappedDone(_:)))
        button.title = "Save"
        navigationItem.rightBarButtonItem = button
        
        if let item = row.value  {
            currentItem = item
        }
        
        form
            
            +++ Section("")
            
            <<< LocationRow(){
                $0.tag = "location"
                $0.title = "Set location"
                $0.add(rule: RuleRequired())
                $0.value = (self.currentItem?.long != nil && self.currentItem?.long != nil) ? CLLocation.init(latitude: (self.currentItem?.lat)!, longitude: (self.currentItem?.long)!) : nil
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }
        
            <<< TextAreaRow(){ row in
                row.value = (self.currentItem?.note != nil) ? self.currentItem?.note : nil
                row.placeholder = "Notes"
                row.tag = "note"
                row.title = "Notes"
        }
        
            <<< ActionSheetRow<PinTypeDisplayItem>() {
                $0.tag = "type"
                $0.title = "Type"
                $0.add(rule: RuleRequired())
                $0.selectorTitle = "Pick the type of pin"
                $0.value = (self.currentItem?.pintype != nil) ? self.currentItem?.pintype : nil
                $0.options = self.dataStore.allPinTypes()
                $0.displayValueFor = { value in
                    return  value?.title
                }
                
                
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
        
        
//
        let noteRow: TextAreaRow? = form.rowBy(tag: "note")
        let typeRow: ActionSheetRow<PinTypeDisplayItem>? = form.rowBy(tag: "type")
        
        let locationRow: LocationRow? = form.rowBy(tag: "location")
        let locationRowValue:CLLocation = (locationRow?.value)!
        
        
        if (currentItem == nil) {
            currentItem = PinItemDisplayItem(note: noteRow?.value ?? nil, type: (typeRow?.value)!, lat: locationRowValue.coordinate.latitude, long: locationRowValue.coordinate.longitude )
        } else {
            currentItem?.note = noteRow?.value
            currentItem?.pintype = typeRow?.value
            currentItem?.lat = locationRowValue.coordinate.latitude
            currentItem?.long = locationRowValue.coordinate.longitude
            
        }
        
        
        
        row.value = currentItem
        onDismissCallback?(self)
    }
    


}
