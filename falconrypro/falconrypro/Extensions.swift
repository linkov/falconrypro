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
    
    static func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    static let style_bold = Style("bold", {
        $0.font = FontAttribute(.HelveticaNeue_Bold, size: 14)
        $0.color = .black
    })
    
    static let style_normal = Style("normal", {
        $0.font = FontAttribute(.HelveticaNeue, size: 14)
        $0.color = .black
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
