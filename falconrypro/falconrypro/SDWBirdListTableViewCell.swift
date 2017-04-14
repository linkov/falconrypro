//
//  SDWBirdListTableViewCell.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/14/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit

class SDWBirdListTableViewCell: UITableViewCell {

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
    
}
