//
//  ParseConstants.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 21/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

// MARK: - Constants
extension ParseClient {
    
    // MARK - Constants
    struct Constants {

        // MARK: Parse
        struct Parse {
            static let APIBaseURL = "https://parse.udacity.com/parse/classes/"
        }
        
        // MARK: Parse Parameter Keys
        struct ParseParameterKeys {
            static let ObjectID = "objectId"
            static let UniqueKey = "uniqueKey"
            static let FirstName = "firstName"
            static let LastNAme = "lastName"
            static let MapString = "mapString"
            static let MediaURL = "mediaURL"
            static let Latitude = "latitude"
            static let Longitude = "longitude"
            static let CreatedAt = "createdAt"
            static let UpdatedAt = "updatedAt"
            static let ACL = "ACL"
        }
    }

}
