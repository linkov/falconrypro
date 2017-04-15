//
//  Extensions.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/15/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        return dateFormatter.string(from: self)
    }
}
