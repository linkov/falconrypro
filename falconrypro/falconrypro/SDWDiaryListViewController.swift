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
    var lastSelectedItem:DiaryItemDisplayItem?
    
    @IBOutlet weak var birdEditButton: UIButton!
    
    
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
        self.tableView.reloadData()
        self.reloadEmptyState(forTableView: self.tableView)
        
        self.existingTodayItem = self.dataStore.currentTodayItemForBird(bird_id: (bird?.remoteID)!)
        
        if (self.existingTodayItem != nil) {
            let diaryController:SDWDiaryItemContainerViewController = storyboard?.instantiateViewController(withIdentifier: "SDWDiaryItemContainerViewController") as! SDWDiaryItemContainerViewController
            
            diaryController.bird = self.bird
            diaryController.diaryItem = self.existingTodayItem
            
            self.navigationController?.pushViewController(diaryController, animated: false)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lastSelectedItem = nil
        self.birdEditButton.setTitle(self.title, for: .normal)
        self.birdEditButton.contentMode = .center
        self.birdEditButton.imageView?.contentMode = .scaleAspectFit
        self.loadItems()
        self.tableView.reloadData()

        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        sizeHeaderToFit()
//    }
//    
//    func sizeHeaderToFit() {
//        
//        if (tableView.tableFooterView != nil) {
//            let headerView = tableView.tableFooterView!
//            tableView.tableFooterView = nil
//            
//            headerView.setNeedsLayout()
//            headerView.layoutIfNeeded()
//            
//            //        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
//            var frame = headerView.frame
//            frame.size.height = 50
//            headerView.frame = frame
//            
//            tableView.tableHeaderView = headerView
//        }
//
//
//    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = SDWDiaryListSectionHeaderView.loadFromXib()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView:SDWDiaryListSectionFooterView = SDWDiaryListSectionFooterView.loadFromXib()
        footerView.addButton.addTarget(self, action: #selector(addItem(_:)), for: .touchUpInside)
        footerView.addButton.isEnabled = !(self.bird?.isViewOnly())!
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SDWDiaryListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DCell", for: indexPath) as! SDWDiaryListTableViewCell
        
        var object:DiaryItemDisplayItem
        
        
        object = objects[indexPath.row]
        cell.time.text =  object.created
        

        
        
        var totalFood = 0
        for item:DiaryFoodItemDisplayItem in object.foods! {
            totalFood += Int(item.amountEaten!)
        }
        
        cell.eaten.text = String(totalFood)
        
        
        var lastWeight = 0
        let lastItem = object.weights?.last
        
        if (object.weights?.last) != nil {
            
            lastWeight = Int((lastItem?.weight)!)
            cell.weight.text = String(lastWeight)
        }
        

        
        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (self.bird?.isViewOnly())! {
            return
        }
        
        
        var object:DiaryItemDisplayItem
        
        
        object = objects[indexPath.row]

        let diaryController:SDWDiaryItemContainerViewController = storyboard?.instantiateViewController(withIdentifier: "SDWDiaryItemContainerViewController") as! SDWDiaryItemContainerViewController

        diaryController.bird = bird
        diaryController.diaryItem = object
        lastSelectedItem = object
        
        self.navigationController?.pushViewController(diaryController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath as IndexPath)
        cell!.contentView.backgroundColor = AppUtility.app_color_black
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath as IndexPath)
        cell!.contentView.backgroundColor = .white
    }
    
    
    var emptyStateViewAnimationDuration: TimeInterval {
        return 0.0
    }
    
    
    var emptyStateViewAdjustsToFitBars: Bool {
        return false
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
            self.objects = self.objects.sorted { $0.model.createdAt?.compare($1.model.createdAt as! Date) == .orderedDescending }
            self.tableView.reloadData()
            self.reloadEmptyState(forTableView: self.tableView)
            
        }) { (fetched, error) in
            
            
            
            guard let data = fetched, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            self.objects = data as! [DiaryItemDisplayItem]
            self.objects = self.objects.sorted { $0.model.createdAt?.compare($1.model.createdAt as! Date) == .orderedDescending }
            self.tableView.reloadData()
            self.reloadEmptyState(forTableView: self.tableView)
            
        }

        
    }

    @IBAction func didTapBirdEdit(_ sender: Any) {
        
        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "BirdProfileEdit") as! UINavigationController
        let birdEditVC = controller.viewControllers[0] as? SDWBirdViewController
        birdEditVC?.bird = self.dataStore.currentBird()
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func addItem(_ sender: Any) {
        
        
        let controller:SDWDiaryItemContainerViewController = storyboard?.instantiateViewController(withIdentifier: "SDWDiaryItemContainerViewController") as! SDWDiaryItemContainerViewController
        controller.bird = self.bird
        controller.isPastItem = true
        controller.title = "Past item"
        self.navigationController?.pushViewController(controller, animated: true)
        //
        
    }

}
