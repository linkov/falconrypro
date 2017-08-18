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
import SimpleImageViewer
import ALCameraViewController
import CHTCollectionViewWaterfallLayout
import TagListView

class SDWGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout, TagListViewDelegate {
    
    fileprivate let reuseIdentifier = "SDWGalleryCollectionViewCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    
    fileprivate let itemsPerRow: CGFloat = 2

    let dataStore:SDWDataStore = SDWDataStore.sharedInstance
    
    @IBOutlet weak var tagListView: TagListView!
    
    var selectedTags:[String] = []
    var tagList: TagListView?
    var diaryPhotoImage:UIImage?
    
    var objects = [DiaryPhotoDisplayItem]()
    var filteredObjects = [DiaryPhotoDisplayItem]()
    var bird:BirdDisplayItem?
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        
        
        self.title = "Photos"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
        let nib = UINib(nibName: "SDWGalleryCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = AppUtility.app_color_offWhite
        
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
                
        // Collection view attributes
        self.collectionView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.collectionView.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView.collectionViewLayout = layout
        
        
        tagListView.textFont = UIFont.systemFont(ofSize: 24)
        tagListView.alignment = .center // possible values are .Left, .Center, and .Right
        
        tagListView.addTags(dataStore.allPinTypes().map { $0.title! })
        
        tagListView.delegate = self
        
        
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus-square"), style: .plain, target: self, action: #selector(insertNewObject(_:)))
        addButton.tintColor = AppUtility.app_color_black
        addButton.isEnabled = !(self.bird?.isViewOnly())!
        self.navigationItem.rightBarButtonItem = addButton
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.pullPhotos()
        
        

    }
    
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        filteredObjects = objects
        
        if selectedTags.contains( where: { $0 == title } ) {
            selectedTags.removeAll()
            tagView.tagBackgroundColor = AppUtility.app_color_offWhite
            
            
        } else {
            tagView.tagBackgroundColor = AppUtility.app_color_black
            selectedTags.append(title)
            filteredObjects = objects.filter { selectedTags.contains($0.pinTypeTitle!) }
        }
        
        
        
       
        collectionView.reloadData()
        
        
    }
    
    func pullPhotos() {
        
        PKHUD.sharedHUD.show()
        
        self.dataStore.pullAllPhotos(currentData: { (objects, error) in
            
            self.objects = objects as! [DiaryPhotoDisplayItem]
            self.objects.sorted { $0.model.createdAt?.compare($1.model.createdAt as! Date) == .orderedDescending }
            self.filteredObjects = self.objects
            self.collectionView.reloadData()
            
            if (self.objects.count != 0) {
                PKHUD.sharedHUD.hide()
            }
            
        }, fetchedData: {(objects, error) in
            
            guard let data = objects, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            PKHUD.sharedHUD.hide()
            self.objects = data as! [DiaryPhotoDisplayItem]
            self.objects.sorted { $0.model.createdAt?.compare($1.model.createdAt as! Date) == .orderedDescending }
            self.filteredObjects = self.objects
            self.collectionView.reloadData()
        })
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell:SDWGalleryCollectionViewCell = collectionView.cellForItem(at: indexPath as IndexPath) as! SDWGalleryCollectionViewCell
        
        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.imageView
        }
        let imageViewerController = ImageViewerController(configuration: configuration)
        
        present(imageViewerController, animated: true)
        
        
        
    }
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        
        let thePhoto = self.filteredObjects[indexPath.row]
        
        return CGSize(width: CGFloat(thePhoto.width!) , height: CGFloat(thePhoto.height!))
    }
    
    
    func insertNewObject(_ sender: Any) {
        
        let realSelf = self
        
        let croppingEnabled = true
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled) { [weak self] image, asset in
            
            realSelf.diaryPhotoImage = image!
            
            self?.dismiss(animated: true, completion: {
                
                
                    realSelf.showTags()
            })
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    
    func showTags() {
        
        let realSelf = self
        
        let tagsViewController = SDWTagsViewController() { [weak self] tag in
            
            if (tag != nil) {
                let pinType = tag!
                realSelf.dataStore.pushDiaryPhoto(image: (realSelf.diaryPhotoImage)!, bird: (realSelf.bird!), pintype: pinType, completion: { (object, error) in
                    
                    realSelf.pullPhotos()
                })

            }
            
            self?.dismiss(animated: true, completion: {
                
       
            })
        }
        
        present(tagsViewController, animated: true, completion: nil)
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         columnCountForSection section: Int) -> Int{
        return 2
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         heightForHeaderInSection section: Int) -> CGFloat{
        return 0
    }
    
    

    




}

// MARK: - UICollectionViewDataSource
extension SDWGalleryViewController {
    


  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return filteredObjects.count
    }
    

     func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! SDWGalleryCollectionViewCell
        //2
        let thePhoto = self.filteredObjects[indexPath.row]
        //3
        
        if ((thePhoto.imageThumbURL) != nil) {
            cell.imageView.sd_setImage(with: URL(string:thePhoto.imageURL!)) { (image, error, bla, url) in
                
                if (error == nil) {
                    
                    //                cell.noirUpImage()
                }
                
                
            }
            
        }

        return cell
    }
    


}

//extension SDWGalleryViewController : UICollectionViewDelegateFlowLayout {
//    //1
////    func collectionView(_ collectionView: UICollectionView,
////                        layout collectionViewLayout: UICollectionViewLayout,
////                        sizeForItemAt indexPath: IndexPath) -> CGSize {
////        //2
////        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
////        let availableWidth = view.frame.width - paddingSpace
////        let widthPerItem = availableWidth / itemsPerRow
////        
////        return CGSize(width: widthPerItem, height: widthPerItem)
////    }
////    
////    //3
////    func collectionView(_ collectionView: UICollectionView,
////                        layout collectionViewLayout: UICollectionViewLayout,
////                        insetForSectionAt section: Int) -> UIEdgeInsets {
////        return sectionInsets
////    }
////    
////    // 4
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
////        return sectionInsets.left
////    }
//}
