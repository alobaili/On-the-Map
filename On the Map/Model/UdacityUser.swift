//
//  UdacityUser.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 23/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation

struct UdacitySessionBody : Codable {
    let udacity : Udacity
}

struct Udacity : Codable {
    let username: String
    let password: String
}
