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
    
    var objects = [DiaryListDisplayItem]()
    var bird:ListDisplayItem?
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        
        var object:DiaryListDisplayItem
        
        
        object = objects[indexPath.row]
        
        cell.weight.text = object.weight
        cell.offered.text = object.offered
        cell.eaten.text = object.eaten
        cell.food.text = object.food

        cell.time.text =  object.created

        
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var object:DiaryListDisplayItem
        
        
        object = objects[indexPath.row]

        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "DiaryEdit") as! UINavigationController
        let diaryController = controller.viewControllers[0] as! SDWDiaryItemViewController
        diaryController.bird = bird
        diaryController.diaryItem = object
        self.present(controller, animated: true, completion: nil)
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
        
        
        
        let networking = Networking(baseURL: Constants.server.BASEURL)
        
        let token = UserDefaults.standard.value(forKey: "access-token")
        let expires = UserDefaults.standard.value(forKey: "expiry")
        let client = UserDefaults.standard.value(forKey: "client")
        let uid = UserDefaults.standard.value(forKey: "uid")
        
        var array = [DiaryListDisplayItem]()
        
        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
        let bird_id = self.bird?.model?["id"] as! String
        
        networking.get("/diary_items?bird_id="+bird_id)  { result in
       
            switch result {
            case .success(let response):

                for item in response.arrayBody {
                    
                    let object = DiaryListDisplayItem()
                    object.weight = item["weight_s"] as? String
                    object.eaten = item["eaten"] as? String
                    object.offered = item["offered"] as? String
                    object.food = item["food_name"] as? String
                    object.created = item["created"] as? String
                    object.note = item["note"] as? String
                    
                    let dict:Dictionary<String,Any> = (item["food"] as? Dictionary)!
                    let itm:TypeDisplayItem = TypeDisplayItem()
                    itm.name = dict["name"] as? String
                    itm.model = dict
                    object.foodDisplayItem = itm
                    
                    object.model = item
                    
                    array.append(object)
                    
                    
                }
                self.objects = array
                self.tableView.reloadData()
                self.reloadEmptyState(forTableView: self.tableView)
                
            case .failure(let response):
                print(response)
            }
            
        }
        
    }


}
