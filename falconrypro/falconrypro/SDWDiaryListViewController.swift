//
//  SDWDiaryListViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/16/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import UIEmptyState

class SDWDiaryListViewController: UIViewController, UIEmptyStateDataSource, UIEmptyStateDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "SDWBirdListTableViewCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier:"Cell")
        
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        
        // Optionally remove seperator lines from empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.reloadData()
        self.reloadEmptyState(forTableView: self.tableView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SDWBirdListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SDWBirdListTableViewCell
        


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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


}
