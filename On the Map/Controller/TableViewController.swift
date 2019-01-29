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
        let url = URL(string: (dataArray[indexPath.row].mediaURL)!)
        guard let newUrl = url else {return}
        let svc = SFSafariViewController(url: newUrl)
        present(svc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99.5
    }
    
}
