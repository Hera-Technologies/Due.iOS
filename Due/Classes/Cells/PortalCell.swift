//
//  PortalCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class PortalCell: UICollectionViewCell {
    
    var vc: PortalVC?
    var model: PortalButton!
    
    let gradient: CAGradientLayer = {
        let grad = CAGradientLayer()
        grad.colors = bourbon
        grad.cornerRadius = 12
        return grad
    }()
    
    let container: UIView = {
        let vi = UIView()
        vi.backgroundColor = .clear
        return vi
    }()
    
    let titulo: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let icon: NetworkImageView = {
        let img = NetworkImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let fileIcon: NetworkImageView = {
        let img = NetworkImageView()
        img.image = #imageLiteral(resourceName: "files")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let itensLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .bar)
        bar.progressTintColor = UIColor(red: 55/255, green: 236/255, blue: 186/255, alpha: 1)
        bar.trackTintColor = .white
        bar.layer.masksToBounds = true
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    let progressLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = UIFont(name: "Avenir-Book", size: 13)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let beginBtn: UILabel = {
        let lbl = UILabel()
        lbl.text = "Editar"
        lbl.textAlignment = .center
        lbl.textColor = UIColor(red: 236/255, green: 111/255, blue: 102/255, alpha: 1)
        lbl.backgroundColor = .white
        lbl.layer.masksToBounds = true
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setup()
    }
    
    func setup() {
        
        addSubview(container)
        container.addSubview(titulo)
        container.addSubview(itensLbl)
        container.addSubview(fileIcon)
        container.addSubview(icon)
        container.addSubview(progressBar)
        container.addSubview(progressLbl)
        container.addSubview(beginBtn)
        
        let containerHeight: CGFloat?
        let lblY = self.frame.height * 0.12
        
        // MARK: ADJUSTING CONTENT TO DEVICE
        let size = UIScreen.main.bounds.width
        if size <= 320 {
            containerHeight = self.frame.height * 0.9
            titulo.font = UIFont(name: "Avenir-Book", size: 20)
            titulo.topAnchor.constraint(equalTo: container.topAnchor, constant: 15).isActive = true
            itensLbl.font = UIFont(name: "Avenir-Roman", size: 13)
            progressBar.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.7).isActive = true
            progressBar.heightAnchor.constraint(equalToConstant: 6).isActive = true
            progressBar.layer.cornerRadius = 3
            beginBtn.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -15).isActive = true
        } else {
            containerHeight = self.frame.height * 0.85
            titulo.font = UIFont(name: "Avenir-Book", size: 33)
            let titleY = self.frame.height * 0.25
            titulo.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -titleY).isActive = true
            itensLbl.font = UIFont(name: "Avenir-Roman", size: 15)
            progressBar.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.75).isActive = true
            progressBar.heightAnchor.constraint(equalToConstant: 8).isActive = true
            progressBar.layer.cornerRadius = 4
            let btnY = self.frame.height * 0.22
            beginBtn.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: btnY).isActive = true
        }
        
        container.frame.size = CGSize(width: self.frame.width * 0.95, height: containerHeight!)
        container.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        gradient.frame = container.frame
        layer.insertSublayer(gradient, at: 0)
        
        titulo.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        
        fileIcon.leadingAnchor.constraint(equalTo: titulo.leadingAnchor).isActive = true
        fileIcon.centerYAnchor.constraint(equalTo: itensLbl.centerYAnchor).isActive = true
        
        itensLbl.leftAnchor.constraint(equalTo: fileIcon.rightAnchor, constant: 8).isActive = true
        itensLbl.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -lblY).isActive = true
        
        icon.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        icon.centerYAnchor.constraint(equalTo: titulo.centerYAnchor, constant: 5).isActive = true
        icon.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.16).isActive = true
        icon.heightAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.12).isActive = true
        
        progressBar.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        progressLbl.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor, constant: 0).isActive = true
        progressLbl.leftAnchor.constraint(equalTo: progressBar.rightAnchor, constant: 8).isActive = true
        
        let hgt = UIScreen.main.bounds.height * 0.07
        beginBtn.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        beginBtn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        beginBtn.heightAnchor.constraint(equalToConstant: hgt).isActive = true
        beginBtn.layer.cornerRadius = hgt / 2
        
    }
    
    func configureCell(button: PortalButton) {
        self.model = button
        self.titulo.text = button.titulo
        self.icon.image = UIImage(named: button.icon!)
        self.itensLbl.text = button.items
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

