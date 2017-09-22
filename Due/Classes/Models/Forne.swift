//
//  Forne.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class Forne: NSObject {
    var childID: String?
    var categoria: String?
    var fornecedor: String?
    var fbUrl: String?
    var instaUrl: String?
    
    init(childID: String, postData: [String: AnyObject]) {
        self.childID = childID
        if let title = postData["categoria"] as? String {
            self.categoria = title
        }
        if let forne = postData["fornecedor"] as? String {
            self.fornecedor = forne
        }
    }
}
