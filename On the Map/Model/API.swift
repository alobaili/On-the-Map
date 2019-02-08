//
//  API.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 26/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation

class API {
    static let shared = API()
    private init() {}
    
    // Shared instance
    var key: String = ""
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var nickname: String = ""
    
    // MARK: Login
    func login(username: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        let params = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let url = "https://onthemap-api.udacity.com/v1/session"
        request(url: url, method: "POST", parameters: params) { (status, data, error) in
            guard status else {
                completion(error)
                return
            }
            do {
                let newData = data?.subdata(in: 5..<data!.count)
                let data = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments)  as? [String: Any]
                let sessionDictionary = data?["session"] as? [String: Any]
                let accountDictionary = data?["account"] as? [String: Any]
                
                // if the unique key or session id exist, save it in the shared instance
                self.key = accountDictionary?["key"] as? String ?? ""
                self.id = sessionDictionary?["id"] as? String ?? ""
                print("log in successful with user key: \(self.key)")
                completion(nil)
                
            } catch {
                completion("couldn't serialize the object")
            }
        }
    }
    
    // MARK: Logout
    func logout(completion: @escaping (_ status: Bool) -> Void) {
        let url = "https://onthemap-api.udacity.com/v1/session"
        
        request(url: url, method: "DELETE") { (status, data, error) in
            guard status else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // MARK: Get student locations
    func getLocations(limit: Int = 100, skip: Int = 0, orderBy: String = "updatedAt", completion: @escaping ([StudentLocation]?) -> Void) {
        let url = "https://parse.udacity.com/parse/classes/StudentLocation?limit=\(limit)&skip=\(skip)&order=-\(orderBy)"
        
        request(url: url, method: "GET") { (status, data, error) in
            guard status else {
                completion(nil)
                return
            }
            do {
                let location = try JSONDecoder().decode(StudentLocationResult.self, from: data!)
                completion(location.results)
            } catch {
                completion(nil)
            }
        }
    }
    
    // MARK: Get user information
    func getUserInfo(completion: @escaping (_ status: Bool) -> Void) {
        print("Attemting to get user info for key: \(self.key)")
        
        let url = "https://onthemap-api.udacity.com/v1/users/\(self.key)"
        
        request(url: url, method: "GET") { (status, data, error) in
            guard status else {
                print("getUserInfo failed with error: \(error!)")
                return
            }
            let newData = data?.subdata(in: 5..<data!.count)
            do {
                let object = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String : Any]
                self.nickname = object?["nickname"] as? String ?? ""
                var components = self.nickname.components(separatedBy: " ")
                self.firstName = components.removeFirst()
                self.lastName = components.joined(separator: " ")
                
                completion(true)
            } catch {
                completion(false)
            }
            print("User info retrieved successfully:")
            print("Nickname: \(self.nickname)")
            print("First Name: \(self.firstName)")
            print("Last Name: \(self.lastName)")
        }
    }
    
    // MARK: Post a student location
    func postLocation(location: StudentLocation, completion: @escaping (_ status: Bool) -> Void) {
        var url: String
        var method: String
        if location.objectId == "" {
            print("Attempting to post a new location with the following data:")
            print("Unique Key: \(location.uniqueKey!)")
            print("First Name: \(location.firstName!)")
            print("Last Name: \(location.lastName!)")
            print("Map String: \(location.mapString!)")
            print(("Media URL: \(location.mediaURL!)"))
            print(("Latitude: \(location.latitude!)"))
            print(("Longitude: \(location.longitude!)"))
            
            url = "https://parse.udacity.com/parse/classes/StudentLocation"
            method = "POST"
        } else {
            print("Attempting to update current location with object ID: \(String(describing: location.objectId))")
            
            url = "https://parse.udacity.com/parse/classes/StudentLocation/\(String(describing: location.objectId))"
            method = "PUT"
        }
        var params: Data?
        params = "{\"uniqueKey\": \"\(API.shared.key)\", \"firstName\": \"\(location.firstName ?? "")\", \"lastName\": \"\(location.lastName ?? "")\",\"mapString\": \"\(location.mapString ?? "")\", \"mediaURL\": \"\(location.mediaURL ?? "")\",\"latitude\": \(location.latitude ?? 0), \"longitude\": \(location.longitude ?? 0)}".data(using: .utf8)

        request(url: url, method: method, parameters: params) { (status, data, error) in
            guard status else {
                print("postLocation failed with error: \(error!)")
                completion(false)
                return
            }
            do {
                _ = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                completion(true)
            } catch {
                print(error)
                completion(false)
            }
        }
    }
    
    // MARK: Request (reusable)
    func request(url: String, method: String, parameters: Data? = nil, completion: @escaping (_ status: Bool, _ data: Data?, _ error: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        
        // If the method is DELETE, setup the delete session request
        if method == "DELETE" {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        } else { // for requests other than deleting a session
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        request.httpBody = parameters
        request.httpMethod = method
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let response = response as? HTTPURLResponse
            
            guard response != nil else {
                completion(false, nil, "There is a problem with the internet connection")
                return
            }
            
            guard let data = data, ((response?.statusCode)! >= 200 && (response?.statusCode)! < 300) else {
                if (response?.statusCode)! == 403 {
                    completion(false, nil, "Wrong username or password")
                    return
                } else {
                    completion(false, nil, "Response status code: \(response!.statusCode)")
                    return
                }
            }
            
            completion(true, data, nil)
        }.resume()
    }
}
