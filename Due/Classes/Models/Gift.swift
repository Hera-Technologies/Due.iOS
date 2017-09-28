//
//  Gift.swift
//  Due
//
//  Created by Lucas Andrade on 9/27/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class Gift: NSObject {
    var image: String?
    var name: String?
    var amount: String?
    var desc: String?
    
    init(data: [String: Any]) {
        
        if let image = data["image"] as? String {
            self.image = image
        }
        
        if let name = data["name"] as? String {
            self.name = name
        }
        
        if let desc = data["desc"] as? String {
            self.desc = desc
        }
        
        if let amount = data["amount"] as? String {
            self.amount = amount
        }
        
    }
}
