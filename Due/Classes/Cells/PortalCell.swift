//
//  PortalCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

protocol PortalCellDelegate {
    func transition(cell: PortalCell)
}

class PortalCell: UICollectionViewCell {
    
    var model: PortalButton? {
        didSet {
            if let model = model {
                titulo.text = model.titulo
                itemsLbl.text = model.items
                icon.image = UIImage(named: model.icon!)
            }
        }
    }
    
    var delegate: PortalCellDelegate?
    
    let titulo: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = dark
        lbl.font = UIFont(name: "Avenir-Heavy", size: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let icon: NetworkImageView = {
        let img = NetworkImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let itemsIcon: NetworkImageView = {
        let img = NetworkImageView()
        img.image = #imageLiteral(resourceName: "files")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let itemsLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Avenir-Roman", size: 14)
        lbl.textAlignment = .center
        lbl.textColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .bar)
        bar.progressTintColor = UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1)
        bar.trackTintColor = .clear
        bar.layer.masksToBounds = true
        bar.progress = 0.3
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    let progressLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .gray
        lbl.font = UIFont(name: "Avenir-Book", size: 13)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.3
        setup()
        adjust()
    }
    
    func setup() {
        addSubview(titulo)
        addSubview(itemsIcon)
        addSubview(itemsLbl)
        addSubview(icon)
        addSubview(progressBar)
        addSubview(progressLbl)
        
        icon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        icon.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        icon.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        icon.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.27).isActive = true
        
        itemsIcon.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 12).isActive = true
        itemsIcon.centerYAnchor.constraint(equalTo: icon.centerYAnchor, constant: 0).isActive = true
        itemsIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        itemsIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        itemsLbl.leftAnchor.constraint(equalTo: itemsIcon.rightAnchor, constant: 6).isActive = true
        itemsLbl.centerYAnchor.constraint(equalTo: itemsIcon.centerYAnchor, constant: 0).isActive = true
        
        titulo.leadingAnchor.constraint(equalTo: icon.leadingAnchor).isActive = true
        titulo.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 8).isActive = true
        
        progressBar.centerYAnchor.constraint(equalTo: progressLbl.centerYAnchor, constant: 0).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: titulo.leadingAnchor).isActive = true
        progressBar.rightAnchor.constraint(equalTo: progressLbl.leftAnchor, constant: -5).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        progressBar.layer.cornerRadius = 1
        
        progressLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        progressLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
    }
    
    func adjust() {
        let size = UIScreen.main.bounds.width
        if size >= 414 {
            
        } else if size < 414 && size > 320 {
            
        } else if size <= 320 {
            titulo.font = UIFont(name: "Avenir-Heavy", size: 18)
            titulo.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 4).isActive = true
            itemsLbl.font = UIFont(name: "Avenir-Roman", size: 13)
            progressLbl.font = UIFont(name: "Avenir-Book", size: 12)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { (_) in
            self.delegate?.transition(cell: self)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

