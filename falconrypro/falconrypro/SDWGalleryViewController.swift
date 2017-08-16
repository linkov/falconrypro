//
//  SDWGalleryViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 8/16/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage

class SDWGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate let reuseIdentifier = "FlickrCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    fileprivate let itemsPerRow: CGFloat = 3

    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    var objects = [DiaryPhotoDisplayItem]()
    var bird:BirdDisplayItem?
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(FlickrPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.dataStore.pullAllPhotos(currentData: { (objects, error) in
            
            self.objects = objects as! [DiaryPhotoDisplayItem]
            
        }, fetchedData: {(objects, error) in
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            self.objects = data as! [DiaryPhotoDisplayItem]
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    




}

// MARK: - UICollectionViewDataSource
extension SDWGalleryViewController {
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    //3
     func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! FlickrPhotoCell
        //2
        let thePhoto = self.objects[indexPath.row]
        cell.backgroundColor = UIColor.white
        //3
        
        if ((thePhoto.imageThumbURL) != nil) {
            cell.imageView.sd_setImage(with: URL(string:thePhoto.imageThumbURL!)) { (image, error, bla, url) in
                
                if (error == nil) {
                    
                    //                cell.noirUpImage()
                }
                
                
            }
            
        }

        return cell
    }
}

extension SDWGalleryViewController : UICollectionViewDelegateFlowLayout {
    //1
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
