//
//  SDWHomeTBC.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/15/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit


class SDWHomeTBC: UITabBarController {
    
    var bird:ListDisplayItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.bird = UserDefaults.standard.value(forKey: "bird") as? ListDisplayItem
        
        self.title = self.bird?.first
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit(_:)))
        editButton.tintColor = AppUtility.app_color_black
        self.navigationItem.rightBarButtonItem = editButton
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func edit(_ sender: Any) {
        
//        let controller:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "BirdProfileEdit") as! UINavigationController
//        let birdController = controller.viewControllers[0] as! SDWBirdViewController
//        birdController.bird = bird
//        self.present(controller, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
