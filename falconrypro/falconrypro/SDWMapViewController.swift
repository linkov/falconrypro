//
//  SDWMapViewController.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/1/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import MapKit
import Mapbox

class SDWMapViewController: UIViewController, MGLMapViewDelegate {
    
    var locationManager:SDWLocationManager = SDWLocationManager.shared
    let regionRadius: CLLocationDistance = 1000
    var pins:[PinItemDisplayItem]?
    
    @IBOutlet weak var mgMapView: MGLMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mgMapView.delegate = self
        

        
        locationManager.locate { result in
            switch result {
            case .Success():
                if let location = self.locationManager.location {
//                    self.mgMapView.latitude = location.coordinate.latitude
//                    self.mgMapView.longitude = location.coordinate.longitude
                    self.mgMapView.setCenter(location.coordinate, zoomLevel: 15, animated: false)
                    let point = MGLPointAnnotation()
                    point.coordinate = location.coordinate
                    point.title = "Rabbit"
                    point.subtitle = "9 hours ago"
                    self.mgMapView.addAnnotation(point)
                    
                    
                    
                    if ((self.pins) != nil) {
                        if ( (self.mgMapView.annotations != nil) && (self.mgMapView.annotations?.count)! > 0) {
                            self.mgMapView.removeAnnotations(self.mgMapView.annotations!)
                        }
                        
                        
                        for pin:PinItemDisplayItem in self.pins! {
                            
                            
                            let point = MGLPointAnnotation()
                            
                            point.coordinate = CLLocationCoordinate2D(latitude: pin.lat!, longitude: pin.long!)
                            point.title = pin.typeName
                            point.subtitle = pin.note

                            self.mgMapView.addAnnotation(point)
                            
                        }
                        
                        
                        let lastPin = self.pins?.last
                        
                        
                        self.mgMapView.setCenter(CLLocationCoordinate2D(latitude: (lastPin?.lat)!, longitude: (lastPin?.long)!), zoomLevel: 12, animated: false)
                    }
                    
                    
                    
                    
                    
//                    self.centerMapOnLocation(location)
                }
            case .Failure():
                print("ggg")
        
            }
        }
        
        
        
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if let annotation = annotation as? Artwork {
//            let identifier = "artPin"
//            var view: MKPinAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//                as? MKPinAnnotationView { // 2
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            } else {
//                // 3
//                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//            }
//            
//            view.pinTintColor = annotation.pinTintColor()
//            return view
//        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let location = view.annotation as! Artwork
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
//        mapView.setRegion(coordinateRegion, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let button:UIButton = UIButton.init(type: .detailDisclosure)
        button.tintColor = UIColor.black
        return button
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    // Or, if you’re using Swift 3 in Xcode 8.0, be sure to add an underscore before the method parameters:
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        
        let killString = "Kill"
        
        
        if (annotation.title! == killString) {
            
            // Try to reuse the existing ‘pisa’ annotation image, if it exists.
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "kill")
            
            if annotationImage == nil {
                var image = UIImage(named: "kill")!
                image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "kill")
            }
            
            return annotationImage
            
            
        } else {
            
            // Try to reuse the existing ‘pisa’ annotation image, if it exists.
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "interest")
            
            if annotationImage == nil {
                var image = UIImage(named: "interest")!
                image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "interest")
            }
            
            return annotationImage
            
        }
        

        
        
    }


}
