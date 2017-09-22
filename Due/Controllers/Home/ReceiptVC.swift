//
//  ReceiptVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class ReceiptVC: UIViewController {
    
    let congrats: UILabel = {
        let lbl = UILabel()
        lbl.text = "Tudo ok!"
        lbl.textColor  = .black
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Light", size: 35)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let check: UIImageView = {
        let vi = UIImageView()
        vi.image = UIImage(named: "check")
        vi.backgroundColor = .clear
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let message: UITextView = {
        let txt = UITextView()
        txt.text = "Muito obrigado! Seu pedido está sendo processado e o recibo será enviado por email."
        txt.textColor = .darkGray
        txt.backgroundColor = .clear
        txt.font = UIFont(name: "Avenir-Light", size: 14)
        txt.textAlignment = .justified
        txt.isEditable = false
        txt.isSelectable = false
        txt.isScrollEnabled = false
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let summary: UILabel = {
        let lbl = UILabel()
        lbl.text = "Resumo"
        lbl.textColor  = .gray
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Light", size: 20)
        lbl.layer.borderColor = UIColor.lightGray.cgColor
        lbl.layer.borderWidth = 0.6
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let scrollView: UIScrollView = {
        let vi = UIScrollView()
        vi.showsVerticalScrollIndicator = false
        vi.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 252/255, alpha: 1)
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let titles: UITextView = {
        let txt = UITextView()
        txt.text = """
        ▫️Produto:
        
        ▫️Duração:
        
        ▫️Valor:
        
        ▫️Email:
        """
        txt.textColor = .darkGray
        txt.backgroundColor = .clear
        txt.font = UIFont(name: "Avenir-Light", size: 14)
        txt.textAlignment = .left
        txt.isEditable = false
        txt.isSelectable = false
        txt.isScrollEnabled = false
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let detailsTxt: UITextView = {
        let txt = UITextView()
        txt.textColor = .black
        txt.backgroundColor = .clear
        txt.font = UIFont(name: "Avenir-Roman", size: 14)
        txt.textAlignment = .right
        txt.isEditable = false
        txt.isSelectable = false
        txt.isScrollEnabled = false
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Voltar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.black, for: UIControlState())
        btn.backgroundColor = .white
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        btn.layer.shadowRadius = 1.8
        btn.layer.shadowOpacity = 0.45
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 252/255, alpha: 1)
        setup()
        
    }
    
    func setup() {
        
        view.addSubview(congrats)
        view.addSubview(check)
        view.addSubview(message)
        view.addSubview(summary)
        view.addSubview(scrollView)
        view.addSubview(backBtn)
        
        let lblY = view.frame.size.height * 0.35
        congrats.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        congrats.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -lblY).isActive = true
        
        let w = view.frame.width * 0.25
        let h = view.frame.width * 0.23
        check.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        check.topAnchor.constraint(equalTo: congrats.bottomAnchor, constant: 25).isActive = true
        check.widthAnchor.constraint(equalToConstant: w).isActive = true
        check.heightAnchor.constraint(equalToConstant: h).isActive = true
        
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        message.topAnchor.constraint(equalTo: check.bottomAnchor, constant: 20).isActive = true
        message.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        summary.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        summary.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 12).isActive = true
        summary.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        summary.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let hgt = view.frame.height * 0.075
        backBtn.trailingAnchor.constraint(equalTo: message.trailingAnchor, constant: 0).isActive = true
        backBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        backBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: hgt).isActive = true
        backBtn.layer.cornerRadius = hgt / 2
        backBtn.addTarget(self, action: #selector(moveFoward), for: .touchUpInside)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        scrollView.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: 10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: backBtn.topAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(titles)
        scrollView.addSubview(detailsTxt)
        
        titles.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        titles.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        titles.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        titles.widthAnchor.constraint(equalToConstant: 115).isActive = true
        
        detailsTxt.trailingAnchor.constraint(equalTo: summary.trailingAnchor).isActive = true
        detailsTxt.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        detailsTxt.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        detailsTxt.widthAnchor.constraint(equalToConstant: 200).isActive = true
        detailsTxt.text = """
        Versão Due
        
        3 meses
        
        R$9,99
        
        \(details.email ?? "")
        """
        
    }
    
    @objc func moveFoward() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}


