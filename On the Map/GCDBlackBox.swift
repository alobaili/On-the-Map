//
//  GCDBlackBox.swift
//  On the Map
//
//  Created by Abdulaziz AlObaili on 23/01/2019.
//  Copyright © 2019 Abdulaziz Alobaili. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
