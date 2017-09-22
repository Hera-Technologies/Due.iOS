//
//  PortalButton.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class PortalButton: NSObject {
    var icon: String?
    var titulo: String?
    var items: String?
    
    init(titulo: String, icon: String, items: String) {
        self.titulo = titulo
        self.icon = icon
        self.items = items
    }
}
