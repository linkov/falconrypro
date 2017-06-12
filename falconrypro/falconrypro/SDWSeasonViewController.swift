//
//  SDWSeasonViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/4/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Eureka
import Networking
import SDWebImage
import PKHUD

class SDWSeasonViewController: FormViewController {
    var season:SeasonDisplayItem?
    var bird:BirdDisplayItem?
    let dataStore = SDWDataStore.sharedInstance
    let networking = Networking(baseURL: Constants.server.BASEURL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Season"

        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(finish(_:)))
        addButton.tintColor = UIColor.black
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        cancelButton.tintColor = UIColor.black
        
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = cancelButton

        
        form
            
            +++ Section()
            
            <<< DateInlineRow(){
                $0.tag = "start"
                $0.add(rule: RuleRequired())
                $0.title = "Start"
                $0.value = (season?.start != nil) ?  (season?.start as! Date) : nil
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                }
            
            <<< DateInlineRow(){
                $0.tag = "end"
                $0.title = "End"
                $0.value = (season?.end != nil) ?  (season?.end as! Date) : nil
            }
        
            <<< SwitchRow() {
                $0.tag = "between"
                $0.title = "In-between season"
                $0.value =  (season?.isBetweenSeason != nil) ?  (season?.isBetweenSeason as! Bool) : false
        }
        
            +++ Section("Season management"){
                $0.tag = "management"
            }
            
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "DELETE"
                row.cell.tintColor = .red
                row.cell.preservesSuperviewLayoutMargins = false
                row.cell.separatorInset = UIEdgeInsets.zero
                row.cell.layoutMargins = UIEdgeInsets.zero
                
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.showButtonAlert(alertType: .delete)
        }

    
    }
    
    
    func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func finish(_ sender: Any) {
        self.updateSeason()
        
        
    }
    
    
    func showButtonAlert(alertType:ButtonAlertType) {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: "Delete the season", message: "Season and all related diery items will not be accessable", preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "DELETE", style: .destructive, handler: { (action) in
            
            self.deleteSeason()
        })
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    
    func deleteSeason() {
        
        PKHUD.sharedHUD.show()
        self.dataStore.removeSeason(season_id: (self.season?.remoteID)!, completion: { (result, error) in
            
            PKHUD.sharedHUD.hide()
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    
    func updateSeason() {
        
        let errors = form.validate()
        self.tableView.reloadData()
        if (errors.count > 0) {
            return
        }
        

        let start: DateInlineRow? = form.rowBy(tag: "start")
        let end: DateInlineRow? = form.rowBy(tag: "end")
        let between: SwitchRow? = form.rowBy(tag: "between")
        
        
    

        
        let token = UserDefaults.standard.value(forKey: "access-token")
        let expires = UserDefaults.standard.value(forKey: "expiry")
        let client = UserDefaults.standard.value(forKey: "client")
        let uid = UserDefaults.standard.value(forKey: "uid")

        
        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
        
        
        
        PKHUD.sharedHUD.show()
        
        
        let bird_id:String = (self.bird?.remoteID)!

        if((self.season) != nil) {
            
            let season_id:String = (self.season?.remoteID)!
            
            self.dataStore.pushSeasonWith(season_id:season_id, bird_id: bird_id, start: (start?.value)!, end: end?.value, isBetween: (between?.value)!, completion: { (object, error) in
                
                PKHUD.sharedHUD.hide()
                
                if (error == nil) {
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
//            networking.put("/seasons/"+season_id+"?bird_id="+bird_id, parameters: ["season":dict])  { result in
//                PKHUD.sharedHUD.hide()
//                switch result {
//                case .success(let response):
//                    print(response.dictionaryBody)
//                    self.dismiss(animated: true, completion: nil)
//                    
//                case .failure(let response):
//                    print(response.dictionaryBody)
//                }
//                
//            }
            
        } else {
            self.dataStore.pushSeasonWith(season_id:nil, bird_id: bird_id, start: (start?.value)!, end: end?.value, isBetween: (between?.value)!, completion: { (object, error) in
                
                PKHUD.sharedHUD.hide()
                
                if (error == nil) {
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }
        
        
        
    }




}
