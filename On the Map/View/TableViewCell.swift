//
//  TableViewCell.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 26/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mediaURLLabel: UILabel!
    
    func fillCell(studentLocation: StudentLocation) {
        if let frist = studentLocation.firstName , let last = studentLocation.lastName , let url = studentLocation.mediaURL {
            
            nameLabel.text = "\(frist) \(last)"
            mediaURLLabel.text = "\(url)"
            
        }
    }
}
