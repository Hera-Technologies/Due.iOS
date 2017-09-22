//
//  HomeScreenCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Foundation

class HomeScreenCell: UICollectionViewCell {
    
    var cellConfig: HomeCellConfig? {
        didSet {
            guard let cellConfig = cellConfig else { return }
            icon.image = cellConfig.icon
            titulo.text = cellConfig.title
            texto.text = cellConfig.message
        }
    }
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let titulo: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = dark
        lbl.font = UIFont(name: "Avenir-Black", size: 24)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let line: UIView = {
        let vi = UIView()
        vi.backgroundColor = linewhite
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let texto: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .justified
        lbl.textColor = .gray
        lbl.font = UIFont(name: "Avenir-Heavy", size: 16)
        lbl.numberOfLines = 0
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor =  0.2
        return lbl
    }()
    
    let arrow: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "rightarrow")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 18
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.3
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        addSubview(icon)
        addSubview(titulo)
        addSubview(line)
        addSubview(texto)
        addSubview(arrow)
        
        let iconY = self.frame.height * 0.25
        icon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -iconY).isActive = true
        icon.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        icon.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        
        titulo.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        titulo.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 15).isActive = true
        
        line.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        texto.center.x = self.frame.width * 0.06
        texto.frame.origin.y = self.frame.height * 0.6
        texto.frame.size = CGSize(width: self.frame.width * 0.85, height: self.frame.height * 0.24)
        
        arrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        arrow.topAnchor.constraint(equalTo: texto.bottomAnchor, constant: 0).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 25).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
}




