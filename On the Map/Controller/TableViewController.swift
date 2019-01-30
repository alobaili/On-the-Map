//
//  TableViewController.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 21/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
    
    var studentLocations = StudentLocationsArray.shared.studentLocationsArray
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        API.shared.getLocations { (locations) in
            self.studentLocations = locations!
            
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        cell.fillCell(studentLocation: studentLocations[indexPath.row] as! StudentLocation)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataArray = studentLocations as! [StudentLocation]
        let urlString = dataArray[indexPath.row].mediaURL
        
        // check if the selected cell has a valid URL (contains a full URL scheme). Otherwise, show an alert
        guard verifyURL(urlString: urlString) else {
            let alert = UIAlertController(title: "Invalid URL", message: "The location you selected has an invalid URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let url = URL(string: urlString!)
        let svc = SFSafariViewController(url: url!)
        present(svc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99.5
    }
    
    private func verifyURL(urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create URL instance
            if let url = URL(string: urlString) {
                // check if the app can open the URL instance
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
}
