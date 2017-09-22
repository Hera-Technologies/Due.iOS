//
//  CardFront.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import Foundation
import UIKit

class CardFront: UIView {
    
    var gradient: CAGradientLayer!
    
    let chip: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "micro")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let banco: UILabel = {
        let lbl = UILabel()
        lbl.text = "Banco"
        lbl.textColor  = .white
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let cardNum: UILabel = {
        let lbl = UILabel()
        lbl.text = "1234   5678   9012   3456"
        lbl.textColor  = .white
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Light", size: 20)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let good: UILabel = {
        let lbl = UILabel()
        lbl.text = "GOOD"
        lbl.textColor  = .white
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Light", size: 8)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let thru: UILabel = {
        let lbl = UILabel()
        lbl.text = "THRU"
        lbl.textColor  = .white
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Light", size: 8)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let expDate: UILabel = {
        let lbl = UILabel()
        lbl.text = "05/25"
        lbl.textColor  = .white
        lbl.textAlignment = .right
        lbl.font = UIFont(name: "Avenir-Light", size: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let nome: UILabel = {
        let lbl = UILabel()
        lbl.text = "Nome  Sobrenome"
        lbl.textColor  = .white
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Light", size: 15)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let provider1: UIView = {
        let vi = UIView()
        vi.backgroundColor = .clear
        vi.layer.borderWidth = 1
        vi.layer.borderColor = UIColor.white.cgColor
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let provider2: UIView = {
        let vi = UIView()
        vi.backgroundColor = .clear
        vi.layer.borderWidth = 1
        vi.layer.borderColor = UIColor.white.cgColor
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        createGradientLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        self.addSubview(chip)
        self.addSubview(banco)
        self.addSubview(cardNum)
        self.addSubview(good)
        self.addSubview(thru)
        self.addSubview(expDate)
        self.addSubview(nome)
        self.addSubview(provider1)
        self.addSubview(provider2)
        
        banco.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        banco.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        
        cardNum.frame.size = CGSize(width: self.frame.width * 0.9, height: 20)
        cardNum.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        expDate.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 20).isActive = true
        expDate.topAnchor.constraint(equalTo: cardNum.bottomAnchor, constant: 10).isActive = true
        
        good.rightAnchor.constraint(equalTo: expDate.leftAnchor, constant: -6).isActive = true
        good.centerYAnchor.constraint(equalTo: expDate.centerYAnchor, constant: -5).isActive = true
        thru.rightAnchor.constraint(equalTo: expDate.leftAnchor, constant: -6).isActive = true
        thru.topAnchor.constraint(equalTo: good.bottomAnchor, constant: 0).isActive = true
        
        chip.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 23).isActive = true
        chip.centerYAnchor.constraint(equalTo: expDate.centerYAnchor).isActive = true
        
        nome.frame.size = CGSize(width: self.frame.width * 0.6, height: 20)
        nome.frame.origin = CGPoint(x: 15, y: self.frame.height * 0.8)
        
        provider2.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        provider2.rightAnchor.constraint(equalTo: provider1.leftAnchor, constant: 20).isActive = true
        provider2.heightAnchor.constraint(equalToConstant: 25).isActive = true
        provider2.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        provider1.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        provider1.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        provider1.heightAnchor.constraint(equalToConstant: 25).isActive = true
        provider1.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func createGradientLayer() {
        gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor(red: 236/255, green: 111/255, blue: 102/255, alpha: 1).cgColor, UIColor(red: 243/255, green: 161/255, blue: 131/255, alpha: 1).cgColor]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
