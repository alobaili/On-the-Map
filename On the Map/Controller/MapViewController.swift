//
//  MapViewController.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 21/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var studentLocations = StudentLocationsArray.shared.studentLocationsArray as! [StudentLocation]
    var studentAnnotations = [MKPointAnnotation]()

    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        reloadAnnotations()
    }
    
    // MARK: Actions
    
    @IBAction func logoutPressed(_ sender: Any) {
        API.shared.logout { (status) in
            guard status else {
                return
            }
            performUIUpdatesOnMain {
                self.tabBarController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        reloadAnnotations()
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
            let urlString = view.annotation?.subtitle!
            
            guard verifyURL(urlString: urlString) else {
                let alert = UIAlertController(title: "Invalid URL", message: "The location you selected has an invalid URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let url = URL(string: urlString!)
            let svc = SFSafariViewController(url: url!)
            present(svc, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper methods
    
    func reloadAnnotations() {
        studentLocations.removeAll()
        studentAnnotations.removeAll()
        let currentAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(currentAnnotations)
        
        API.shared.getLocations { (locations) in
            
            // make sure locations contains a value
            guard locations != nil else {
                return
            }
            // we can now safely force unwrap locations and assign it to
            // self.studentLocations
            self.studentLocations = locations! as [StudentLocation]
            
            // Set up and present student location annotations
            for location in self.studentLocations where location.latitude != nil && location.longitude != nil {
                
                let lat = CLLocationDegrees(location.latitude!)
                let long = CLLocationDegrees(location.longitude!)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                

                let mediaURL = location.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                
                if let firstName = location.firstName, let lastName = location.lastName {
                    annotation.title = "\(firstName) \(lastName)"
                }
                
                annotation.subtitle = mediaURL
                
                self.studentAnnotations.append(annotation)
            }
            
            performUIUpdatesOnMain {
                self.mapView.addAnnotations(self.studentAnnotations)
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
