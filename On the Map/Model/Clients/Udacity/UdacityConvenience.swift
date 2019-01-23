//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 21/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import UIKit

extension UdacityClient {
    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        self.getSessionID() { (success, sessionID, userID, errorString) in
            if success {
                // we have the session ID and user ID
                self.sessionID = sessionID
                self.userID = userID
                
                // now get user first name and last name
                self.getUserData(forID userID: userID) { (nickname)}
            }
        } else {
            completionHandlerForAuth(success, errorString)
        }
    }
}
