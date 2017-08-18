//
//  SDWTagsViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 8/16/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit

typealias TagCompletion = (PinTypeDisplayItem?) -> Void

class SDWTagsViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate let reuseIdentifier = "SDWTagCollectionViewCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    
    fileprivate let itemsPerRow: CGFloat = 2
    
    open var onCompletion: TagCompletion?
    
    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    var objects = [PinTypeDisplayItem]()
    var bird:BirdDisplayItem?

    @IBOutlet weak var collectionView: UICollectionView!
    
    public init(completion: @escaping TagCompletion) {
        super.init(nibName: "SDWTagsViewController", bundle: nil)
        onCompletion = completion

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        let nib = UINib(nibName: "SDWTagCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = AppUtility.app_color_black
        
        self.objects = dataStore.allPinTypes()
        self.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.objects[indexPath.row]
        
        onCompletion!(item)
        
    }
    

}

extension SDWTagsViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! SDWTagCollectionViewCell
        //2
        let item = self.objects[indexPath.row]
        //3
        cell.mainLabel.text = item.title
        
        return cell
    }
    
    
    
}


extension SDWTagsViewController : UICollectionViewDelegateFlowLayout {
//    1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
