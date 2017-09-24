//
//  FourthVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class FourthVC: UIViewController {
    
    let gradient: CAGradientLayer = {
        let grad = CAGradientLayer()
        grad.colors = bourbon
        return grad
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Presentes"
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Black", size: 28)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let leftIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "truck")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let middleIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "gift")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let rightIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "plane")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Seu presente é uma ordem"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 22)
        lbl.textColor = dark
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let message: UILabel = {
        let lbl = UILabel()
        lbl.text = "Esta é a oportunidade para familiares e amigos presentearem os recém casados, contribuindo para a nova jornada que os espera."
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 15)
        lbl.textColor = .gray
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let contributeBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Presentear", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: .normal)
        btn.clipsToBounds = true
        btn.layer.masksToBounds = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        gradient.frame = contributeBtn.frame
        gradient.cornerRadius = contributeBtn.layer.cornerRadius
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setup() {
        
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(leftIcon)
        view.addSubview(middleIcon)
        view.addSubview(rightIcon)
        view.addSubview(label)
        view.addSubview(message)
        view.addSubview(contributeBtn)
        
        let titleY = view.frame.height * 0.38
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        let iconY = view.frame.height * 0.2
        middleIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        middleIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -iconY).isActive = true
        middleIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        middleIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        
        leftIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        leftIcon.bottomAnchor.constraint(equalTo: middleIcon.bottomAnchor, constant: 20).isActive = true
        leftIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.22).isActive = true
        leftIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.22).isActive = true
        
        rightIcon.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        rightIcon.bottomAnchor.constraint(equalTo: middleIcon.bottomAnchor, constant: 20).isActive = true
        rightIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.22).isActive = true
        rightIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.22).isActive = true
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: middleIcon.bottomAnchor, constant: 30).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        message.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        message.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        var btnY: CGFloat?
        let size = UIScreen.main.bounds.width
        if size <= 320  {
            btnY = view.frame.height * 0.75
        } else {
            btnY = view.frame.height * 0.65
        }
        let hgt = view.frame.height * 0.08
        contributeBtn.frame.size = CGSize(width: view.frame.width / 2, height: hgt)
        contributeBtn.frame.origin = CGPoint(x: view.frame.width * 0.25, y: btnY!)
        contributeBtn.layer.cornerRadius = hgt / 2
        contributeBtn.addTarget(self, action: #selector(contribute), for: .touchUpInside)
        
    }
    
    @objc func contribute() {
        self.navigationController?.pushViewController(ChargeVC(), animated: true)
    }
    
}
