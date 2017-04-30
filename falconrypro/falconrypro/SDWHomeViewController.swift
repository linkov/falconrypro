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
    
    var bird:ListDisplayItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.bird?.first
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit(_:)))
        editButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = editButton
        
        self.createCustomItemTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createCustomItemTabBar() {
        var items = [MiniTabBarItem]()
        items.append(MiniTabBarItem(title: "Diary", icon: #imageLiteral(resourceName: "diary")))
        
        let customButton = UIButton()
        customButton.backgroundColor = UIColor.white
        customButton.layer.cornerRadius = 25
        customButton.frame.size = CGSize(width: 50, height: 50)
        customButton.layer.borderWidth = 1;
        customButton.layer.borderColor = UIColor.black.cgColor
        customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        customButton.setImage(#imageLiteral(resourceName: "add_diary_item1"), for: UIControlState.normal)
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let customItem = MiniTabBarItem(customView: customButton, offset: UIOffset(horizontal: 0, vertical: -10))
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
            let vc:SDWDiaryListViewController = storyboard?.instantiateViewController(withIdentifier: "SDWDiaryListViewController") as! SDWDiaryListViewController
            vc.bird = self.bird
            self.addChildViewController(vc)
            vc.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-44)
            self.view.insertSubview(vc.view, at: 0)
            self.view.bringSubview(toFront: self.view)
            vc.didMove(toParentViewController: self)
            
        } else {
            
        }
    }
    
    @objc private func customButtonTapped() {
        
        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "DiaryEdit") as! UINavigationController
        let birdController = controller.viewControllers[0] as! SDWDiaryItemViewController
        birdController.bird = bird
        self.present(controller, animated: true, completion: nil)
    }
    
    func edit(_ sender: Any) {
        
        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "BirdProfileEdit") as! UINavigationController
        let birdController = controller.viewControllers[0] as! SDWBirdViewController
        birdController.bird = bird
        self.present(controller, animated: true, completion: nil)
    }

}
