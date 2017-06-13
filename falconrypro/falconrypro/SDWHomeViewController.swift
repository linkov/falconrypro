//
//  SDWHomeViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/28/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import MiniTabBar

class SDWHomeViewController: UIViewController, MiniTabBarDelegate {
    
    var diaryListNav :UINavigationController?
    var statsListNav :UINavigationController?
    var mapNav :UINavigationController?
    var settingsNav :UINavigationController?
    
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    @IBOutlet weak var hmModeViewBottomLayout: NSLayoutConstraint!
    var bird:BirdDisplayItem?
    var season:SeasonDisplayItem?
    var diaryListVC:SDWDiaryListViewController?
    var statsVC:SDWStatsViewController?
    var settingsVC:SDWSettingsViewController?
    
    var editTodayButton:UIBarButtonItem?
    
    var mapVC:SDWMapViewController?
    var hmButton:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reactOnBirdStatus), name: NSNotification.Name(rawValue: "SDWBirdStatusDidChange"), object: nil)

        AppUtility.lockOrientation(.portrait)
        self.createCustomItemTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reactOnBirdStatus() {
        self.editTodayButton?.isEnabled = !(self.bird?.isViewOnly())!
    }
    
    private func createCustomItemTabBar() {
        var items = [MiniTabBarItem]()
        items.append(MiniTabBarItem(title: "Diary", icon: #imageLiteral(resourceName: "activity")))
        
        
        hmButton.backgroundColor = UIColor.clear
        hmButton.layer.cornerRadius = 4
        hmButton.frame.size = CGSize(width: 60, height: 60)

        hmButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        hmButton.setImage(#imageLiteral(resourceName: "target"), for: .normal)
        hmButton.setTitleColor(UIColor.black, for: .normal)
        hmButton.imageView?.contentMode = .scaleAspectFit
        hmButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        let customItem = MiniTabBarItem(customView: hmButton, offset: UIOffset(horizontal: 0, vertical: -5))
        customItem.selectable = false
        
        
        items.append(MiniTabBarItem(title: "Trends", icon: #imageLiteral(resourceName: "pie-chart")))
        
        items.append(customItem)
        

        
        items.append(MiniTabBarItem(title: "Activity", icon: #imageLiteral(resourceName: "map-pin")))
        items.append(MiniTabBarItem(title: "Settings", icon: #imageLiteral(resourceName: "settings")))
        
        let tabBar = MiniTabBar(items: items)
        tabBar.delegate = self
        tabBar.backgroundBlurEnabled = false
        tabBar.backgroundColor = UIColor.white
        tabBar.keyLine.backgroundColor = UIColor.black
        tabBar.tintColor = UIColor.black
        tabBar.frame = CGRect(x: 0, y: self.view.frame.height - 44, width: self.view.frame.width, height: 44)
        self.view.addSubview(tabBar)
        tabSelected(0)
    }
    

    func tabSelected(_ index: Int) {
        
        if (index == 0) {
            
            if ((self.statsListNav) != nil) {
                self.statsVC?.removeFromParentViewController()
                self.statsListNav?.willMove(toParentViewController: self)
                self.statsListNav?.view.removeFromSuperview()
                self.statsListNav?.removeFromParentViewController()
            }
            
            if ((self.mapNav) != nil) {
                self.mapNav?.willMove(toParentViewController: self)
                self.mapNav?.view.removeFromSuperview()
                self.mapNav?.removeFromParentViewController()
            }
            
            if ((self.settingsNav) != nil) {
                self.settingsNav?.willMove(toParentViewController: self)
                self.settingsNav?.view.removeFromSuperview()
                self.settingsNav?.removeFromParentViewController()
            }
            
            
            
           self.diaryListNav = storyboard?.instantiateViewController(withIdentifier: "DiaryListNav") as? UINavigationController
    
            
            self.diaryListVC = self.diaryListNav!.viewControllers[0] as? SDWDiaryListViewController
            self.diaryListVC?.bird = self.bird
            self.diaryListVC?.season = self.season
            
            
            self.diaryListVC?.title = self.bird?.name
            
            //        let editTodayButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editToday(_:)))
            self.editTodayButton = UIBarButtonItem(title: "Today", style: .done, target: self, action: #selector(editToday(_:)))
            self.editTodayButton?.tintColor = UIColor.black
            self.editTodayButton?.isEnabled = !(self.bird?.isViewOnly())!
            self.diaryListVC?.navigationItem.rightBarButtonItem = self.editTodayButton
            
            
            let  backButton = UIBarButtonItem(title: "Seasons", style: .plain, target: self, action: #selector(back(_:)))
            backButton.tintColor = UIColor.black
            self.diaryListVC?.navigationItem.leftBarButtonItem = backButton
            
            
            self.addChildViewController(self.diaryListNav!)
            self.diaryListNav!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-44)
            self.view.insertSubview(self.diaryListNav!.view, at: 0)
            self.view.bringSubview(toFront: self.view)
            self.diaryListNav!.didMove(toParentViewController: self)
            
        } else if (index == 1) {
            
            
            if ((self.mapNav) != nil) {
                self.mapNav?.willMove(toParentViewController: self)
                self.mapNav?.view.removeFromSuperview()
                self.mapNav?.removeFromParentViewController()
            }
            
            if ((self.settingsNav) != nil) {
                self.settingsNav?.willMove(toParentViewController: self)
                self.settingsNav?.view.removeFromSuperview()
                self.settingsNav?.removeFromParentViewController()
            }
            
            
            
            self.diaryListNav?.willMove(toParentViewController: self)
            self.diaryListNav?.view.removeFromSuperview()
            self.diaryListNav?.removeFromParentViewController()
            
            
            
            self.statsListNav = storyboard?.instantiateViewController(withIdentifier: "StatsListNav") as? UINavigationController
            
            
            self.statsVC = self.statsListNav!.viewControllers[0] as? SDWStatsViewController
            self.statsVC?.bird = self.bird
            self.statsVC?.season = self.season
            
            
            
            self.addChildViewController(self.statsListNav!)
            self.statsListNav!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.insertSubview(self.statsListNav!.view, at: 0)
            self.view.bringSubview(toFront: self.view)
            self.statsListNav!.didMove(toParentViewController: self)

            

        } else if (index == 3) {
            
            
            if ((self.statsListNav) != nil) {
                self.statsListNav?.willMove(toParentViewController: self)
                self.statsListNav?.view.removeFromSuperview()
                self.statsListNav?.removeFromParentViewController()
            }
            
            if ((self.diaryListNav) != nil) {
                self.diaryListNav?.willMove(toParentViewController: self)
                self.diaryListNav?.view.removeFromSuperview()
                self.diaryListNav?.removeFromParentViewController()
            }
            
            if ((self.settingsNav) != nil) {
                self.settingsNav?.willMove(toParentViewController: self)
                self.settingsNav?.view.removeFromSuperview()
                self.settingsNav?.removeFromParentViewController()
            }
            
            
            
            
            self.mapNav = storyboard?.instantiateViewController(withIdentifier: "MapNav") as? UINavigationController
            
            
            self.mapVC = self.mapNav!.viewControllers[0] as? SDWMapViewController
            self.mapVC?.title = "All pins"
            
            
            self.addChildViewController(self.mapNav!)
            self.mapNav!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.insertSubview(self.mapNav!.view, at: 0)
            self.view.bringSubview(toFront: self.view)
            self.mapNav!.didMove(toParentViewController: self)

            
            
            
            
        } else if (index == 4) {
            
            if ((self.statsListNav) != nil) {
                self.statsListNav?.willMove(toParentViewController: self)
                self.statsListNav?.view.removeFromSuperview()
                self.statsListNav?.removeFromParentViewController()
            }
            
            if ((self.diaryListNav) != nil) {
                self.diaryListNav?.willMove(toParentViewController: self)
                self.diaryListNav?.view.removeFromSuperview()
                self.diaryListNav?.removeFromParentViewController()
            }
            if ((self.mapNav) != nil) {
                self.mapNav?.willMove(toParentViewController: self)
                self.mapNav?.view.removeFromSuperview()
                self.mapNav?.removeFromParentViewController()
            }
            
            
            self.settingsNav = storyboard?.instantiateViewController(withIdentifier: "SDWSettingsNav") as? UINavigationController
            
            
            self.settingsVC = self.settingsNav!.viewControllers[0] as? SDWSettingsViewController
            self.settingsVC?.title = "Settings"
            
            
            self.addChildViewController(self.settingsNav!)
            self.settingsNav!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-44)
            self.view.insertSubview(self.settingsNav!.view, at: 0)
            self.view.bringSubview(toFront: self.view)
            self.settingsNav!.didMove(toParentViewController: self)
            
            
            
        }
    }
    
    @objc private func customButtonTapped() {
        
        
        
//        if (self.hmButton.backgroundColor == UIColor.white) {
//            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SDWHuntingModeStatusDidChange"), object: NSNumber(booleanLiteral: true))
//            self.hmButton.backgroundColor = UIColor.black
//            self.hmButton.tintColor = .white
//        } else {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SDWHuntingModeStatusDidChange"), object: NSNumber(booleanLiteral: false))
//            self.hmButton.backgroundColor = UIColor.white
//            self.hmButton.tintColor = .black
//        }
//        
        
//        let currentItem = self.diaryListVC?.lastSelectedItem
//        if (currentItem == nil) {
//            
//            return
//        }
//        
//        UIView.animate(withDuration: 0.25) {
//            
//            
//            if (self.hmButton.backgroundColor == UIColor.white) {
//                self.hmButton.backgroundColor = UIColor.black
//                self.hmButton.setTitleColor(UIColor.white, for: .normal)
//                self.hmButton.layer.borderColor = UIColor.white.cgColor
//                self.hmModeViewBottomLayout.constant = 40
//                self.view.layoutIfNeeded()
//            } else {
//                self.hmButton.backgroundColor = UIColor.white
//                self.hmButton.setTitleColor(UIColor.black, for: .normal)
//                self.hmButton.layer.borderColor = UIColor.black.cgColor
//                self.hmModeViewBottomLayout.constant = -40
//                self.view.layoutIfNeeded()
//            }
//        }
        

        
        
//        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "DiaryEdit") as! UINavigationController
//        let birdController = controller.viewControllers[0] as! SDWDiaryItemViewController
//        birdController.bird = bird
//        self.present(controller, animated: true, completion: nil)
    }
    
    func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func showMapForDiaryItem(_ sender: Any) {
        
        
        let currentItem = self.diaryListVC?.lastSelectedItem
        
        if (currentItem != nil) {
            
            tabSelected(3)
            self.mapVC?.title = currentItem?.created
            self.mapVC?.pins = (currentItem?.pins)!
            customButtonTapped()
        }
        

        
    }

    
    func editToday(_ sender: Any) {
        
        
        let controller:SDWDiaryItemContainerViewController = storyboard?.instantiateViewController(withIdentifier: "SDWDiaryItemContainerViewController") as! SDWDiaryItemContainerViewController
        controller.bird = bird
        controller.title = "Today"
        if (self.diaryListVC?.existingTodayItem != nil) {
            controller.diaryItem = self.diaryListVC?.existingTodayItem
        }
        self.diaryListNav?.pushViewController(controller, animated: true)
//

    }


}
