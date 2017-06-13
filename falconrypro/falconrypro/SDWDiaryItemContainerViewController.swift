//
//  SDWDiaryItemContainerViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Eureka
import Networking
import SDWebImage
import PKHUD
import EZYGradientView

class SDWDiaryItemContainerViewController: UIViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate {

    var diaryVC: SDWDiaryItemViewController?
    var huntingVC: SDWDiaryHuntViewController?
    
    var pageController:UIPageViewController?
    var currentIndex:Int = 0
    
    let networking = Networking(baseURL: Constants.server.BASEURL)
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    var bird:BirdDisplayItem?
    var diaryItem:DiaryItemDisplayItem?
    var isPastItem:Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        
        self.pageController?.view.backgroundColor = UIColor.clear
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "SDWHuntingModeStatusDidChange"), object: nil, queue: OperationQueue.main) { (note) in
            
            
           
            
        }
        
        if(self.diaryItem != nil) {
            self.title = self.diaryItem?.created
        }
        
        let proxyTitleLabel = UILabel.appearance(whenContainedInInstancesOf: [SDWDiaryItemContainerViewController.self])
        proxyTitleLabel.tintColor = .black
        proxyTitleLabel.textColor = .black
        
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(finish(_:)))
        addButton.tintColor = UIColor.black
        
        //        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        //        cancelButton.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = addButton
        
        
        
        
        self.diaryVC = self.storyboard?.instantiateViewController(withIdentifier: "SDWDiaryItemViewController") as? SDWDiaryItemViewController
        self.diaryVC?.index = 0
        self.diaryVC?.diaryItem = self.diaryItem
        
        self.huntingVC = self.storyboard?.instantiateViewController(withIdentifier: "SDWDiaryHuntViewController") as? SDWDiaryHuntViewController
        self.huntingVC?.index = 1
        self.huntingVC?.diaryItem = self.diaryItem
        
        
        self.pageController?.setViewControllers([self.diaryVC!], direction:.forward, animated: false, completion: nil)
        
        self.pageController?.view.frame = CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height-50)
        self.addChildViewController(self.pageController!)
        self.view .addSubview((self.pageController?.view)!)
        self.pageController?.didMove(toParentViewController: self)
        
        
        self.pageController?.delegate = self
        
        setupGradient()


        
    }
    
    func setupGradient() {
        
        let gradientView = EZYGradientView()
        gradientView.frame = view.bounds
        gradientView.firstColor = UIColor.black
        gradientView.secondColor = UIColor.darkGray
        gradientView.angleº = 185.0
        gradientView.colorRatio = 0.5
        gradientView.fadeIntensity = 1
        gradientView.isBlur = false
        gradientView.blurOpacity = 0.5
        
        self.pageController?.view.insertSubview(gradientView, at: 0)
    }
    
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0] as? SDWPageable {
                currentIndex = currentViewController.index
            }
        }
    }
    
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
            return self.diaryVC
            
        } else if index == 1 {
            return self.huntingVC
        } else {
            return nil
        }
    }
    
    
    func finish(_ sender: Any) {
        
        self.diaryVC?.updateDiaryItem()
        self.huntingVC?.updateDiaryItem()
        
        let bird_id = self.bird?.remoteID
        
        if (self.diaryItem != nil) {
            
            self.dataStore.updateDiaryItemWith(itemID:self.diaryItem!.remoteID, note: self.diaryVC?.note, quarryTypes: self.huntingVC?.quarry,foodItems:self.diaryVC?.foodItems,weightItems:self.diaryVC?.weightItems,pinItems: self.huntingVC?.pinItems) { (object, error) in
                
                if (error == nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        } else {
            
            self.dataStore.pushDiaryItemWith(birdID:bird_id!,  note: self.diaryVC?.note, quarryTypes: self.huntingVC?.quarry,foodItems:self.diaryVC?.foodItems,weightItems:self.diaryVC?.weightItems,pinItems: self.huntingVC?.pinItems,createdDate:self.diaryVC?.pastCreated ) { (object, error) in
                
                if (error == nil) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        
    }
    



}
