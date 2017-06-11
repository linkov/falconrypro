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
    
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    var objects = [SeasonDisplayItem]()
    var bird:BirdDisplayItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Seasons"
        
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-square"), style: .plain, target: self, action: #selector(insertNewObject(_:)))
        addButton.tintColor = UIColor.black
        addButton.isEnabled = !(self.bird?.isViewOnly())!
        self.navigationItem.rightBarButtonItem = addButton
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        let season = self.dataStore.currentSeason()
        
        if (season != nil) {
            let controller:SDWHomeViewController = storyboard?.instantiateViewController(withIdentifier: "SDWHomeViewController") as! SDWHomeViewController
            controller.bird = self.bird
            controller.season = season
            self.present(controller, animated: false, completion: nil)
        }
        
        let nibName = UINib(nibName: "SDWSeasonListCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier:"SCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.objects = self.bird?.currentSeasons() ?? []
        self.tableView.reloadData()
        
    }
    
    func insertNewObject(_ sender: Any) {
        
        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "SeasonEdit") as! UINavigationController
        let seasonVC:SDWSeasonViewController = controller.viewControllers[0] as! SDWSeasonViewController
        seasonVC.bird = self.bird
        
        self.present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell:UITableViewCell = sender as! UITableViewCell
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        if (segue.identifier == "seasonEditSegue" && indexPath != nil && !(self.bird?.isViewOnly())!) {
            
            //prepare for segue to the details view controller
            let controller:UINavigationController = segue.destination as! UINavigationController
            let seasonVC:SDWSeasonViewController = controller.viewControllers[0] as! SDWSeasonViewController
            seasonVC.bird = self.bird
            
            
            seasonVC.season = self.objects[indexPath!.row]
            
        }
    }
    
    
    // Table
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:SDWSeasonListCell = tableView.dequeueReusableCell(withIdentifier: "SCell", for: indexPath) as! SDWSeasonListCell
        cell.tintColor = .black
        let object:SeasonDisplayItem = objects[indexPath.row]
        
        if (object.isBetweenSeason == false) {
            cell.mainLabel?.text = "Hunting season"
        } else{
            cell.mainLabel?.text = "In Between season"
        }
        
        cell.timeLabel?.text = object.startDateString! + " - " + object.endDateString!
        
        if (object.current == true) {
            cell.activeBadge.isHidden = false
        } else {
            cell.activeBadge.isHidden = true
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let season = objects[indexPath.row]
        
        
        let controller:SDWHomeViewController = storyboard?.instantiateViewController(withIdentifier: "SDWHomeViewController") as! SDWHomeViewController
        controller.bird = self.bird
        controller.season = season
        
        self.dataStore.setupCurrentSeason(remoteID: season.remoteID)
        
        self.present(controller, animated: true, completion: nil)
        
    }

    


}
