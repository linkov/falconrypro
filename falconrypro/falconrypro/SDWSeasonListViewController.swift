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
    
    var objects = [SeasonDisplayItem]()
    var bird:BirdDisplayItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Seasons"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        addButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = addButton
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.objects = self.bird?.seasons ?? []
        self.tableView.reloadData()
        
    }
    
    func insertNewObject(_ sender: Any) {
        
//        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "SeasonEdit") as! UINavigationController
//        let seasonVC:SDWSeasonViewController = controller.viewControllers[0] as! SDWSeasonViewController
//        seasonVC.bird = self.bird
//        
//        self.present(controller, animated: true, completion: nil)
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
        
        let object:SeasonDisplayItem = objects[indexPath.row]
        cell.textLabel?.text = "Hunting season"
        cell.detailTextLabel?.text = object.startDateString! + " - " + object.endDateString!
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let season = objects[indexPath.row]
        
        
        let controller:SDWHomeViewController = storyboard?.instantiateViewController(withIdentifier: "SDWHomeViewController") as! SDWHomeViewController
        controller.bird = self.bird
        controller.season = season
        
        self.present(controller, animated: true, completion: nil)
        
    }

    


}
