//
//  SDWDiaryListViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/16/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import UIEmptyState
import Networking
import PKHUD

class SDWDiaryListViewController: UIViewController, UIEmptyStateDataSource, UIEmptyStateDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var objects = [DiaryItemDisplayItem]()
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    var bird:BirdDisplayItem?
    var season:SeasonDisplayItem?
    var existingTodayItem:DiaryItemDisplayItem?
    
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "SDWDiaryListTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier:"DCell")
        
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        // Optionally remove seperator lines from empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.reloadData()
        self.reloadEmptyState(forTableView: self.tableView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadItems()

        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SDWDiaryListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DCell", for: indexPath) as! SDWDiaryListTableViewCell
        
        var object:DiaryItemDisplayItem
        
        
        object = objects[indexPath.row]
        cell.time.text =  object.created

        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var object:DiaryItemDisplayItem
        
        
        object = objects[indexPath.row]

        let diaryController:SDWDiaryItemViewController = storyboard?.instantiateViewController(withIdentifier: "SDWDiaryItemViewController") as! SDWDiaryItemViewController

        diaryController.bird = bird
        diaryController.diaryItem = object
        
        self.navigationController?.pushViewController(diaryController, animated: true)
    }
    
    
    var emptyStateViewAnimationDuration: TimeInterval {
        return 0.0
    }
    
    
    var emptyStateViewAdjustsToFitBars: Bool {
        return false
    }
    
    
    
    var emptyStateImage: UIImage? {
        
        return #imageLiteral(resourceName: "tint-logo")
    }
    
    

    var emptyStateTitle: NSAttributedString {
        let attrs = [NSForegroundColorAttributeName: UIColor(red: 0.882, green: 0.890, blue: 0.859, alpha: 1.00),
                     NSFontAttributeName: UIFont.systemFont(ofSize: 22)]
        return NSAttributedString(string: "No entries yet", attributes: attrs)
    }
    
    func loadItems() {
        
        
        self.dataStore.pullAllDiaryItemsForSeason(seasonID: (self.season?.remoteID)!, currentData: { (objects, error) in
            
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            
            
            self.objects = data as! [DiaryItemDisplayItem]
            self.tableView.reloadData()
            self.reloadEmptyState(forTableView: self.tableView)
            
        }) { (fetched, error) in
            
            
            
            guard let data = fetched, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            self.objects = data as! [DiaryItemDisplayItem]
            self.tableView.reloadData()
            self.reloadEmptyState(forTableView: self.tableView)
            
        }

        
    }


}
