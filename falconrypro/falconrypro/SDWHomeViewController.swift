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
    
    var bird:BirdDisplayItem?
    var season:SeasonDisplayItem?
    var diaryListVC:SDWDiaryListViewController?
    var statsVC:SDWStatsViewController?
    var hmButton:UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        self.createCustomItemTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createCustomItemTabBar() {
        var items = [MiniTabBarItem]()
        items.append(MiniTabBarItem(title: "Diary", icon: #imageLiteral(resourceName: "diary")))
        
        
        hmButton.backgroundColor = UIColor.white
        hmButton.layer.cornerRadius = 25
        hmButton.frame.size = CGSize(width: 50, height: 50)
        hmButton.layer.borderWidth = 1;
        hmButton.layer.borderColor = UIColor.black.cgColor
        hmButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        hmButton.setTitle("HM", for: .normal)
        hmButton.setTitleColor(UIColor.black, for: .normal)
        hmButton.imageView?.contentMode = .scaleAspectFit
        hmButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let customItem = MiniTabBarItem(customView: hmButton, offset: UIOffset(horizontal: 0, vertical: -10))
        customItem.selectable = false
        items.append(customItem)
        
        items.append(MiniTabBarItem(title: "Stats", icon: #imageLiteral(resourceName: "stats")))
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
            
           self.diaryListNav = storyboard?.instantiateViewController(withIdentifier: "DiaryListNav") as? UINavigationController
    
            
            self.diaryListVC = self.diaryListNav!.viewControllers[0] as? SDWDiaryListViewController
            self.diaryListVC?.bird = self.bird
            self.diaryListVC?.season = self.season
            
            
            self.diaryListVC?.title = self.bird?.name
            
            //        let editTodayButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editToday(_:)))
            let editTodayButton = UIBarButtonItem(title: "Today", style: .done, target: self, action: #selector(editToday(_:)))
            editTodayButton.tintColor = UIColor.black
            self.diaryListVC?.navigationItem.rightBarButtonItem = editTodayButton
            
            
            let  backButton = UIBarButtonItem(title: "Seasons", style: .plain, target: self, action: #selector(back(_:)))
            backButton.tintColor = UIColor.black
            self.diaryListVC?.navigationItem.leftBarButtonItem = backButton
            
            
            self.addChildViewController(self.diaryListNav!)
            self.diaryListNav!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-44)
            self.view.insertSubview(self.diaryListNav!.view, at: 0)
            self.view.bringSubview(toFront: self.view)
            self.diaryListNav!.didMove(toParentViewController: self)
            
        } else {
            
            self.diaryListNav?.willMove(toParentViewController: self)
            self.diaryListNav?.view.removeFromSuperview()
            self.diaryListNav?.removeFromParentViewController()
            
            
            
            self.statsListNav = storyboard?.instantiateViewController(withIdentifier: "StatsListNav") as? UINavigationController
            
            
            self.statsVC = self.statsListNav!.viewControllers[0] as? SDWStatsViewController
            self.statsVC?.bird = self.bird
            self.statsVC?.season = self.season
            
            
            
            self.addChildViewController(self.statsListNav!)
            self.statsListNav!.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-44)
            self.view.insertSubview(self.statsListNav!.view, at: 0)
            self.view.bringSubview(toFront: self.view)
            self.statsListNav!.didMove(toParentViewController: self)

            

        }
    }
    
    @objc private func customButtonTapped() {
        
        
        if (hmButton.backgroundColor == UIColor.white) {
            hmButton.backgroundColor = UIColor.black
            hmButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            hmButton.backgroundColor = UIColor.white
            hmButton.setTitleColor(UIColor.black, for: .normal)
        }
        
        
//        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "DiaryEdit") as! UINavigationController
//        let birdController = controller.viewControllers[0] as! SDWDiaryItemViewController
//        birdController.bird = bird
//        self.present(controller, animated: true, completion: nil)
    }
    
    func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }

    
    func editToday(_ sender: Any) {
        
        
        let controller:SDWDiaryItemViewController = storyboard?.instantiateViewController(withIdentifier: "SDWDiaryItemViewController") as! SDWDiaryItemViewController
        controller.bird = bird
        if (self.diaryListVC?.existingTodayItem != nil) {
            controller.diaryItem = self.diaryListVC?.existingTodayItem
        }
        self.diaryListNav?.pushViewController(controller, animated: true)
//

    }

}
