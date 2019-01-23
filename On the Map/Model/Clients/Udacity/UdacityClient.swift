//
//  UdacityClient.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 21/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation

// MARK: UdacityClient: NSObject

class UdacityClient: NSObject {
    
    // MARK: Properties
    
    // Shared session
    var session = URLSession.shared
    
    // Authentication state
    var sessionID : String? = nil
    var userID : String? = nil
    var nickname : String? = nil
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
