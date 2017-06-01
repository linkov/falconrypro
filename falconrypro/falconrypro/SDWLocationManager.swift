//
//  SDWLocationManager.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/1/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import CoreLocation

class SDWLocationManager: NSObject, CLLocationManagerDelegate {
    
    enum Result <T> {
        case Success()
        case Failure()
    }
    
    static let shared:SDWLocationManager = SDWLocationManager()
    
    typealias Callback = (Result <SDWLocationManager>) -> Void
    
    var requests: Array <Callback> = Array <Callback>()
    var location: CLLocation? { return sharedLocationManager.location  }
    
    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self
        // ...
        return newLocationmanager
    }()
    
    // MARK: - Authorization
    
    class func authorize() { shared.authorize() }
    func authorize() { sharedLocationManager.requestWhenInUseAuthorization() }
    
    // MARK: - Helpers
    
    func locate(callback: @escaping Callback) {
        self.requests.append(callback)
        sharedLocationManager.startUpdatingLocation()
    }
    
    func reset() {
        self.requests = Array <Callback>()
        sharedLocationManager.stopUpdatingLocation()
    }
    
    // MARK: - Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        for request in self.requests { request(.Failure()) }
        self.reset()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for request in self.requests { request(.Success()) }
        self.reset()
    }


}
