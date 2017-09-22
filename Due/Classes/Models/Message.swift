//
//  Message.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import Foundation

class Message: NSObject {
    
    var postID: String?
    var message: String?
    var name: String?
    var photo: String?
    
    init(postID: String, postData: [String: AnyObject]) {
        
        self.postID = postID
        if let message = postData["message"] as? String {
            self.message = message
        }
        
        if let name = postData["name"] as? String {
            self.name = name
        }
        
        if let photo = postData["photo"] as? String {
            self.photo = photo
        }
        
    }
    
}
