//
//  StudentLocationsArray.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 29/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation

class StudentLocationsArray {
    static let shared = StudentLocationsArray()
    
    var studentLocationsArray = [Any?]()
    
    private init() { }
}
