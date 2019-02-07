//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 31/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    
    var longitude: Double?
    var latitude: Double?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
        mediaURLTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationTextField.becomeFirstResponder()
    }
    
    // MARK: Actions
    
    @IBAction func findLocationPressed(_ sender: Any) {
        guard let location = locationTextField.text,
        let mediaURL = mediaURLTextField.text,
        location != "",
        mediaURL != "" else {
            let alert = UIAlertController(title: "Required field", message: "Please fill both the location and URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        ActivityIndicator.startActivityIndicator(view: self.view)
        let studentLocation = StudentLocation.init(createdAt: "", firstName: nil, lastName: nil, latitude: 0, longitude: 0, mapString: location, mediaURL: mediaURL, objectId: "", uniqueKey: "", updatedAt: "")
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(studentLocation.mapString!) { (placeMarks, _) in
            guard let marks = placeMarks else {
                let alert = UIAlertController(title: "Error", message: "Could't find your location, please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            var studentLocation = studentLocation
            studentLocation.longitude = Double(((marks.first!.location?.coordinate.longitude)!))
            studentLocation.latitude = Double(((marks.first!.location?.coordinate.latitude)!))
            studentLocation.firstName = ""
            studentLocation.lastName = ""
            
            ActivityIndicator.stopActivityIndicator()
            self.performSegue(withIdentifier: "toConfirmLocation", sender: studentLocation)
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirmLocation" {
            let viewController = segue.destination as! ConfirmLocationViewController
            viewController.studentLocation = (sender as! StudentLocation)
        }
    }
}

// MARK: - Text Field Delegate

extension AddLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // When return is pressed for username, move to the next text field
        if textField == locationTextField {
            textField.resignFirstResponder()
            mediaURLTextField.becomeFirstResponder()
        }
        // When return is pressed for password, call loginPressed
        if textField == mediaURLTextField {
            findLocationPressed(self)
        }
        return true
    }
}
