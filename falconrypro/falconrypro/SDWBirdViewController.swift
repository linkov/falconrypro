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

class SDWBirdViewController: FormViewController {
    
    let networking = Networking(baseURL: Constants.server.BASEURL)
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    var bird:ListDisplayItem?
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
            self.title = self.bird?.first
        } else {
            self.title = "New bird"
        }
        
        self.dataStore.pullAllBirdTypes(currentData: { (objects, error) in
            
            self.birdtypes = objects as! [BirdTypeDisplayItem]
            self.form.sectionBy(tag:"species")?.reload()
            
        }, fetchedData: {(objects, error) in
            
            self.birdtypes = objects as! [BirdTypeDisplayItem]
            self.form.sectionBy(tag:"species")?.reload()
        })
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(finish(_:)))
        addButton.tintColor = UIColor.black
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        cancelButton.tintColor = UIColor.black
        
        if((self.bird) != nil && bird?.imageURL != nil ) {
            let manager:SDWebImageManager = SDWebImageManager.shared()
            manager.loadImage(with: URL(string:(bird?.imageURL!)!), options: [], progress: nil) { (image, data, error, cashType, done, url) in
                self.currentBirdImage = image
                self.form.rowBy(tag: "pic")?.reload()
                
            }
        }
        
        birthdayDateFormatter.dateStyle = .none
        birthdayDateFormatter.dateFormat = "yyyy-mm-dd"

        weightFormatter.locale = Locale.current
        weightFormatter.numberStyle = .none

        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = cancelButton

        
            form
                
                +++ Section("Basic information")
                
                <<< ImageRow() {
                    $0.tag = "pic"
                    $0.title = "Update bird photo"
                    $0.sourceTypes = .PhotoLibrary
                    $0.clearAction = .no
                    }
                    .cellUpdate { cell, row in
                        cell.accessoryView?.layer.cornerRadius = 17
                        cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                }
                <<< TextRow(){ row in
                    row.value = bird?.model?["name"] as? String
                    row.tag = "name"
                    row.title = "Name"
                }
                <<< DateInlineRow(){
                    $0.tag = "bday"
                    $0.dateFormatter = birthdayDateFormatter
                    $0.title = "Birthday"
                    $0.value = (bird?.model?["birthday"] != nil) ? birthdayDateFormatter.date(from: bird?.model?["birthday"] as! String) : Date()
                }
                
                
                <<< ActionSheetRow<String>() {
                    $0.tag = "sex"
                    $0.title = "Sex"
                    $0.selectorTitle = "Pick the sex"
                    $0.value =  (bird?.model != nil) ? ((bird?.model?["sex"] as! Bool == true ? "Male" : "Female")) as String : ""
                    $0.options = ["Male","Female"]
                }
                
                <<< IntRow(){ row in
                    row.tag = "fweight"
                    row.value = bird?.model?["fat_weight"] as? Int
                    row.title = "Fat Weight"
                    row.placeholder = "weight in gramms"
                    row.formatter = self.weightFormatter
                    
                }
                <<< IntRow(){
                    $0.value = bird?.model?["hunting_weight"] as? Int
                    $0.tag = "hweight"
                    $0.title = "Hunting Weight"
                    $0.placeholder = "weight in gramms"
                    $0.formatter = self.weightFormatter
                }
                
                
                +++  Section("Species"){
                        $0.tag = "species"
                }
                <<< SegmentedRow<String>("segments"){
                    $0.options = ["Pure", "Hybrid 2", "Hybrid 4"]
                    $0.tag = "segment_row"
                    }
                    
                    .onChange({ (row) in
                        
                        self.toggleDeselectedBirdTypes(row: row)
                        
                    })
                
                
                <<< SearchablePushRow<BirdTypeDisplayItem>("name") {
                    $0.hidden = "$segment_row != 'Pure'"
                    $0.tag = "species_pure"
//                    $0.baseValue = (self.currentBirdType.name != nil) ? self.currentBirdType : nil
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
//                    $0.baseValue = (self.currentBirdTypeH2_1.name != nil) ? self.currentBirdTypeH2_1 : nil
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
//                    $0.baseValue = (self.currentBirdTypeH2_2.name != nil) ? self.currentBirdTypeH2_2 : nil
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
//                    $0.baseValue =  (self.currentBirdTypeH4_1.name != nil) ? self.currentBirdTypeH4_1 : nil
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
//                    $0.baseValue = (self.currentBirdTypeH4_2.name != nil) ? self.currentBirdTypeH4_2 : nil
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
//                    $0.baseValue = (self.currentBirdTypeH4_3.name != nil) ? self.currentBirdTypeH4_3 : nil
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
//                    $0.baseValue = (self.currentBirdTypeH4_4.name != nil) ? self.currentBirdTypeH4_4 : nil
                    $0.title = "Species"
                    $0.displayValueFor = { value in
                        return value?.name
                    }
                    
                    }.cellUpdate { cell, row in
                        row.options = self.birdtypes
                        }

             self.selectSegmentForBirdtypes()
        
        
        
       self.tableView?.backgroundColor = UIColor.white

        
        
    
    }
    
    func selectSegmentForBirdtypes() {
        
//        let row: SegmentedRow<String> = form.rowBy(tag: "segment_row")! as SegmentedRow<String>
//
//        if (self.currentBirdType.name != nil) {
//            
//            row.value = "Pure"
//            
//        } else if (self.currentBirdTypeH2_1.name != nil) {
//            row.value = "Hybrid 2"
//            
//        } else if (self.currentBirdTypeH4_1.name != nil) {
//            row.value = "Hybrid 4"
//        } else {
//            row.value = "Pure"
//        }
        
    }
    
    func setupCurrentBirdTypes(bird :ListDisplayItem) {
        
//        let birdTypes:Array<Any> = bird.model?["bird_types"] as! Array<Any>
//        
//        if (birdTypes.count == 1) {
//            
//            let dict = birdTypes[0] as? Dictionary<String, Any>
//            self.currentBirdType.name = dict?["name"] as? String
//            self.currentBirdType.model = dict
//            
//        } else if (birdTypes.count == 2) {
//            
//            
//            let dict = birdTypes[0] as? Dictionary<String, Any>
//            self.currentBirdTypeH2_1.name = dict?["name"] as? String
//            self.currentBirdTypeH2_1.model = dict
//            
//            let dict1 = birdTypes[1] as? Dictionary<String, Any>
//            self.currentBirdTypeH2_2.name = dict1?["name"] as? String
//            self.currentBirdTypeH2_2.model = dict1
//            
//        } else if (birdTypes.count == 4) {
//            
//            let dict = birdTypes[0] as? Dictionary<String, Any>
//            self.currentBirdTypeH4_1.name = dict?["name"] as? String
//            self.currentBirdTypeH4_1.model = dict
//            
//            let dict1 = birdTypes[1] as? Dictionary<String, Any>
//            self.currentBirdTypeH4_2.name = dict1?["name"] as? String
//            self.currentBirdTypeH4_2.model = dict1
//            
//            let dict2 = birdTypes[2] as? Dictionary<String, Any>
//            self.currentBirdTypeH4_3.name = dict2?["name"] as? String
//            self.currentBirdTypeH4_3.model = dict2
//            
//            let dict3 = birdTypes[3] as? Dictionary<String, Any>
//            self.currentBirdTypeH4_4.name = dict3?["name"] as? String
//            self.currentBirdTypeH4_4.model = dict3
//        }
//        

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
    
    func loadCurrentBird() {
        self.bird = UserDefaults.standard.value(forKey: "bird") as? ListDisplayItem
        
        
    }
    
//    func loadBirdTypes() {
//        
//        let token = UserDefaults.standard.value(forKey: "access-token")
//        let expires = UserDefaults.standard.value(forKey: "expiry")
//        let client = UserDefaults.standard.value(forKey: "client")
//        let uid = UserDefaults.standard.value(forKey: "uid")
//        
//        var array = [TypeDisplayItem]()
//        
//        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
//        
//        
//        networking.get("/bird_types")  { result in
//          
//            switch result {
//            case .success(let response):
//
//                for item in response.arrayBody {
//                    
//                    let object = TypeDisplayItem()
//                    object.name = item["name"] as? String
//                    object.latin = item["latin"] as? String
//                    object.model = item
//        
//                    
//                    array.append(object)
//                    
//                    
//                }
//                self.birdtypes = array
//                self.form.sectionBy(tag:"species")?.reload()
//                
//            case .failure(let response):
//                print(response)
//            }
//            
//        }
//        
//    }
    
    func updateBird() {
        
        let name: TextRow? = form.rowBy(tag: "name")
        let fweight: IntRow? = form.rowBy(tag: "fweight")
        let hweight: IntRow? = form.rowBy(tag: "hweight")
        let bday: DateInlineRow? = form.rowBy(tag: "bday")
        
        let sex: ActionSheetRow<String>! = form.rowBy(tag:"sex")
        let birdTypes = self.selectedBirdTypes()
        
        let sexbool = ((sex?.value) == "Male" ? true : false)
        
        var dict: [String: Any] = [
            "name": (name?.value)!,
            "sex": sexbool,
            "fat_weight": (fweight?.value)!,
            "hunting_weight": (hweight?.value)!,
            "birthday": (bday?.value)!.toString(),
            
        ]
        
        if (birdTypes.count > 0) {
            dict["bird_type_ids"] = birdTypes
        }
        



        PKHUD.sharedHUD.show()
        

        
        if((self.bird) != nil) {
            
            let bird_id = self.bird?.model?["id"] as! String
            
            networking.put("/birds/"+bird_id, parameters: ["bird":dict])  { result in
                PKHUD.sharedHUD.hide()
                switch result {
                case .success(let response):
                     print(response.dictionaryBody)
                    self.uploadImage()
                    
                case .failure(let response):
                    print(response.dictionaryBody)
                }
                
            }
            
        } else {
            
            dataStore.pushBirdWith(code: nil, sex: sexbool, name: (name?.value)!, birthday: (bday?.value)!, fatWeight: (fweight?.value)!, huntingWeight: (hweight?.value)!, image: nil, birdTypes: self.selectedBirdTypes(), completion: { (result, error) in
                
                PKHUD.sharedHUD.hide()
                
            })

        }
        

        
    }
    
    func uploadImage() {
        
        let photoRow: ImageRow? = form.rowBy(tag: "pic")
        if (photoRow?.value == nil) {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        PKHUD.sharedHUD.show()
        
        let bird_id = self.bird?.model?["id"] as! String
        
        
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
                                data: UIImageJPEGRepresentation(photoRowValue, 0.7)!,
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

    func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func finish(_ sender: Any) {
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
    
