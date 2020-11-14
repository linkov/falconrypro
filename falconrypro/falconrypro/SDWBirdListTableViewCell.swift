//
//  SDWBirdListTableViewCell.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/14/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import BadgeSwift
import SwipeCellKit

class SDWBirdListTableViewCell: SwipeTableViewCell {
    
    var context = CIContext(options: nil)
    @IBOutlet weak var badgeLabel: BadgeSwift!
    @IBOutlet weak var birdImage: UIImageView!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func noirUpImage() {
        
        if (birdImage.image == nil) {
            return
        }
        
        var inputImage = CIImage(image: birdImage.image!)
        let options:[String : AnyObject] = [CIDetectorImageOrientation:1 as AnyObject]
      //  let filters = inputImage!.autoAdjustmentFilters(options: options)
        
//        for filter: CIFilter in filters {
//            filter.setValue(inputImage, forKey: kCIInputImageKey)
//            inputImage =  filter.outputImage
//        }
        let cgImage = context.createCGImage(inputImage!, from: inputImage!.extent)
        self.birdImage.image =  UIImage(cgImage: cgImage!)
        
        //Apply noir Filter
        let currentFilter = CIFilter(name: "CIPhotoEffectTonal")
        currentFilter!.setValue(CIImage(image: UIImage(cgImage: cgImage!)), forKey: kCIInputImageKey)
        
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        birdImage.image = processedImage
    
    }
    
}
