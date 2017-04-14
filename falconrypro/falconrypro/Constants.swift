//
//  Constants.swift
//  falconrypro
//
//  Created by Alex Linkov on 4/14/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation

public struct Constants {
    
    struct server {
        static let DEV = "http://localhost:3000/api/v1"
        static let PROD = "http://falconrypro.com/api/v1"
        
        #if PROD
        static let BASEURL = PROD
        #else
        static let BASEURL = DEV
        #endif
    }
}
