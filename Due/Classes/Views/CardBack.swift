//
//  CardBack.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import Foundation
import UIKit

class CardBack: UIView {
    
    var gradient: CAGradientLayer!
    
    let faixa: UIView = {
        let vi = UIView()
        vi.backgroundColor = .white
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let faixa2: UIView = {
        let vi = UIView()
        vi.backgroundColor = .white
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let line: UIView = {
        let vi = UIView()
        vi.backgroundColor = .darkGray
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let code: UILabel = {
        let lbl = UILabel()
        lbl.text = "cvc"
        lbl.textColor  = .darkGray
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Light", size: 15)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let lock: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "lock")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
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
    
    let black: UILabel = {
        let lbl = UILabel()
        lbl.text = "Bourbon"
        lbl.textColor  = .white
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Zapfino", size: 13)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
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
        
        self.addSubview(faixa)
        self.addSubview(faixa2)
        self.addSubview(lock)
        self.addSubview(provider1)
        self.addSubview(provider2)
        self.addSubview(black)
        
        faixa.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        faixa.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        faixa.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.1).isActive = true
        faixa.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
        
        faixa2.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        faixa2.topAnchor.constraint(equalTo: faixa.bottomAnchor, constant: 8).isActive = true
        faixa2.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65).isActive = true
        faixa2.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        faixa2.addSubview(line)
        faixa2.addSubview(code)
        line.centerYAnchor.constraint(equalTo: faixa2.centerYAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: code.leftAnchor, constant: -8).isActive = true
        line.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        line.heightAnchor.constraint(equalTo: faixa2.heightAnchor, multiplier: 0.8).isActive = true
        code.rightAnchor.constraint(equalTo: faixa2.rightAnchor, constant: -10).isActive = true
        code.centerYAnchor.constraint(equalTo: faixa2.centerYAnchor).isActive = true
        
        lock.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        lock.centerYAnchor.constraint(equalTo: faixa2.centerYAnchor).isActive = true
        lock.widthAnchor.constraint(equalToConstant: 32).isActive = true
        lock.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        provider2.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        provider2.leftAnchor.constraint(equalTo: provider1.rightAnchor, constant: -20).isActive = true
        provider2.heightAnchor.constraint(equalToConstant: 25).isActive = true
        provider2.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        provider1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        provider1.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        provider1.heightAnchor.constraint(equalToConstant: 25).isActive = true
        provider1.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        black.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        black.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
    }
    
    func createGradientLayer() {
        gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor(red: 236/255, green: 111/255, blue: 102/255, alpha: 1).cgColor, UIColor(red: 243/255, green: 161/255, blue: 131/255, alpha: 1).cgColor]
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
