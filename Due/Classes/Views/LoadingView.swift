//
//  LoadingView.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    let image: UIImageView = {
        let vi = UIImageView()
        vi.image = UIImage(named: "sandclock")
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let message: UILabel = {
        let lbl = UILabel()
        lbl.text = "Só um segundo, estamos preparando tudo para você : )"
        lbl.font = UIFont(name: "AvenirNext-UltraLight", size: 25)
        lbl.textColor = darker
        lbl.textAlignment = .justified
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let indicator: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.color = .red
        ind.activityIndicatorViewStyle = .gray
        ind.translatesAutoresizingMaskIntoConstraints = false
        return ind
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1)
        setup()
    }
    
    func setup() {
        
        addSubview(indicator)
        addSubview(image)
        addSubview(message)
        
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicator.startAnimating()
        
        image.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: indicator.topAnchor, constant: -30).isActive = true
        image.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.16).isActive = true
        image.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.18).isActive = true
        
        message.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        message.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 30).isActive = true
        message.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        
    }
    
}
