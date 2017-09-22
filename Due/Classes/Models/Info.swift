//
//  Info.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class Info: NSObject {
    
    var childID: String
    var texto: String?
    var titulo: String?
    
    init(childID: String, postData: [String: AnyObject]) {
        self.childID = childID
        if let message = postData["message"] as? String {
            self.texto = message
        }
        if let photo = postData["title"] as? String {
            self.titulo = photo
        }
    }
}
