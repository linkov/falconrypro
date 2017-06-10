//
//  SDWStatsListHeaderView.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/31/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import UICountingLabel


class SDWStatsListHeaderView: UIView {
    
    
    @IBOutlet weak var distanceCountLabel: UICountingLabel!
    @IBOutlet weak var fieldCountLabel: UICountingLabel!
    @IBOutlet weak var successCountLabel: UICountingLabel!
    @IBOutlet weak var bagCountLabel: UICountingLabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func animateLabels() {
        
        distanceCountLabel.format = "%02d"
        fieldCountLabel.format = "%02d"
        successCountLabel.format = "%02d"
        bagCountLabel.format = "%02d"
        
        distanceCountLabel.method = .linear
         fieldCountLabel.method = .linear
         successCountLabel.method = .linear
         bagCountLabel.method = .linear
        
        
        distanceCountLabel.animationDuration = 0.24
        fieldCountLabel.animationDuration = 0.24
        successCountLabel.animationDuration = 0.24
        bagCountLabel.animationDuration = 0.24
        
        
        distanceCountLabel.countFromZero(to: 320)
        fieldCountLabel.countFromZero(to:65)
        
        successCountLabel.countFromZero(to: 20)
        bagCountLabel.countFromZero(to:4)
        
        
    }
 
}
