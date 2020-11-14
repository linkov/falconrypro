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
import Networking
import SDWebImage
import PKHUD


enum ButtonAlertType: Int {
    case delete,kill,sell
}


class SDWBirdViewController: FormViewController {
    
    let networking = Networking(baseURL: Constants.server.BASEURL)
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    var bird:BirdDisplayItem?
    var birdtypes = [BirdTypeDisplayItem]()
    var birthdayDateFormatter = DateFormatter()
    var weightFormatter = NumberFormatter()
    
    var currentBirdImage:UIImage?
    
    var currentBirdType:BirdTypeDisplayItem?
    
    var currentBirdTypeH2_1:BirdTypeDisplayItem?
    var currentBirdTypeH2_2:BirdTypeDisplayItem?
    
    var currentBirdTypeH4_1:BirdTypeDisplayItem?
    var currentBirdTypeH4_2:BirdTypeDisplayItem?
    var currentBirdTypeH4_3:BirdTypeDisplayItem?
    var currentBirdTypeH4_4:BirdTypeDisplayItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        
        if (self.bird != nil) {
            self.setupCurrentBirdTypes(bird: self.bird!)
            self.title = self.bird!.name
        } else {
            self.title = "New bird"
        }
        
        self.dataStore.pullAllBirdTypes(currentData: { (objects, error) in
            
            self.birdtypes = objects as! [BirdTypeDisplayItem]
            self.form.sectionBy(tag:"species")?.reload()
            
        }, fetchedData: {(objects, error) in
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            self.birdtypes = data as! [BirdTypeDisplayItem]
            self.birdtypes = self.birdtypes.sorted { $0.isPopular && !$1.isPopular }
            self.form.sectionBy(tag:"species")?.reload()
        })
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finish(_:)))
        addButton.tintColor = AppUtility.app_color_green
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        cancelButton.tintColor = AppUtility.app_color_black
        
        let nibName = UINib(nibName: "SDWBirdListCell", bundle:nil)
        self.tableView.register(nibName, forCellReuseIdentifier:"BCell")

        
        birthdayDateFormatter.dateStyle = .none
        birthdayDateFormatter.dateFormat = "yyyy-mm-dd"

        weightFormatter.locale = Locale.current
        weightFormatter.numberStyle = .none

        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = cancelButton

        
            form
                
                
                
                +++ Section(header: "Bird identifier", footer: "Enter your Bird ID provided by certification authority or other organization. Falconry Pro Bird ID was already setup automatically."){
                    $0.tag = "bird_id"
                    $0.hidden = Condition.function([], { form in
                        return (self.bird != nil && (self.bird?.isViewOnly())!)
                    })
                }

                
                <<< TextRow(){ row in
                    row.value = bird?.code
                    row.tag = "code"
                    row.title = "Bird ID"
                }
                
                
                +++ Section("Basic information"){
                    $0.tag = "basic"
                    $0.hidden = Condition.function([], { form in
                        return (self.bird != nil && (self.bird?.isViewOnly())!)
                    })
                }

                
                <<< ImageRow() {
                    $0.tag = "pic"
                    $0.title = "Bird photo"
                    $0.sourceTypes = .PhotoLibrary
                    $0.clearAction = .no
                    }
                    .cellUpdate { cell, row in
                        cell.accessoryView?.layer.cornerRadius = 17
                        cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                }
                <<< TextRow(){ row in
                    row.value = bird?.name
                    row.tag = "name"
                    row.title = "Name"
                    row.add(rule: RuleRequired())
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.textLabel?.textColor = .red
                        }
                    }
                
                <<< DateInlineRow(){
                    $0.tag = "bday"
                    $0.dateFormatter = birthdayDateFormatter
                    $0.title = "Hatch date"
                    $0.add(rule: RuleRequired())
                    $0.value = (bird?.birthday != nil) ? bird?.birthday! : nil
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.textLabel?.textColor = .red
                        }
                    }
                
                
                <<< ActionSheetRow<String>() {
                    $0.tag = "sex"
                    $0.title = "Sex"
                    $0.add(rule: RuleRequired())
                    $0.selectorTitle = "Pick the sex"
                    $0.value =  (bird?.model != nil) ? ((bird?.sex! == true ? "Male" : "Female")) as String : ""
                    $0.options = ["Male","Female"]
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.textLabel?.textColor = .red
                        }
                  }
                
                <<< IntRow(){ row in
                    row.tag = "fweight"
                    row.value =  (bird?.model != nil) ? Int((bird?.fatWeight)!) : nil
                    row.title = "Fat Weight"
                    row.placeholder = "weight in gramms"
                    row.add(rule: RuleRequired())
                    row.formatter = self.weightFormatter
                    
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.textLabel?.textColor = .red
                        }
                }
                <<< IntRow(){
                    $0.value = (bird?.model != nil) ? Int((bird?.huntingWeight)!) : nil
                    $0.tag = "hweight"
                    $0.add(rule: RuleRequired())
                    $0.title = "Hunting Weight"
                    $0.placeholder = "weight in gramms"
                    $0.formatter = self.weightFormatter
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.textLabel?.textColor = .red
                        }
                }

                
                +++  Section("Species"){
                        $0.tag = "species"
                        $0.hidden = Condition.function([], { form in
                            return (self.bird != nil && (self.bird?.isViewOnly())!)
                        })
                }
                <<< SegmentedRow<String>("segments"){
                    $0.options = ["Pure", "Hybrid 2", "Hybrid 4"]
                    $0.tag = "segment_row"
                    $0.cell.segmentedControl.tintColor = AppUtility.app_color_black
                    $0.add(rule: RuleRequired())
                    }.cellUpdate { cell, row in
                        if !row.isValid {
                            cell.segmentedControl.tintColor = .red
                        }
                    }
                    
                    .onChange({ (row) in
                        
                        self.toggleDeselectedBirdTypes(row: row)
                        row.cell.segmentedControl.tintColor = AppUtility.app_color_black
                    })
                
                
                <<< SearchablePushRow<BirdTypeDisplayItem>("name") {
                    $0.hidden = "$segment_row != 'Pure'"
                    $0.tag = "species_pure"
                    $0.baseValue = (self.currentBirdType?.name != nil) ? self.currentBirdType : nil
                    $0.title = "Species"
                    $0.displayValueFor = { value in
                        return value?.name
                    }
                    
                    }.cellUpdate { cell, row in
                        row.options = self.birdtypes
                }
                <<< SearchablePushRow<BirdTypeDisplayItem>("name") {
                    $0.hidden = "$segment_row != 'Hybrid 2'"
                    $0.tag = "species_h2_1"
                    $0.baseValue = (self.currentBirdTypeH2_1?.name != nil) ? self.currentBirdTypeH2_1 : nil
                    $0.title = "Species"
                    $0.displayValueFor = { value in
                        return value?.name
                    }
                    
                    }.cellUpdate { cell, row in
                        row.options = self.birdtypes
                }
                <<< SearchablePushRow<BirdTypeDisplayItem>("name") {
                    $0.hidden = "$segment_row != 'Hybrid 2'"
                    $0.tag = "species_h2_2"
                    $0.baseValue = (self.currentBirdTypeH2_2?.name != nil) ? self.currentBirdTypeH2_2 : nil
                    $0.title = "Species"
                    $0.displayValueFor = { value in
                        return value?.name
                    }
                    
                    }.cellUpdate { cell, row in
                        row.options = self.birdtypes
                }
                <<< SearchablePushRow<BirdTypeDisplayItem>("name") {
                    $0.hidden = "$segment_row != 'Hybrid 4'"
                    $0.tag = "species_h4_1"
                    $0.baseValue =  (self.currentBirdTypeH4_1?.name != nil) ? self.currentBirdTypeH4_1 : nil
                    $0.title = "Species"
                    $0.displayValueFor = { value in
                        return value?.name
                    }
                    
                    }.cellUpdate { cell, row in
                        row.options = self.birdtypes
                }
                <<< SearchablePushRow<BirdTypeDisplayItem>("name") {
                    $0.hidden = "$segment_row != 'Hybrid 4'"
                    $0.tag = "species_h4_2"
                    $0.baseValue = (self.currentBirdTypeH4_2?.name != nil) ? self.currentBirdTypeH4_2 : nil
                    $0.title = "Species"
                    $0.displayValueFor = { value in
                        return value?.name
                    }
                    
                    }.cellUpdate { cell, row in
                        row.options = self.birdtypes
                }
                <<< SearchablePushRow<BirdTypeDisplayItem>("name") {
                    $0.hidden = "$segment_row != 'Hybrid 4'"
                    $0.tag = "species_h4_3"
                    $0.baseValue = (self.currentBirdTypeH4_3?.name != nil) ? self.currentBirdTypeH4_3 : nil
                    $0.title = "Species"
                    $0.displayValueFor = { value in
                        return value?.name
                    }
                    
                    }.cellUpdate { cell, row in
                        row.options = self.birdtypes
                }
                <<< SearchablePushRow<BirdTypeDisplayItem>("name") {
                    $0.hidden = "$segment_row != 'Hybrid 4'"
                    $0.tag = "species_h4_4"
                    $0.baseValue = (self.currentBirdTypeH4_4?.name != nil) ? self.currentBirdTypeH4_4 : nil
                    $0.title = "Species"
                    $0.displayValueFor = { value in
                        return value?.name
                    }
                    
                    }.cellUpdate { cell, row in
                        row.options = self.birdtypes
                        }


       
        
                +++ Section("Bird management"){
                    $0.tag = "management"
                    $0.hidden = Condition.function([], { form in
                        return (self.bird == nil)
                    })
                }
                

        
                <<< ButtonRow() { (row: ButtonRow) -> Void in
                    row.title = "Deceased"
                    row.cell.tintColor = AppUtility.app_color_black
                    row.cell.preservesSuperviewLayoutMargins = false
                    row.cell.separatorInset = UIEdgeInsets.zero
                    row.cell.layoutMargins = UIEdgeInsets.zero

                    }
                    .onCellSelection { [weak self] (cell, row) in
                        self?.showButtonAlert(alertType: .kill)
        }
                
        
                <<< ButtonRow() { (row: ButtonRow) -> Void in
                    row.title = "TOGGLE SOLD"
                    row.cell.tintColor = AppUtility.app_color_black
                    row.cell.preservesSuperviewLayoutMargins = false
                    row.cell.separatorInset = UIEdgeInsets.zero
                    row.cell.layoutMargins = UIEdgeInsets.zero

                    }
                    .onCellSelection { [weak self] (cell, row) in
                        self?.showButtonAlert(alertType: .sell)
        }
                
                <<< ButtonRow() { (row: ButtonRow) -> Void in
                    row.title = "TOGGLE ARCHIVE"
                    row.cell.tintColor = .red
                    row.cell.preservesSuperviewLayoutMargins = false
                    row.cell.separatorInset = UIEdgeInsets.zero
                    row.cell.layoutMargins = UIEdgeInsets.zero

                    }
                    .onCellSelection { [weak self] (cell, row) in
                        self?.showButtonAlert(alertType: .delete)
        }
        
        
        self.selectSegmentForBirdtypes()
        self.updateImageRow()
        
        
        
       self.tableView?.backgroundColor = AppUtility.app_color_offWhite

        
        
    
    }
    
    
    func showButtonAlert(alertType:ButtonAlertType) {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        switch alertType {
        case .delete:
            let alertController = UIAlertController(title: "ARCHIVE/ARCHIVE the bird", message: "Please confirm this action, this can not be undone bla bla bla", preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "TOGGLE ARCHIVE", style: .destructive, handler: { (action) in
                
                self.deleteBird()
            })
            alertController.addAction(defaultAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            break
        case .sell:
            let alertController = UIAlertController(title: "Sell/Unsell the bird", message: "Please confirm this action, this can not be undone bla bla bla", preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "TOGGLE SOLD", style: .destructive, handler: { (action) in
                
                self.toggleMarkBirdSold()
            })
            alertController.addAction(defaultAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        case .kill:
            let alertController = UIAlertController(title: "Pronounce dead/alive", message: "Please confirm this action, this can not be undone bla bla bla", preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "Deceased", style: .destructive, handler: { (action) in
                
                self.toggleMarkBirdDead()
            })
            alertController.addAction(defaultAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            break

        }
        

    }
    
    
    func deleteBird() {
        
        PKHUD.sharedHUD.show()
        
        self.dataStore.pushBirdStatus(birdItem:self.bird!, status: .deleted, completion: { (result, error) in
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SDWBirdStatusDidChange"), object: nil)
            PKHUD.sharedHUD.hide()
            self.dismiss(animated: true, completion: nil)
            
            
        })
    }
    
    func toggleMarkBirdSold() {
        
         PKHUD.sharedHUD.show()
        
        self.dataStore.pushBirdStatus(birdItem:self.bird!, status: .sold, completion: { (result, error) in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SDWBirdStatusDidChange"), object: nil)
            PKHUD.sharedHUD.hide()
            self.dismiss(animated: true, completion: nil)
            
            
        })
    }
    
    func toggleMarkBirdDead() {
        
        PKHUD.sharedHUD.show()
        
        self.dataStore.pushBirdStatus(birdItem:self.bird!, status: .killed, completion: { (result, error) in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SDWBirdStatusDidChange"), object: nil)
            PKHUD.sharedHUD.hide()
            self.dismiss(animated: true, completion: nil)
            
            
        })
    }
    
    func updateImageRow() {
        
        if((self.bird) != nil && bird?.thumbURL != nil ) {
            let manager:SDWebImageManager = SDWebImageManager.shared()
            manager.loadImage(with: URL(string:(bird?.thumbURL!)!), options: [], progress: nil) { (image, data, error, cashType, done, url) in
                self.currentBirdImage = image
                let imgRow:ImageRow = self.form.rowBy(tag: "pic")!
                imgRow.value = image
//                imgRow.reload()
                
            }
        }
        
    }
    
    func selectSegmentForBirdtypes() {
        
        if (self.bird == nil) {
            return
        }
        
        let row: SegmentedRow<String> = form.rowBy(tag: "segment_row")! as SegmentedRow<String>
        
        if (self.bird?.birdTypes?.count == 1) {
            row.value = "Pure"
        } else if (self.bird?.birdTypes?.count == 2) {
            row.value = "Hybrid 2"
        } else if (self.bird?.birdTypes?.count == 4) {
            row.value = "Hybrid 4"
        } else {
            row.value = "Pure"
        }
    }
    
    func setupCurrentBirdTypes(bird :BirdDisplayItem) {
        

        
  
        if (bird.birdTypes?.count == 1) {
            
            let dict = bird.birdTypes?[0]
            self.currentBirdType = dict
            
        } else if (bird.birdTypes?.count == 2) {
            
            
            let dict = bird.birdTypes?[0]
            self.currentBirdTypeH2_1 = dict
            
            let dict1 = bird.birdTypes?[1]
            self.currentBirdTypeH2_2 = dict1
            
        } else if (bird.birdTypes?.count == 4) {
            
            let dict = bird.birdTypes?[0]
            self.currentBirdTypeH4_1 = dict
            
            let dict1 = bird.birdTypes?[1]
            self.currentBirdTypeH4_2 = dict1
            
            let dict2 = bird.birdTypes?[2]
            self.currentBirdTypeH4_3 = dict2
            
            let dict3 = bird.birdTypes?[3]
            self.currentBirdTypeH4_4 = dict3
        }
        

    }
    
    func toggleDeselectedBirdTypes(row :SegmentedRow<String>) {
        
        if (row.value == "Pure") {
            
            let bird_type_p_h4_1: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h4_1")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h4_1.baseValue = nil
            
            let bird_type_p_h4_2: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h4_2")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h4_2.baseValue = nil
            
            
            let bird_type_p_h4_3: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h4_3")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h4_3.baseValue = nil
            
            let bird_type_p_h4_4: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h4_4")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h4_4.baseValue = nil
            
            
            
            let bird_type_p_h2_1: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h2_1")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h2_1.baseValue = nil
            
            let bird_type_p_h2_2: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h2_2")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h2_2.baseValue = nil
            
            
        } else if (row.value == "Hybrid 2") {
            
            let bird_type_p: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_pure")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p.baseValue = nil
            
            
            let bird_type_p_h4_1: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h4_1")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h4_1.baseValue = nil
            
            let bird_type_p_h4_2: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h4_2")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h4_2.baseValue = nil
            
            
            let bird_type_p_h4_3: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h4_3")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h4_3.baseValue = nil
            
            let bird_type_p_h4_4: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h4_4")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h4_4.baseValue = nil
            
            
        } else if (row.value == "Hybrid 4") {
            
            let bird_type_p: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_pure")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p.baseValue = nil
            
            
            let bird_type_p_h2_1: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h2_1")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h2_1.baseValue = nil
            
            let bird_type_p_h2_2: SearchablePushRow<BirdTypeDisplayItem> = self.form.rowBy(tag:"species_h2_2")! as SearchablePushRow<BirdTypeDisplayItem>
            bird_type_p_h2_2.baseValue = nil
            
        }
    }
    
    func selectedBirdTypes() -> Array<BirdTypeDisplayItem> {
        
        
        var results = [BirdTypeDisplayItem]()
        
        if let bird_type = form.rowBy(tag:"species_pure")?.baseValue {
            results.append(bird_type as! BirdTypeDisplayItem)
        }
        
        
        if let bird_type_h2_1 = form.rowBy(tag:"species_h2_1")?.baseValue {
            results.append(bird_type_h2_1 as! BirdTypeDisplayItem)
        }
        
        if let bird_type_h2_2 = form.rowBy(tag:"species_h2_2")?.baseValue {
            results.append(bird_type_h2_2 as! BirdTypeDisplayItem)
        }
        
        
        
        if let bird_type_h4_1 = form.rowBy(tag:"species_h4_1")?.baseValue {
            results.append(bird_type_h4_1 as! BirdTypeDisplayItem)
        }
        
        
        if let bird_type_h4_2 = form.rowBy(tag:"species_h4_2")?.baseValue {
            results.append(bird_type_h4_2 as! BirdTypeDisplayItem)
        }
        
        
        if let bird_type_h4_3 = form.rowBy(tag:"species_h4_3")?.baseValue {
            results.append(bird_type_h4_3 as! BirdTypeDisplayItem)
            
        }
        
        if let bird_type_h4_4 = form.rowBy(tag:"species_h4_4")?.baseValue {
            results.append(bird_type_h4_4 as! BirdTypeDisplayItem)

        }
        
        return results

    }
    


    
    func updateBird() {
        
        let errors = form.validate()
        self.tableView.reloadData()
        if (errors.count > 0) {
            return
        }
        
        let name: TextRow? = form.rowBy(tag: "name")
        let code: TextRow? = form.rowBy(tag: "code")
        let fweight: IntRow? = form.rowBy(tag: "fweight")
        let hweight: IntRow? = form.rowBy(tag: "hweight")
        let bday: DateInlineRow? = form.rowBy(tag: "bday")
        
        let sex: ActionSheetRow<String>! = form.rowBy(tag:"sex")
        let birdTypes = self.selectedBirdTypes()
        
        let sexbool = ((sex?.value) == "Male" ? true : false)
        
        var dict: [String: Any] = [
            "name": (name?.value)!,
            "sex": sexbool,
            "code": code?.value ?? "",
            "fat_weight": (fweight?.value)!,
            "hunting_weight": (hweight?.value)!,
            "birthday": (bday?.value)!.toString(),
            
        ]
        
        if (birdTypes.count > 0) {
            dict["bird_type_ids"] = birdTypes
        }
        



        PKHUD.sharedHUD.show()
        

        
        if((self.bird) != nil) {
            
            dataStore.pushBirdWith(bird_id:self.bird?.remoteID, code: code?.value, sex: sexbool, name: (name?.value)!, birthday: (bday?.value)!, fatWeight: (fweight?.value)!, huntingWeight: (hweight?.value)!, image: nil, birdTypes: self.selectedBirdTypes(), completion: { (result, error) in
                
                PKHUD.sharedHUD.hide()
                
                let birdItem:BirdDisplayItem = result as! BirdDisplayItem
                self.uploadImage(bird_id: birdItem.remoteID)
                
            })
        } else {
            
            dataStore.pushBirdWith(bird_id:nil, code: code?.value, sex: sexbool, name: (name?.value)!, birthday: (bday?.value)!, fatWeight: (fweight?.value)!, huntingWeight: (hweight?.value)!, image: nil, birdTypes: self.selectedBirdTypes(), completion: { (result, error) in
                
                PKHUD.sharedHUD.hide()
                
                
                let birdItem:BirdDisplayItem = result as! BirdDisplayItem
                self.uploadImage(bird_id: birdItem.remoteID)

                
            })

        }
        

        
    }
    
    func uploadImage(bird_id:String) {
        
        PKHUD.sharedHUD.show()
        
        let photoRow: ImageRow? = form.rowBy(tag: "pic")
        if (photoRow?.value == nil) {
            PKHUD.sharedHUD.hide()
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        
        
        
        
        let photoRowValue:UIImage = (photoRow?.value)!
        
        let dict: [String: String] = [:]
        
        var r  = URLRequest(url: URL(string: Constants.server.BASEURL+"/birds/"+bird_id)!)
        r.httpMethod = "PUT"
        let boundary = "Boundary-\(UUID().uuidString)"
        
        let token = UserDefaults.standard.value(forKey: "access-token")
        let expires = UserDefaults.standard.value(forKey: "expiry")
        let client = UserDefaults.standard.value(forKey: "client")
        let uid = UserDefaults.standard.value(forKey: "uid")
        
        r.setValue(token as? String, forHTTPHeaderField: "access-token")
        r.setValue(expires as? String, forHTTPHeaderField: "expiry")
        r.setValue(client as? String, forHTTPHeaderField: "client")
        r.setValue(uid as? String, forHTTPHeaderField: "uid")
        
        r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        r.httpBody = createBody(parameters: dict,
                                boundary: boundary,
                                data: photoRowValue.jpegData(compressionQuality: 0.7)!,
                                mimeType: "image/jpg",
                                filename: "bird.jpg")
        
        let task = URLSession.shared.dataTask(with: r) { data, response, error in
            guard let data = data, error == nil else {
                PKHUD.sharedHUD.hide()
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                PKHUD.sharedHUD.hide()
                print(responseJSON)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        task.resume()
        
        
    }

    @objc func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func finish(_ sender: Any) {
        self.updateBird()
        
        
    }
    
    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"bird[birdimage]\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    

}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
    
