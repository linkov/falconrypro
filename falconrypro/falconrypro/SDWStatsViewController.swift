//
//  SDWStatsViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/11/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import RoundedSwitch
import Charts

class SDWStatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var objects = [DiaryItemDisplayItem]()
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    @IBOutlet weak var dataSwitch: Switch!
    var bird:BirdDisplayItem?
    var season:SeasonDisplayItem?
    var headerView:SDWStatsListHeaderView?


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Trends"
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SDWStatsItemCell = tableView.dequeueReusableCell(withIdentifier: "SCell", for: indexPath) as! SDWStatsItemCell
        
        if (indexPath.row == 0) {
            

            cell.setupWithLink(text: "Show detailed data")
           
        } else if (indexPath.row == 1) {
            
            
            let bar1:BarChartDataEntry = BarChartDataEntry(x: 10, y: 2)
            let bar2:BarChartDataEntry = BarChartDataEntry(x: 20, y: 4)
            let bar3:BarChartDataEntry = BarChartDataEntry(x: 30, y: 10)
            
            cell.setupWithChartType(type: .QuerryChart,label: "Top 3 kills", dataPoints: [bar1,bar2,bar3])

            
        } else if (indexPath.row == 2) {
            
            let dataPoint10:ChartDataEntry = ChartDataEntry(x: 1, y: 100)
            let dataPoint20:ChartDataEntry = ChartDataEntry(x: 15, y: 168)
            let dataPoint30:ChartDataEntry = ChartDataEntry(x: 30, y: 190)
            
            cell.setupWithChartType(type: .WeightChart,label: "Weight", dataPoints: [dataPoint10,dataPoint20,dataPoint30])

 
        } else  if (indexPath.row == 3) {
            
            
            
            let dataPoint1:ChartDataEntry = ChartDataEntry(x: 1, y: 2)
            let dataPoint2:ChartDataEntry = ChartDataEntry(x: 15, y: 4)
            let dataPoint3:ChartDataEntry = ChartDataEntry(x: 30, y: 10)
            cell.setupWithChartType(type: .FoodWeight,label: "Food + Weight", dataPoints: [dataPoint1,dataPoint2,dataPoint3])
        }
        
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 0) {
            
            let controller:SDWStatDetailContainerViewController = storyboard?.instantiateViewController(withIdentifier: "SDWStatDetailContainerViewController") as! SDWStatDetailContainerViewController
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    



}
