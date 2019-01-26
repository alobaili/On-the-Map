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
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        // Check if username and password is empty
        if (username!.isEmpty || password!.isEmpty) {
            let alert = UIAlertController(title: "Required field", message: "Please fill both the username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        } else { // we know now that username and password is not empty
            API.shared.login(username: username!, password: password!) { (error) in
                guard error == nil else {
                    print(error)
                    return
                }
                self.completeLogin()
            }
        }
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")
        guard let newUrl = url else {return}
        let svc = SFSafariViewController(url: newUrl)
        present(svc, animated: true, completion: nil)
    }
    
    // MARK: Login
    private func completeLogin() {
        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: Display error
    private func displayError(_ errorString: String?) {
        if let errorString = errorString {
            print(errorString) // just print it in the console for now
        }
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
