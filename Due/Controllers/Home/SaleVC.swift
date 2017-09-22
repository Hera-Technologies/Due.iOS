//
//  SaleVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class SaleVC: UIViewController {
    
    let container: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "launch")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let logo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "gradicon")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Lançamento"
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 25)
        lbl.layer.borderWidth = 1
        lbl.layer.borderColor = UIColor.white.cgColor
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let icon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "sale")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let message: UILabel = {
        let lbl = UILabel()
        lbl.text = "Como forma de comemorar o lançamento do Due, as primeiras versões serão gratuitas!"
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let continueBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Continuar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let arrowIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "whitearrow")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    func setup() {
        
        view.addSubview(logo)
        view.addSubview(container)
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(icon)
        view.addSubview(message)
        view.addSubview(continueBtn)
        view.addSubview(arrowIcon)
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 1).isActive = true
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: -2).isActive = true
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        viewTitle.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 1.05).isActive = true
        viewTitle.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        
        let iconY = view.frame.height * 0.12
        icon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -iconY).isActive = true
        icon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        icon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        icon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        message.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 30).isActive = true
        message.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        
        var btnY = CGFloat()
        var btnX = CGFloat()
        let size = UIScreen.main.bounds.width
        if size <= 320 {
            btnY = view.frame.height * 0.25
            btnX = view.frame.width * 0.1
        } else {
            btnY = view.frame.height * 0.2
            btnX = view.frame.width * 0.15
        }
        continueBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: btnX).isActive = true
        continueBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: btnY).isActive = true
        continueBtn.addTarget(self, action: #selector(continuar), for: .touchUpInside)
        
        arrowIcon.centerYAnchor.constraint(equalTo: continueBtn.centerYAnchor).isActive = true
        arrowIcon.leftAnchor.constraint(equalTo: continueBtn.rightAnchor, constant: 10).isActive = true
        
    }
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func continuar() {
        navigationController?.pushViewController(PriceVC(), animated: true)
    }
    
}



