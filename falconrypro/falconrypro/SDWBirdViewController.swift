//
//  SDWBirdViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/12/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import ImageRow
import Eureka

class SDWBirdViewController: FormViewController {

    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finish(_:)))
        addButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = addButton
        
        form
        +++  Section()
            <<< ImageRow() {
                $0.title = "Bird photo"
                $0.sourceTypes = .PhotoLibrary
                $0.clearAction = .no
                }
                .cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            }
            
            +++ Section()
            <<< TextRow(){ row in
                row.title = "Name"
            }
            <<< DateRow(){
                $0.title = "Birthdate"
                $0.value = Date()
                }
        
            
            <<< ActionSheetRow<String>() {
                $0.title = "Sex"
                $0.selectorTitle = "Pick a sex"
                $0.options = ["Male","Female"]
            }
            
            <<< DecimalRow(){ row in
                row.title = "Fat Weight"
            }
            <<< DecimalRow(){
                $0.title = "Hunting Weight"
        }
        
            <<< TextRow(){
                $0.title = "Bird code"
        }
        

            <<< PushRow<String> {
                $0.title = "Species"
                $0.options = ["Falcon", "SuperFalcon", "Muthafucker"]
        }
        
    
    }
    
    
    func finish(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
