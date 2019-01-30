//
//  MapViewController.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 21/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var studentLocations = StudentLocationsArray.shared.studentLocationsArray as! [StudentLocation]
    var studentAnnotations = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        API.shared.getLocations { (locations) in
            self.studentLocations = locations!
        }
        
        
        for location in studentLocations where location.latitude != nil && location.longitude != nil {
            
            let lat = CLLocationDegrees(location.latitude!)
            let long = CLLocationDegrees(location.longitude!)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = location.firstName!
            let lastName = location.lastName!
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(String(describing: firstName)) \(String(describing: lastName))"
            annotation.subtitle = mediaURL
            
            studentAnnotations.append(annotation)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.mapView.addAnnotations(studentAnnotations)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
    
    private func verifyURL(urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create URL instance
            if let url = URL(string: urlString) {
                // check if the app can open the URL instance
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
}
