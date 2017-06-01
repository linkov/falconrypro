//
//  SDWChartDateValueFormatter.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/1/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import Charts

class SDWChartDateValueFormatter: NSObject,IAxisValueFormatter {

    
    var formatter:DateFormatter = DateFormatter()
    
    override init() {
        self.formatter.dateFormat = "dd MMM"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return formatter.string(from: Date(timeIntervalSince1970: value))
    }
}
