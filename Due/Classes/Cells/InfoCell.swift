//
//  InfoCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    
    var model: Info!
    var vc: InfoVC?
    var otherVC: InfoListVC?
    
    let titulo: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = .black
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let message: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .justified
        lbl.textColor = .darkGray
        lbl.font = UIFont(name: "Avenir-Roman", size: 15)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        
        addSubview(titulo)
        addSubview(message)
        
        titulo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titulo.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        
        message.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 8).isActive = true
        message.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        message.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        message.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        
    }
    
    func configureCell(info: Info) {
        self.model = info
        self.titulo.text = info.titulo
        self.message.text = info.texto
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

