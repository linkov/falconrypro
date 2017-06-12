//
//  SDWSeasonListCell.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/10/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import BadgeSwift
import SwipeCellKit

class SDWSeasonListCell: SwipeTableViewCell {

    @IBOutlet weak var activeBadge: BadgeSwift!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
