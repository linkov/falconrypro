//
//  SDWStatDetailContainerViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/1/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Charts

class SDWStatDetailContainerViewController: UIViewController, UIPageViewControllerDataSource {

    var pageController:UIPageViewController?
    
    let dataStore: SDWDataStore = SDWDataStore.sharedInstance
    
    var combinedLineChartVC: SDWStatChartViewController?
    var lineChartVC: SDWStatChartViewController?
    var barChartVC: SDWStatChartViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        self.pageController?.dataSource = self
        
        
        self.lineChartVC = self.storyboard?.instantiateViewController(withIdentifier: "SDWStatChartViewController") as? SDWStatChartViewController
        self.lineChartVC?.index = 0
        
        self.barChartVC = self.storyboard?.instantiateViewController(withIdentifier: "SDWStatChartViewController") as? SDWStatChartViewController
        self.barChartVC?.index = 1
        
        self.combinedLineChartVC = self.storyboard?.instantiateViewController(withIdentifier: "SDWStatChartViewController") as? SDWStatChartViewController
        self.combinedLineChartVC?.index = 2
        
        
        
        let allItems = self.dataStore.currentBird()?.currentDiaryItems()
        var points = [ChartDataEntry]()
        
        for itm:DiaryItemDisplayItem in allItems! {
            
            
            let lastDayWeight = Double((itm.weights?.last?.weight)!)
            let time = itm.model.createdAt?.timeIntervalSince1970
            let point:ChartDataEntry = ChartDataEntry(x:time!, y: lastDayWeight)
            points.append(point)
            
        }
        
        
        self.lineChartVC?.setupWithChartType(type: .WeightChart,label: "Weight", dataPoints: points.sorted { $0.x < $1.x })
        
        
        let cdataPoint10:ChartDataEntry = ChartDataEntry(x: 1, y: 100)
        let cdataPoint20:ChartDataEntry = ChartDataEntry(x: 15, y: 168)
        let cdataPoint30:ChartDataEntry = ChartDataEntry(x: 30, y: 190)
        
        self.combinedLineChartVC?.setupWithChartType(type: .WeightChart,label: "Weight + Food", dataPoints: [cdataPoint10,cdataPoint20,cdataPoint30])
        
        
        let bar1:BarChartDataEntry = BarChartDataEntry(x: 10, y: 2)
        let bar2:BarChartDataEntry = BarChartDataEntry(x: 20, y: 4)
        let bar3:BarChartDataEntry = BarChartDataEntry(x: 30, y: 10)
        
        self.barChartVC?.setupWithChartType(type: .QuerryChart,label: "Top 3 kills", dataPoints: [bar1,bar2,bar3])
        
        
        self.pageController?.setViewControllers([self.lineChartVC!], direction:.forward, animated: false, completion: nil)
        
        self.pageController?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.addChildViewController(self.pageController!)
        self.view .addSubview((self.pageController?.view)!)
        self.pageController?.didMove(toParentViewController: self)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        
         AppUtility.lockOrientation(.landscape)
         UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.portrait)
         UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    

    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        let pagableViewController = viewController as! SDWPageable
        var index:NSInteger  = pagableViewController.index
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1;
        
        let viewControllerAtIndex = self.viewControllerAtIndex(index: index)
        
        return viewControllerAtIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let pagableViewController = viewController as! SDWPageable
        var index:NSInteger  = pagableViewController.index
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1;
        
        if index == 3 {
            return nil
        }
        
        let viewControllerAtIndex = self.viewControllerAtIndex(index: index)
        
        return viewControllerAtIndex
    }
    
    
    func viewControllerAtIndex(index:NSInteger) -> UIViewController? {
        
        if index == 0 {
            return self.lineChartVC
            
        } else if index == 1 {
            return self.barChartVC
        } else if index == 2 {
            return self.combinedLineChartVC
        } else {
            return nil
        }
    }


}
