//
//  PriceVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class PriceVC: UIViewController {

    let gradient: CAGradientLayer = {
        let grad = CAGradientLayer()
        grad.colors = bourbon
        return grad
    }()
    
    let container: UIView = {
        let vi = UIView()
        vi.backgroundColor = .white
        vi.layer.shadowColor = UIColor.darkGray.cgColor
        vi.layer.shadowOffset = CGSize(width: 0, height: 1.7)
        vi.layer.shadowRadius = 2.5
        vi.layer.shadowOpacity = 0.45
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let logo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "gradicon")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let back: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Versão Due"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 25)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let mensagem: UILabel = {
        let lbl = UILabel()
        lbl.text = "3 meses de duração"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 15)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 10
        return lbl
    }()
    
    let moeda: UILabel = {
        let lbl = UILabel()
        lbl.text = "R$"
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Light", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let valor: UILabel = {
        let lbl = UILabel()
        lbl.text = "0"
        lbl.textColor = darker
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 60)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let cents: UILabel = {
        let lbl = UILabel()
        lbl.text = ", 00"
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Light", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let secLine: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let featuresTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Funcionalidades disponíveis:"
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 15)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = darker
        lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl.numberOfLines = 10
        return lbl
    }()
    
    let features: UITextView = {
        let txt = UITextView()
        txt.text = """
        ▫️ Presentes virtuais
        
        ▫️ Contagem regressiva
        
        ▫️ Video
        
        ▫️ Música de fundo
        
        ▫️ Album de fotos
        
        ▫️ Tela dedicada aos padrinhos
        
        ▫️ Feeds de fotos e mensagens
        
        ▫️ Informações sobre o evento
        """
        txt.backgroundColor = .clear
        txt.textColor = .darkGray
        txt.isEditable = false
        txt.isSelectable = false
        txt.font = UIFont(name: "Avenir-Light", size: 14)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let buy: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Obter versão", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        view.backgroundColor = .white
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        buy.addTarget(self, action: #selector(checkout), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createGradientLayer()
    }
    
    func createGradientLayer() {
        gradient.frame.origin = CGPoint(x: 40, y: view.frame.height * 0.19)
        gradient.frame.size.width = view.frame.width * 0.85
        let size = UIScreen.main.bounds.width
        if size >= 414 {
            gradient.frame.size.height = view.frame.size.height * 0.75
        } else if size < 414 && size > 320 {
            gradient.frame.size.height = view.frame.size.height * 0.77
        } else if size <= 320 {
            gradient.frame.size.height = view.frame.size.height * 0.8
        }
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setup() {
        
        view.insertSubview(container, at: 1)
        view.insertSubview(logo, at: 1)
        view.insertSubview(back, at: 1)
        view.addSubview(buy)
        
        back.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        back.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: -4).isActive = true
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        buy.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
        buy.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 1).isActive = true
        
        container.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75).isActive = true
        container.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        container.addSubview(titulo)
        container.addSubview(line)
        container.addSubview(mensagem)
        container.addSubview(moeda)
        container.addSubview(valor)
        container.addSubview(cents)
        container.addSubview(secLine)
        container.addSubview(featuresTitle)
        container.addSubview(features)
        
        titulo.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        titulo.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        line.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        line.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 5).isActive = true
        line.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.85).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        mensagem.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        mensagem.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        mensagem.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.85).isActive = true
        
        valor.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        valor.topAnchor.constraint(equalTo: mensagem.bottomAnchor, constant: 12).isActive = true
        moeda.rightAnchor.constraint(equalTo: valor.leftAnchor, constant: -8).isActive = true
        moeda.centerYAnchor.constraint(equalTo: valor.centerYAnchor).isActive = true
        cents.leftAnchor.constraint(equalTo: valor.rightAnchor, constant: 4).isActive = true
        cents.centerYAnchor.constraint(equalTo: valor.centerYAnchor).isActive = true
        
        secLine.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        secLine.topAnchor.constraint(equalTo: valor.bottomAnchor, constant: 3).isActive = true
        secLine.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.85).isActive = true
        secLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        featuresTitle.leadingAnchor.constraint(equalTo: secLine.leadingAnchor).isActive = true
        featuresTitle.topAnchor.constraint(equalTo: secLine.bottomAnchor, constant: 12).isActive = true
        
        features.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        features.topAnchor.constraint(equalTo: featuresTitle.bottomAnchor, constant: 3).isActive = true
        features.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9).isActive = true
        features.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
        
    }
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func checkout() {
        if let user = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("Users").child(user)
            let value = ["hasDue": true, "nameSet": false]
            ref.updateChildValues(value)
            details.hasDue = true
            _ = SweetAlert().showAlert("Parabéns!", subTitle: "Você agora possui uma versão Due! Para editá-la, acesse o Portal.", style: .success, buttonTitle: "Ok", action: { (_) in
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: true)
            })
        }
        //        let checkout = CheckoutVC()
        //        navigationController?.pushViewController(checkout, animated: true)
    }

}
