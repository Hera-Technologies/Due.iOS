//
//  Support.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

// MARK: COLOR PALETTE

let bourbon = [UIColor(red: 236/255, green: 111/255, blue: 102/255, alpha: 1).cgColor, UIColor(red: 243/255, green: 161/255, blue: 131/255, alpha: 1).cgColor]
let offwhite = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
let linewhite = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
let dark = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
let darker = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)

// MARK: EXTENSIONS

extension String {
    
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    /// http://www.ietf.org/rfc/rfc3986.txt
    /// :returns: Returns percent-escaped string.
    
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~@")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
}

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    /// This percent escapes in compliance with RFC 3986
    /// http://www.ietf.org/rfc/rfc3986.txt
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        return parameterArray.joined(separator: "&")
    }
    
}


// MARK: HELPER METHODS


// Identify numbers in a String

func identifyNumbers(amount: String) -> Int {
    let numbers = amount.components(separatedBy: CharacterSet.decimalDigits.inverted)
    let newStr = numbers.joined(separator: "")
    let num = Int(newStr)
    return num!
}

// Activity indicator 

func showActivityIndicator(view: UIView, indicator: UIActivityIndicatorView) {
    
    let container: UIView = UIView()
    container.frame = view.frame
    container.center = view.center
    container.tag = 100
    container.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
    
    let loadingView: UIView = UIView()
    loadingView.frame.size = CGSize(width: 80, height: 70)
    loadingView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
    loadingView.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    indicator.frame.size = CGSize(width: 40, height: 40)
    indicator.activityIndicatorViewStyle = .whiteLarge
    indicator.center = CGPoint(x: loadingView.frame.width / 2, y: loadingView.frame.height / 2)
    
    loadingView.addSubview(indicator)
    container.addSubview(loadingView)
    view.addSubview(container)
    indicator.startAnimating()
    
}

func dismissActivityIndicator(view: UIView, indicator: UIActivityIndicatorView, completion: () -> Void) {
    indicator.hidesWhenStopped = true
    indicator.stopAnimating()
    if let tagView = view.viewWithTag(100) {
        tagView.removeFromSuperview()
        completion()
    }
}
