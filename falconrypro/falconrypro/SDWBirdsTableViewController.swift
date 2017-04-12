//
//  SDWBirdsTableViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import ILLoginKit
import Networking
import PKHUD

class SDWBirdsTableViewController: UITableViewController {
    
    var objects = [ListDisplayItem]()
    
    lazy var loginCoordinator: SDWLoginCoordinator = {
        return SDWLoginCoordinator(rootViewController: self)
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        
        if ((UserDefaults.standard.value(forKey: "access-token")) != nil) {
            
            self.loadBirds()
            
        } else {
            
            loginCoordinator.start()
        }
        
    }
    
    func loadBirds() {
        
        let networking = Networking(baseURL: "http://localhost:3000/api/v1")
        
        let token = UserDefaults.standard.value(forKey: "access-token")
        let expires = UserDefaults.standard.value(forKey: "expiry")
        let client = UserDefaults.standard.value(forKey: "client")
        let uid = UserDefaults.standard.value(forKey: "uid")

        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
        
        
        networking.get("/birds")  { result in
            PKHUD.sharedHUD.hide()
            switch result {
            case .success(let response):
                print(response)
                print(response.arrayBody)
                for item in response.arrayBody {
                    
                    let object = ListDisplayItem()
                    object.first = item["name"] as? String
                    let dict = item["bird_type"] as! NSDictionary
                    object.sub = dict["name"] as? String
                    
                    self.objects.append(object)
                    
                }
                 self.tableView.reloadData()
                
            case .failure(let response):
                print(response)
            }
            
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var object:ListDisplayItem
        
        object = objects[indexPath.row] 
        let string = object.first
        cell.textLabel!.text = string
        
        cell.detailTextLabel?.text = object.sub
        return cell
    }
    
  

}
