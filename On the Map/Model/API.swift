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
    
    var key: String = ""
    var id: String = ""
    
    func login(username: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        let params = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let url = "https://onthemap-api.udacity.com/v1/session"
        request(url: url, method: "POST", parameters: params) { (status, data, error) in
            guard status else {
                completion("incorrect username or password")
                return
            }
            do {
                let newData = data?.subdata(in: 5..<data!.count)
                let data = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments)  as? [String: Any]
                let sessionDictionary = data?["session"] as? [String: Any]
                let accountDictionary = data?["account"] as? [String: Any]
                self.key = accountDictionary?["key"] as? String ?? ""
                print(self.key)
                self.id = sessionDictionary?["id"] as? String ?? ""
                completion(nil)
            } catch {
                completion("couldn't serialize the object")
            }
        }
    }
    
    func logout(completion: @escaping (_ status: Bool) -> Void) {
        
    }
    
    func getStudentLocations(limit: Int = 100, skip: Int = 0, orderBy: String = "updatedAt", completion: @escaping ([StudentLocation]?) -> Void) {
        let url = "https://parse.udacity.com/parse/classes/StudentLocation?limit=\(limit)&skip=\(skip)&order=\(orderBy)"
        
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
    
    func getUserInfo(completion: @escaping (_ status: Bool) -> Void) {
        let url = "https://onthemap-api.udacity.com/v1/\(self.key)"
        request(url: url, method: "GET") { (status, data, error) in
            guard status else {
                return
            }
            let newData = data?.subdata(in: 5..<data!.count)
            do {
                let object = try JSONSerialization.jsonObject(with: newData!, options: [])
                print(object)
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    func postLocation(location: StudentLocation, completion: @escaping (_ status: Bool) -> Void) {
        let url = "https://parse.udacity.com/parse/classes/StudentLocation"
        var params: Data?
        do {
            params = try JSONEncoder().encode(location)
        } catch {
            print(error)
        }
        request(url: url, method: "POST", parameters: params) { (status, data, error) in
            guard status else {
                completion(false)
                return
            }
            do {
                let data = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                print(data)
                completion(true)
            } catch {
                print(error)
                completion(false)
            }
        }
    }
    
    func request(url: String, method: String, parameters: Data? = nil, completion: @escaping (_ status: Bool, _ data: Data?, _ error: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.httpBody = parameters
        request.httpMethod = method
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse,
                let data = data, (response.statusCode >= 200 && response.statusCode < 300) else {
                    completion(false, nil, "Network error")
                    return
            }
            completion(true, data, nil)
        }.resume()
    }
}
