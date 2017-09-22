//
//  AlbumPhoto.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import Foundation

class AlbumPhoto: NSObject {
    
    var postID: String?
    var imageUrl: String?
    
    init(postID: String, postData: [String: AnyObject]) {
        self.postID = postID
        if let image = postData["foto"] as? String {
            self.imageUrl = image
        }
    }
}
