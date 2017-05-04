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
    var season:ListDisplayItem?
    var bird:ListDisplayItem?
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
        
        self.tableView?.backgroundColor = UIColor.white
        
        form
            
            +++ Section()
            
            <<< DateInlineRow(){
                $0.tag = "start"
                $0.title = "Start"
                $0.value = (season?.model?["start"] != nil) ?  (season?.model?["start"] as! Date) : Date()
            }
            
            <<< DateInlineRow(){
                $0.tag = "end"
                $0.title = "End"
                $0.value = (season?.model?["end"] != nil) ?  (season?.model?["end"] as! Date) : Date()
            }
        
            <<< SwitchRow() {
                $0.tag = "between"
                $0.title = "In-between season"
                $0.value =  (season?.model?["between"] != nil) ?  (season?.model?["end"] as! Bool) : false
        }
        

    
    }
    
    
    func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func finish(_ sender: Any) {
        self.updateSeason()
        
        
    }
    
    
    func updateSeason() {
        

        let start: DateInlineRow? = form.rowBy(tag: "start")
        let end: DateInlineRow? = form.rowBy(tag: "end")
        
        
        
        let dict: [String: Any] = [


            "start": (start?.value)!.toString(),
            "end": (end?.value)!.toString(),
            
            ]
        

        
        let token = UserDefaults.standard.value(forKey: "access-token")
        let expires = UserDefaults.standard.value(forKey: "expiry")
        let client = UserDefaults.standard.value(forKey: "client")
        let uid = UserDefaults.standard.value(forKey: "uid")

        
        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
        
        
        
        PKHUD.sharedHUD.show()
        
        
        let bird_id = self.bird?.model?["id"] as! String

        if((self.season) != nil) {
            
            let season_id = self.season?.model?["id"] as! String
            
            networking.put("/seasons/"+season_id+"?bird_id="+bird_id, parameters: ["season":dict])  { result in
                PKHUD.sharedHUD.hide()
                switch result {
                case .success(let response):
                    print(response.dictionaryBody)
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let response):
                    print(response.dictionaryBody)
                }
                
            }
            
        } else {
            networking.post("/seasons?bird_id="+bird_id, parameters: ["season":dict])  { result in
                PKHUD.sharedHUD.hide()
                switch result {
                case .success(let response):
                    self.season = ListDisplayItem()
                    self.season?.model = response.dictionaryBody
                    print(response)
                    self.dismiss(animated: true, completion: nil)
                    
                    
                    
                case .failure(let response):
                    print(response.dictionaryBody)
                }
                
            }
        }
        
        
        
    }




}
