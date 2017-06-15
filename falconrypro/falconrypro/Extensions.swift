//
//  Extensions.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/15/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import UIKit
import SwiftRichString

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        return dateFormatter.string(from: self)
    }
}

public extension UIView
{
    static func loadFromXib<T>() -> T where T: UIView
    {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
}

struct AppUtility {
    
    static let app_color_black:UIColor = UIColor(hex: "24292e")
    static let app_color_offWhite:UIColor = UIColor(hex: "fafbfc")
    static let app_color_lightGray:UIColor = UIColor(hex: "e8e9eb")
    static let app_color_linkBlue:UIColor = UIColor(hex: "0366d6")
    static let app_color_green:UIColor = UIColor(hex: "28a745")
    static let app_color_velvet:UIColor = UIColor(hex:"6f42c1")
    
    static let app_color_red:UIColor = UIColor(hex: "cb2431")
    
    
    static func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    static let style_bold = Style("bold", {
        $0.font = FontAttribute(.HelveticaNeue_Bold, size: 14)
        $0.color = AppUtility.app_color_black
    })
    
    static let style_normal = Style("normal", {
        $0.font = FontAttribute(.HelveticaNeue, size: 14)
        $0.color = AppUtility.app_color_black
    })
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}


extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
