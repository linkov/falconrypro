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
    var bird:ListDisplayItem?
    var birdtypes = [TypeDisplayItem]()
    
    var currentBirdImage:UIImage?
    
    var currentBirdType:TypeDisplayItem = TypeDisplayItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        
        self.currentBirdType.name = bird?.model?["type_name"] as? String
        self.currentBirdType.model = bird?.model?["bird_type"] as? Dictionary<String, Any>
        self.loadBirdTypes()
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


        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = cancelButton
        
//        self.loadCurrentBird()
        
        if((self.bird) != nil) {
            
            form
                +++  Section()
                <<< ImageRow() {
                    $0.tag = "pic"
                    $0.title = "Bird photo"
                    $0.sourceTypes = .PhotoLibrary
                    $0.clearAction = .no
                    }
                    .cellUpdate { cell, row in
                        row.value = ((self.currentBirdImage != nil) ? self.currentBirdImage : row.value)
                        row.reload()
                        cell.accessoryView?.layer.cornerRadius = 17
                        cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                }
                
                +++ Section()
                <<< TextRow(){ row in
                    row.value = bird?.model?["name"] as? String
                    row.tag = "name"
                    row.title = "Name"
                }
                <<< DateRow(){
                    $0.tag = "bday"
                    $0.title = "Birthdate"
                    $0.value = bird?.model?["birthday"] as? Date
                    $0.value = Date()
                }
                
                
                <<< ActionSheetRow<String>() {
                    $0.tag = "sex"
                    $0.title = "Sex"
                    $0.selectorTitle = "Pick a sex"
                    $0.value = (bird?.model?["sex"] as! Bool == true ? "Male" : "Female")
                    $0.options = ["Male","Female"]
                }
                
                <<< DecimalRow(){ row in
                    row.tag = "fweight"
                    row.value = bird?.model?["fat_weight"] as? Double
                    row.title = "Fat Weight"
                }
                <<< DecimalRow(){
                    $0.value = bird?.model?["hunting_weight"] as? Double
                    $0.tag = "hweight"
                    $0.title = "Hunting Weight"
                }
                
                <<< TextRow(){
                    $0.value = bird?.model?["code"] as? String
                    $0.tag = "code"
                    $0.title = "Bird code"
                }
                
                
                <<< PushRow<TypeDisplayItem> {
                    $0.baseValue =  self.currentBirdType
                    $0.tag = "species"
                    $0.title = "Species"
                    $0.displayValueFor = { value in
                        return value?.name
                    }
                    
                    }.cellUpdate { cell, row in
                        row.options = self.birdtypes
            }

        
        
        } else {
            
            form
                +++  Section()
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
                
                +++ Section()
                <<< TextRow(){ row in
                    row.tag = "name"
                    row.title = "Name"
                }
                <<< DateRow(){
                    $0.tag = "bday"
                    $0.title = "Birthdate"
                    $0.value = Date()
                }
                
                
                <<< ActionSheetRow<String>() {
                    $0.tag = "sex"
                    $0.title = "Sex"
                    $0.selectorTitle = "Pick a sex"
                    $0.options = ["Male","Female"]
                }
                
                <<< DecimalRow(){ row in
                    row.tag = "fweight"
                    row.title = "Fat Weight"
                }
                <<< DecimalRow(){
                    $0.tag = "hweight"
                    $0.title = "Hunting Weight"
                }
                
                <<< TextRow(){
                    $0.tag = "code"
                    $0.title = "Bird code"
                }
                
                
                <<< PushRow<TypeDisplayItem> {
                    $0.tag = "species"
                    $0.title = "Species"
                    $0.displayValueFor = { value in
                        return value?.name
                    }
                    
                    }.cellUpdate { cell, row in
                        row.options = self.birdtypes
            }

        }

        
        
    
    }
    
    func loadCurrentBird() {
        self.bird = UserDefaults.standard.value(forKey: "bird") as? ListDisplayItem
        
        
    }
    
    func loadBirdTypes() {
        
        let token = UserDefaults.standard.value(forKey: "access-token")
        let expires = UserDefaults.standard.value(forKey: "expiry")
        let client = UserDefaults.standard.value(forKey: "client")
        let uid = UserDefaults.standard.value(forKey: "uid")
        
        var array = [TypeDisplayItem]()
        
        networking.headerFields = ["access-token": token as! String,"client":client as! String,"uid":uid as! String,"expiry":expires as! String]
        
        
        networking.get("/bird_types")  { result in
          
            switch result {
            case .success(let response):
                print(response)
                print(response.arrayBody)
                for item in response.arrayBody {
                    
                    let object = TypeDisplayItem()
                    object.name = item["name"] as? String
                    object.latin = item["latin"] as? String
                    object.model = item
        
                    
                    array.append(object)
                    
                    
                }
                self.birdtypes = array
                self.form.rowBy(tag: "species")?.reload()
                
            case .failure(let response):
                print(response)
            }
            
        }
        
    }
    
    func updateBird() {
        PKHUD.sharedHUD.show()
        let name: TextRow? = form.rowBy(tag: "name")
        let fweight: DecimalRow? = form.rowBy(tag: "fweight")
        let hweight: DecimalRow? = form.rowBy(tag: "hweight")
        let bday: DateRow? = form.rowBy(tag: "bday")
        
        let sex: ActionSheetRow<String>! = form.rowBy(tag:"sex")
        let bird_type = form.rowBy(tag:"species")?.baseValue as! TypeDisplayItem
        let bird_type_id = bird_type.model?["id"]
        
        let photoRow: ImageRow? = form.rowBy(tag: "pic")
        let photoRowValue:UIImage = (photoRow?.value)!
//        let imageData = UIImagePNGRepresentation(photoRowValue)!
        let imageData:NSData = UIImagePNGRepresentation(photoRowValue)! as NSData
        let dataImage = imageData.base64EncodedString(options: .lineLength64Characters)



        
        let sexbool = ((sex?.value) == "Male" ? 1 : 0)
        
        let dict: [String: Any] = [
            "name": (name?.value)!,
            "sex": sexbool,
            "fat_weight": (fweight?.value)!,
            "hunting_weight": (hweight?.value)!,
            "birthday": (bday?.value)!.toString(),
            "bird_type_id": bird_type_id!,
            "birdimage":dataImage
        
        ]
        
        if((self.bird) != nil) {
            
            let bird_id = self.bird?.model?["id"] as! String
            
            networking.put("/birds/"+bird_id, parameters: ["bird":dict])  { result in
                PKHUD.sharedHUD.hide()
                switch result {
                case .success(let response):
                     print(response.dictionaryBody)
//                    self.uploadImage()
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let response):
                    print(response.dictionaryBody)
                }
                
            }
            
        } else {
            networking.post("/birds", parameters: ["bird":dict])  { result in
                PKHUD.sharedHUD.hide()
                switch result {
                case .success(let response):
                    self.bird?.model = response.dictionaryBody
                    
                    print(response)
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let response):
                    print(response.dictionaryBody)
                }
                
            }
        }
        

        
    }
    
    func uploadImage() {
        
        PKHUD.sharedHUD.show()
        
        let bird_id = self.bird?.model?["id"] as! String
        
        let photoRow: ImageRow? = form.rowBy(tag: "pic")
        let photoRowValue:UIImage = (photoRow?.value)!
//        let imageData = UIImagePNGRepresentation(photoRowValue)!
        
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
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
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
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
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
    
