//
//  SDWSeasonViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/4/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit

class SDWSeasonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(finish(_:)))
        addButton.tintColor = UIColor.black
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        cancelButton.tintColor = UIColor.black
    
    }
    
    
    func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func finish(_ sender: Any) {
//        self.updateSeason()
        
        
    }



}
