//
//  Photo.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import Foundation

class Photo: NSObject {
    
    var postID: String?
    
    var profilePhoto: String?
    var name: String?
    var imageUrl: String?
    var caption: String?
    
    init(postID: String, postData: [String: AnyObject]) {
        
        self.postID = postID
        
        if let photo = postData["profilePhoto"] as? String {
            self.profilePhoto = photo
        }
        
        if let name = postData["name"] as? String {
            self.name = name
        }
        
        if let image = postData["imageUrl"] as? String {
            self.imageUrl = image
        }
        
        if let caption = postData["caption"] as? String {
            self.caption = caption
        }
        
    }
    
}
