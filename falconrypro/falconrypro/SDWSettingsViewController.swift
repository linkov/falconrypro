//
//  SDWSettingsViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/2/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Eureka

class SDWSettingsViewController: FormViewController {

    let dataStore: SDWDataStore = SDWDataStore.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        form
            
            +++ Section("Basic information")
            

            <<< TextRow(){ row in
                row.value = dataStore.currentUser()?.email
                row.tag = "email"
                row.title = "eMail"
            }
        
        
        
        self.tableView?.backgroundColor = UIColor.white
    
    
    }



}
