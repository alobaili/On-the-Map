//
//  StudentLocation.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 23/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation

struct StudentLocation : Codable {
    
    let createdAt : String?
    let firstName : String?
    let lastName : String?
    let latitude : Double?
    let longitude : Double?
    let mapString : String?
    let mediaURL : String?
    let objectId : String?
    let uniqueKey : String?
    let updatedAt : String?
    
}

struct StudentLocations : Codable {
    let studentLocations : [StudentLocation]?
}
