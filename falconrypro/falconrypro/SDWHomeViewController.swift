//
//  SDWHomeViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/28/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit


class SDWHomeViewController: UIViewController, MiniTabBarDelegate {
    
    
    var diaryListNav :UINavigationController?
    var galleryNav :UINavigationController?
    var mapNav :UINavigationController?
    var settingsNav :UINavigationController?
    
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    @IBOutlet weak var hmModeViewBottomLayout: NSLayoutConstraint!
    var bird:BirdDisplayItem?
    var season:SeasonDisplayItem?
    var diaryChartVC:SDWDiaryChartViewController?
    
    var galleryVC:SDWGalleryViewController?
    var settingsVC:SDWSettingsViewController?
    
    var editTodayButton:UIBarButtonItem?
    
    var mapVC:SDWMapViewController?
    var hmButton:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reactOnBirdStatus), name: NSNotification.Name(rawValue: "SDWBirdStatusDidChange"), object: nil)

        AppUtility.lockOrientation(.portrait)
        self.createCustomItemTabBar()
        
        self.dataStore.pullCurrentUser()
        self.dataStore.setSunsetTimeForCurrentUser()
        
        self.dataStore.prefetchData { (objects, error) in

        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reactOnBirdStatus() {
        self.editTodayButton?.isEnabled = !(self.bird?.isViewOnly())!
    }
    
    private func createCustomItemTabBar() {
        var items = [MiniTabBarItem]()
        
        
        items.append(MiniTabBarItem(title: "Diary", icon: #imageLiteral(resourceName: "activity")))
        
        
        hmButton.backgroundColor = .clear
        hmButton.layer.cornerRadius = 4
        hmButton.frame.size = CGSize(width: 60, height: 60)

        hmButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        hmButton.setImage(#imageLiteral(resourceName: "target"), for: .normal)
        hmButton.imageView?.tintColor = AppUtility.app_color_black
        hmButton.setTitleColor(AppUtility.app_color_black, for: .normal)
        hmButton.imageView?.contentMode = .scaleAspectFit
        hmButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let customItem = MiniTabBarItem(customView: hmButton, offset: UIOffset(horizontal: 0, vertical: -5))
        customItem.selectable = false
        
        
        items.append(MiniTabBarItem(title: "Gallery", icon: #imageLiteral(resourceName: "image_icon")))
        
        items.append(customItem)
        

        
        items.append(MiniTabBarItem(title: "Pins", icon: #imageLiteral(resourceName: "map-pin")))
        items.append(MiniTabBarItem(title: "Settings", icon: #imageLiteral(resourceName: "settings")))
        
        let tabBar = MiniTabBar(items: items)
        tabBar.delegate = self
        tabBar.backgroundBlurEnabled = false
        tabBar.backgroundColor = UIColor.white
        tabBar.keyLine.backgroundColor = AppUtility.app_color_black
        tabBar.tintColor = AppUtility.app_color_black
        tabBar.frame = CGRect(x: 0, y: self.view.frame.height - 44, width: self.view.frame.width, height: 44)
        self.view.addSubview(tabBar)
        tabSelected(0)
    }
    

    func tabSelected(_ index: Int) {
        
        if (index == 0) {
            
            if ((self.galleryNav) != nil) {
                self.galleryVC?.removeFromParent()
                self.galleryNav?.willMove(toParent: self)
                self.galleryNav?.view.removeFromSuperview()
                self.galleryNav?.removeFromParent()
            }
            
            if ((self.mapNav) != nil) {
                self.mapNav?.willMove(toParent: self)
                self.mapNav?.view.removeFromSuperview()
                self.mapNav?.removeFromParent()
            }
            
            if ((self.settingsNav) != nil) {
                self.settingsNav?.willMove(toParent: self)
                self.settingsNav?.view.removeFromSuperview()
                self.settingsNav?.removeFromParent()
            }
            
            
            
           self.diaryListNav = storyboard?.instantiateViewController(withIdentifier: "DiaryListNav") as? UINavigationController
    
            
            self.diaryChartVC = self.diaryListNav!.viewControllers[0] as? SDWDiaryChartViewController
            self.diaryChartVC?.bird = self.bird
            self.diaryChartVC?.season = self.season
            
            
            self.diaryChartVC?.title = self.bird?.name
            

            self.editTodayButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-square"), style: .plain, target: self, action: #selector(editToday(_:)))
            
            self.editTodayButton?.isEnabled = !(self.bird?.isViewOnly())!
            self.diaryChartVC?.navigationItem.rightBarButtonItem = self.editTodayButton
            
            
            let  backButton = UIBarButtonItem(title: "Seasons", style: .plain, target: self, action: #selector(back(_:)))
            backButton.tintColor = AppUtility.app_color_black
            self.diaryChartVC?.navigationItem.leftBarButtonItem = backButton
            
            
            
            self.addChild(self.diaryListNav!)
            self.diaryListNav!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-44)
            self.view.insertSubview(self.diaryListNav!.view, at: 0)
            self.view.bringSubviewToFront(self.view)
            self.diaryListNav!.didMove(toParent: self)
            
        } else if (index == 1) {
            
            
            if ((self.mapNav) != nil) {
                self.mapNav?.willMove(toParent: self)
                self.mapNav?.view.removeFromSuperview()
                self.mapNav?.removeFromParent()
            }
            
            if ((self.settingsNav) != nil) {
                self.settingsNav?.willMove(toParent: self)
                self.settingsNav?.view.removeFromSuperview()
                self.settingsNav?.removeFromParent()
            }
            
            
            
            self.diaryListNav?.willMove(toParent: self)
            self.diaryListNav?.view.removeFromSuperview()
            self.diaryListNav?.removeFromParent()
            
            
            
            self.galleryNav = storyboard?.instantiateViewController(withIdentifier: "galleryNav") as? UINavigationController
            
            
            self.galleryVC = self.galleryNav!.viewControllers[0] as? SDWGalleryViewController
            self.galleryVC?.bird = self.bird
            
            
            
            self.addChild(self.galleryNav!)
            self.galleryNav!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.insertSubview(self.galleryNav!.view, at: 0)
            self.view.bringSubviewToFront(self.view)
            self.galleryNav!.didMove(toParent: self)

            

        } else if (index == 3) {
            
            
            if ((self.galleryNav) != nil) {
                self.galleryNav?.willMove(toParent: self)
                self.galleryNav?.view.removeFromSuperview()
                self.galleryNav?.removeFromParent()
            }
            
            if ((self.diaryListNav) != nil) {
                self.diaryListNav?.willMove(toParent: self)
                self.diaryListNav?.view.removeFromSuperview()
                self.diaryListNav?.removeFromParent()
            }
            
            if ((self.settingsNav) != nil) {
                self.settingsNav?.willMove(toParent: self)
                self.settingsNav?.view.removeFromSuperview()
                self.settingsNav?.removeFromParent()
            }
            
            
            
            
            self.mapNav = storyboard?.instantiateViewController(withIdentifier: "MapNav") as? UINavigationController
            
            
            self.mapVC = self.mapNav!.viewControllers[0] as? SDWMapViewController
            self.mapVC?.title = "All pins"
            
            
            self.addChild(self.mapNav!)
            self.mapNav!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.insertSubview(self.mapNav!.view, at: 0)
            self.view.bringSubviewToFront(self.view)
            self.mapNav!.didMove(toParent: self)

            
            
            
            
        } else if (index == 4) {
            
            if ((self.galleryNav) != nil) {
                self.galleryNav?.willMove(toParent: self)
                self.galleryNav?.view.removeFromSuperview()
                self.galleryNav?.removeFromParent()
            }
            
            if ((self.diaryListNav) != nil) {
                self.diaryListNav?.willMove(toParent: self)
                self.diaryListNav?.view.removeFromSuperview()
                self.diaryListNav?.removeFromParent()
            }
            if ((self.mapNav) != nil) {
                self.mapNav?.willMove(toParent: self)
                self.mapNav?.view.removeFromSuperview()
                self.mapNav?.removeFromParent()
            }
            
            
            self.settingsNav = storyboard?.instantiateViewController(withIdentifier: "SDWSettingsNav") as? UINavigationController
            
            
            self.settingsVC = self.settingsNav!.viewControllers[0] as? SDWSettingsViewController
            self.settingsVC?.title = "Settings"
            
            
            self.addChild(self.settingsNav!)
            self.settingsNav!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-44)
            self.view.insertSubview(self.settingsNav!.view, at: 0)
            self.view.bringSubviewToFront(self.view)
            self.settingsNav!.didMove(toParent: self)
            
            
            
        }
    }
    
    @objc private func customButtonTapped() {
        
        let htNav =  storyboard?.instantiateViewController(withIdentifier: "SDWHTNav") as? UINavigationController
        
        let controller:SDWHTViewController = htNav?.viewControllers[0] as! SDWHTViewController
        controller.bird = bird
        controller.title = "Hunting Track"

        present(htNav!, animated:true)
        
//        if (self.hmButton.backgroundColor == UIColor.white) {
//            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SDWHuntingModeStatusDidChange"), object: NSNumber(booleanLiteral: true))
//            self.hmButton.backgroundColor = AppUtility.app_color_black
//            self.hmButton.tintColor = .white
//        } else {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SDWHuntingModeStatusDidChange"), object: NSNumber(booleanLiteral: false))
//            self.hmButton.backgroundColor = UIColor.white
//            self.hmButton.tintColor = AppUtility.app_color_black
//        }
//        
        
//        let currentItem = self.diaryChartVC?.lastSelectedItem
//        if (currentItem == nil) {
//            
//            return
//        }
//        
//        UIView.animate(withDuration: 0.25) {
//            
//            
//            if (self.hmButton.backgroundColor == UIColor.white) {
//                self.hmButton.backgroundColor = AppUtility.app_color_black
//                self.hmButton.setTitleColor(UIColor.white, for: .normal)
//                self.hmButton.layer.borderColor = UIColor.white.cgColor
//                self.hmModeViewBottomLayout.constant = 40
//                self.view.layoutIfNeeded()
//            } else {
//                self.hmButton.backgroundColor = UIColor.white
//                self.hmButton.setTitleColor(AppUtility.app_color_black, for: .normal)
//                self.hmButton.layer.borderColor = AppUtility.app_color_black.cgColor
//                self.hmModeViewBottomLayout.constant = -40
//                self.view.layoutIfNeeded()
//            }
//        }
        

        
        
//        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "DiaryEdit") as! UINavigationController
//        let birdController = controller.viewControllers[0] as! SDWDiaryItemViewController
//        birdController.bird = bird
//        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func showMapForDiaryItem(_ sender: Any) {
        
        
        let currentItem = self.diaryChartVC?.lastSelectedItem
        
        if (currentItem != nil) {
            
            tabSelected(3)
            self.mapVC?.title = currentItem?.created
            self.mapVC?.pins = (currentItem?.pins)!
            customButtonTapped()
        }
        

        
    }

    
    @objc func editToday(_ sender: Any) {
        
        let controller:SDWDiaryItemContainerViewController = storyboard?.instantiateViewController(withIdentifier: "SDWDiaryItemContainerViewController") as! SDWDiaryItemContainerViewController
        controller.bird = bird
        controller.isPastItem = true
        controller.title = "Diary Item"
        if (self.diaryChartVC?.existingTodayItem != nil) {
            controller.diaryItem = self.diaryChartVC?.existingTodayItem
        }
        self.diaryListNav?.pushViewController(controller, animated: true)


    }


}
