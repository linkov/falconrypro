//
//  SDWDiaryListTableViewCell.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/30/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit

class SDWDiaryListTableViewCell: UITableViewCell {

    @IBOutlet weak var food: UILabel!
    @IBOutlet weak var eaten: UILabel!
    @IBOutlet weak var offered: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
