//
//  Padrinho.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import Foundation

class Padrinho: NSObject {
    
    var postID: String?
    var message: String?
    var photo: String?
    
    init(postID: String, postData: [String: AnyObject]) {
        
        self.postID = postID
        if let message = postData["texto"] as? String {
            self.message = message
        }
        
        if let photo = postData["foto"] as? String {
            self.photo = photo
        }
        
    }
    
}
