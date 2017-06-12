//
//  SDWBirdsTableViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit

import Networking
import PKHUD
import SDWebImage
import UIEmptyState
import SwipeCellKit

class SDWBirdsTableViewController: UITableViewController, UIEmptyStateDataSource, UIEmptyStateDelegate, SwipeTableViewCellDelegate {
    
    let dataModelManager = DataModelManager.sharedInstance
    let networkManager = NetworkManager.sharedInstance
    let dataStore = SDWDataStore.sharedInstance
    var objects = [BirdDisplayItem]()
    
    lazy var loginCoordinator: SDWLoginCoordinator = {
        return SDWLoginCoordinator(rootViewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-square"), style: .plain, target: self, action: #selector(insertNewObject(_:)))
        addButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = addButton
        
        let settingsButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(logout(_:)))
        settingsButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = settingsButton
        
        let nibName = UINib(nibName: "SDWBirdListTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier:"Cell")
        
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        
        // Optionally remove seperator lines from empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let currentBird = self.dataStore.currentBird()
        
        if (currentBird != nil) {
            
            let controller:SDWSeasonListViewController = storyboard?.instantiateViewController(withIdentifier: "SDWSeasonListViewController") as! SDWSeasonListViewController
            controller.bird = currentBird
            self.navigationController?.pushViewController(controller, animated: false)
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ((UserDefaults.standard.value(forKey: "access-token")) != nil) {
            
            self.loadBirds()
            
        } else {
            
            loginCoordinator.start()
        }
        
    }
    
    func insertNewObject(_ sender: Any) {
        
        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "BirdProfileEdit") as! UINavigationController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func logout(_ sender: Any) {
        
        self.dataStore.logout()
        loginCoordinator.start()
    }
    
    
    func loadBirds() {
        
        
        dataStore.pullAllBirds(currentData: { (objects, error) in
            
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            
        
            self.objects = data as! [BirdDisplayItem]
            self.tableView.reloadData()
            self.reloadEmptyState(forTableView: self.tableView)
        
        }) { (fetched, error) in
            
            
            
            guard let data = fetched, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            self.objects = data as! [BirdDisplayItem]
            self.tableView.reloadData()
            self.reloadEmptyState(forTableView: self.tableView)
            
        }
        
        

        
    }
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
        let cell:SDWBirdListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SDWBirdListTableViewCell
        cell.delegate = self
        
        let object = objects[indexPath.row]
        let string = object.name
        cell.mainLabel!.text = string
        
        cell.birdImage.layer.cornerRadius = cell.birdImage.frame.size.width/2
        cell.birdImage.clipsToBounds = true
        
        
        if let image = object.imageURL {
            cell.birdImage.contentMode = .scaleAspectFill
            cell.birdImage.sd_setImage(with: URL(string:image)) { (image, error, bla, url) in
                
                if (error == nil) {
                    
                    cell.noirUpImage()
                }
                
                
            }
        } else {
            cell.birdImage.contentMode = .center
            cell.birdImage.image = #imageLiteral(resourceName: "circle")
        }
        
        

        



        
        
        
        
        switch object.status {
        case .active:
            cell.badgeLabel.text = "active"
            break
        case .deleted:
            cell.badgeLabel.text = "deleted"
            break
        case .sold:
            cell.badgeLabel.text = "sold"
            break
        case .killed:
            cell.badgeLabel.text = "dead"
            break

        }

        
        
        cell.subLabel?.text = object.birdTypesString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let birdDisplayItem = objects[indexPath.row]
       
        self.dataStore.setupCurrentBird(remoteID: birdDisplayItem.remoteID)
        
        let controller:SDWSeasonListViewController = storyboard?.instantiateViewController(withIdentifier: "SDWSeasonListViewController") as! SDWSeasonListViewController
        controller.bird = birdDisplayItem
        self.navigationController?.pushViewController(controller, animated: true)
        

    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        
        let birdDisplayItem = objects[indexPath.row]
        
        let editAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            
            
            let controller:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "BirdProfileEdit") as! UINavigationController
            let birdEditVC = controller.viewControllers[0] as? SDWBirdViewController
            birdEditVC?.bird = birdDisplayItem
            
            self.present(controller, animated: true, completion: nil)
            
            
        }
        
        editAction.backgroundColor = .black
        
        
        // customize the action appearance
        editAction.image = #imageLiteral(resourceName: "edit-white")
        
        
        return [editAction]
    }
    
    
    
    var emptyStateViewAnimationDuration: TimeInterval {
        return 0.0
    }
    

    

    
    
    var emptyStateViewAdjustsToFitBars: Bool {
        return false
    }
    
    
    var emptyStateDetailMessage: NSAttributedString? {
        
        let attrs = [NSForegroundColorAttributeName: UIColor(red: 0.882, green: 0.890, blue: 0.859, alpha: 1.00),
                     NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
        return NSAttributedString(string: "Hit + to add one now", attributes: attrs)
    }
    
    var emptyStateTitle: NSAttributedString {
        let attrs = [NSForegroundColorAttributeName: UIColor(red: 0.882, green: 0.890, blue: 0.859, alpha: 1.00),
                     NSFontAttributeName: UIFont.systemFont(ofSize: 22)]
        return NSAttributedString(string: "No birds yet", attributes: attrs)
    }
    
    var emptyStateButtonSize: CGSize? {
        return CGSize.init(width: 40, height: 40)
    }
    

    
    var emptyStateButtonTitle: NSAttributedString? {
        let attrs = [NSForegroundColorAttributeName: UIColor.black,
                     NSFontAttributeName: UIFont.systemFont(ofSize: 26)]
        return NSAttributedString(string: "Add", attributes: attrs)
    }

    
    // MARK: - Empty State Delegate
    
    func emptyStatebuttonWasTapped(button: UIButton) {

    }
    
    
  

}
