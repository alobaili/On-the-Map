//
//  LoginViewController.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 19/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var parseClient: ParseClient!
    var udacityClient: UdacityClient!
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")
        guard let newUrl = url else {return}
        let svc = SFSafariViewController(url: newUrl)
        present(svc, animated: true, completion: nil)
    }
    
    // MARK: Login
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
        
        present(controller, animated: true, completion: nil)
    }


}


// MARK: Text Field Delegate
extension LoginViewController: UITextFieldDelegate {
    
    // When return is pressed, move to the next text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
