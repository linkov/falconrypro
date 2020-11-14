//
//  SDWHTViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 8/19/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import MapKit
import Mapbox

class SDWHTViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapHeightConstaint: NSLayoutConstraint!
    var headerView:SDWStatsListHeaderView?
    @IBOutlet weak var tableView: UITableView!
    var bird:BirdDisplayItem?
    @IBOutlet weak var mapView: MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-square"), style: .plain, target: self, action: #selector(toggleList(_:)))
//        addButton.tintColor = AppUtility.app_color_black
//        self.navigationItem.rightBarButtonItem = addButton
        
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "exit"), style: .plain, target: self, action: #selector(exit(_:)))
        settingsButton.tintColor = AppUtility.app_color_black
        self.navigationItem.leftBarButtonItem = settingsButton
        
        let nibName = UINib(nibName: "SDWStatsItemCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier:"SCell")
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        headerView = SDWStatsListHeaderView.loadFromXib()
        headerView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
        
        self.tableView.tableHeaderView = self.headerView

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.headerView?.animateLabels()
    }
    

    func toggleList(_ sender: Any) {
        

    }
    
    @objc func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SDWStatsItemCell = tableView.dequeueReusableCell(withIdentifier: "SCell", for: indexPath) as! SDWStatsItemCell
        
        if (indexPath.row == 0) {
            
            
//            cell.setupWithLink(text: "Show detailed data")
            
        }
        
        
        
        
        return cell
    }

    
    @IBAction func startDidTap(_ sender: Any) {
        
        
        self.mapHeightConstaint.constant = self.view.frame.height
    }

}
