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
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        API.shared.getLocations { (locations) in
            self.studentLocations = locations!
        }
        
        var studentAnnotations = [MKPointAnnotation]()
        
        
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
            
            self.mapView.addAnnotations(studentAnnotations)
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        API.shared.logout { (status) in
            guard status else {
                return
            }
            performUIUpdatesOnMain {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                
                self.present(controller, animated: true, completion: nil)
            }
        }
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
