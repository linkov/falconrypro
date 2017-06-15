//
//  SDWSettingsViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/2/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Eureka
import PKHUD

class SDWSettingsViewController: FormViewController {

    let dataStore: SDWDataStore = SDWDataStore.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        
        
//        EmailRow.defaultCellUpdate = { cell, row in
//            cell.contentView.backgroundColor = .red
//            cell.textLabel?.textColor = .white
//            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
//            cell.textLabel?.textAlignment = .right
//            
//        }

        
        
//        let proxyTitleLabel = UILabel.appearance(whenContainedInInstancesOf: [SDWSettingsViewController.self])
//        proxyTitleLabel.tintColor = AppUtility.app_color_black
//        proxyTitleLabel.textColor = AppUtility.app_color_black
//        proxyTitleLabel.font = UIFont.systemFont(ofSize: <#T##CGFloat#>)
        
        form
            
            +++ Section(){ section in
                var header = HeaderFooterView<SDWBadgeHeaderFooterView>(.nibFile(name: "SDWBadgeHeaderFooterView", bundle: nil))
                header.height = {82}
                header.onSetupView = { view, _ in
                    
                    view.badgeLabel.text = self.dataStore.currentUser()?.email
                    view.badgeLabel.textColor = .white
                }
                section.header = header
            }

            +++ Section("Measuments")
            
            <<< SegmentedRow<String>("segments"){
                $0.options = ["Metric", "Imperial"]
                $0.tag = "metric"
                $0.value = (self.dataStore.currentUser()?.metric == true) ? "Metric" : "Imperial"
                $0.cell.titleLabel?.text = "preferred system"
                $0.cell.segmentedControl.tintColor = AppUtility.app_color_black
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.segmentedControl.tintColor = .red
                    }
                }
                
                .onChange({ (row) in
                    

                })
        
        +++ Section("Notifications")
        
            <<< SwitchRow() {
                $0.cellProvider = CellProvider<SwitchCell>(nibName: "SwitchCell", bundle: Bundle.main)
                $0.cell.height = { 67 }
                $0.tag = "sunset"
                $0.value =  true
                }.cellSetup({ (cell, row) in
                    
                    cell.switchControl.tintColor = AppUtility.app_color_black
                })
        
    
    
        self.tableView.backgroundColor = .white
        self.tableView.separatorColor = .clear
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(finish(_:)))
        addButton.tintColor = AppUtility.app_color_black
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func finish(_ sender: Any) {
        
        var metricBool:Bool = true
        let metricRow: SegmentedRow<String> = form.rowBy(tag: "metric")! as SegmentedRow<String>
        if (metricRow.value == "Metric") {
            metricBool = true
        } else {
            metricBool = false
        }
        
        metricBool = true
        
        PKHUD.sharedHUD.show()
        self.dataStore.updateCurrentUserWith(metric: metricBool) { (object, error) in
            
            PKHUD.sharedHUD.hide()
            if (error == nil) {
                
            }
        }
        
    }



}
