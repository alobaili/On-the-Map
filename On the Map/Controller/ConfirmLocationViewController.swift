//
//  ConfirmLocationViewController.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 01/02/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentLocation: StudentLocation?
    var annotation : MKPointAnnotation?
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        let lat = CLLocationDegrees((studentLocation?.latitude!)!)
        let long = CLLocationDegrees((studentLocation?.longitude!)!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        self.annotation = MKPointAnnotation()
        self.annotation?.coordinate = coordinate
        self.annotation?.title = studentLocation?.mapString
        
        self.mapView.addAnnotation(self.annotation!)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func finishPressed(_ sender: Any) {
        studentLocation?.firstName = API.shared.firstName
        studentLocation?.lastName = API.shared.lastName
        studentLocation?.uniqueKey = API.shared.key
        API.shared.postLocation(location: studentLocation!) { (success) in
            guard success else{
                performUIUpdatesOnMain {
                    let alert = UIAlertController(title: "Error", message: "Could't add your location", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            performUIUpdatesOnMain {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
