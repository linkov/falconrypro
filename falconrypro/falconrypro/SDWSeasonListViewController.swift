//
//  SDWSeasonListViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/4/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Networking
import PKHUD
import SDWebImage
import UIEmptyState

class SDWSeasonListViewController: UITableViewController {
    
    var objects = [ListDisplayItem]()
    var bird:ListDisplayItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Seasons"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        addButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = addButton
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bird_id = self.bird?.model?["id"] as! String
        self.loadSeasonsForBird(bird_id: bird_id)
    }
    
    func insertNewObject(_ sender: Any) {
        
        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "SeasonEdit") as! UINavigationController
        let seasonVC:SDWSeasonViewController = controller.viewControllers[0] as! SDWSeasonViewController
        seasonVC.bird = self.bird
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    // Table
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SeasonCell")!
        
        let object:ListDisplayItem = objects[indexPath.row]
        cell.textLabel?.text = object.first
        cell.detailTextLabel?.text = object.sub
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let season = objects[indexPath.row]
        
        
        let controller:SDWHomeViewController = storyboard?.instantiateViewController(withIdentifier: "SDWHomeViewController") as! SDWHomeViewController
        controller.bird = self.bird
        controller.season = season
        
        self.present(controller, animated: true, completion: nil)
        
    }

    
    
    // Network
    func loadSeasonsForBird(bird_id:String) {
        
        let networking = Networking(baseURL: Constants.server.BASEURL)
        
        let token = UserDefaults.standard.value(forKey: "access-token")
        let expires = UserDefaults.standard.value(forKey: "expiry")
        let client = UserDefaults.standard.value(forKey: "client")
        let uid = UserDefaults.standard.value(forKey: "uid")
        
        var array = [ListDisplayItem]()
        
        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
        
        
        networking.get("/seasons?bird_id="+bird_id)  { result in
            PKHUD.sharedHUD.hide()
            switch result {
            case .success(let response):
                print(response)
                print(response.arrayBody)
                for item in response.arrayBody {
                    
                    let object = ListDisplayItem()
                    var subString:String = item["start_date"] as! String
                    subString += " - "
                    subString += (item["end_date"] as? String)!
                    object.first = "Hunting Season"
                    object.sub = subString
                    object.model = item
                    
                    array.append(object)
                    
                    
                }
                self.objects = array
                self.tableView.reloadData()
                
            case .failure(let response):
                print(response)
            }
            
        }
        
    }

}
