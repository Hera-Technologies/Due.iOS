//
//  NetworkImageView.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class NetworkImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        imageUrlString = urlString
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //download hit an error so lets return out
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    guard let imageToCache = UIImage(data: data!) else { return }
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                })
                
            }).resume()
        }
    }
}
