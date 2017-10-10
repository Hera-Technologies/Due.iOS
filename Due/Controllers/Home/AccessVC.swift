//
//  AccessVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class AccessVC: UIViewController, UITextFieldDelegate {
    
    var aux = 0
    var code = ""
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Qual o nome do evento?"
        lbl.textColor  = darker
        lbl.textAlignment = .justified
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont(name: "Avenir-Roman", size: 22)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.4
        return lbl
    }()
    
    let field: CustomTF = {
        let txt = CustomTF()
        txt.textAlignment = .left
        txt.placeholder = "Ex.: thaielu"
        txt.font = UIFont(name: "Avenir-Book", size: 18)
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.backgroundColor = .clear
        txt.textColor = dark
        txt.returnKeyType = .done
        return txt
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let accessBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Acessar", for: .normal)
        btn.setTitleColor(.white, for: UIControlState())
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        btn.backgroundColor = darker
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let sampleBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Versão demonstrativa", for: .normal)
        btn.setTitleColor(dark, for: UIControlState())
        btn.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 16)
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        field.delegate = self
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        accessBtn.addTarget(self, action: #selector(acessarEvento), for: .touchUpInside)
        sampleBtn.addTarget(self, action: #selector(amostra), for: .touchUpInside)
        view.backgroundColor = .white
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UI VIEWS SETUP
    
    func setup() {
        
        view.addSubview(closeBtn)
        view.addSubview(viewTitle)
        view.addSubview(field)
        view.addSubview(line)
        view.addSubview(accessBtn)
        view.addSubview(sampleBtn)
        
        closeBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        field.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        
        viewTitle.frame = CGRect(x: 20, y: self.view.frame.height * 0.1, width: self.view.frame.width * 0.65, height: 50)
        
        line.topAnchor.constraint(equalTo: field.bottomAnchor, constant: -8).isActive = true
        line.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let btnY = view.frame.height * 0.12
        let height = view.frame.height * 0.07
        accessBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accessBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: btnY).isActive = true
        accessBtn.heightAnchor.constraint(equalToConstant: height).isActive = true
        accessBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45).isActive = true
        accessBtn.layer.cornerRadius = height / 2
        
        sampleBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sampleBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        
    }
    
    // MARK: VERIFY EVENT
    
    @objc func acessarEvento() {
        if field.text != "" {
            filterEvents()
            checkAux()
        } else {
            showAlert(title: "Oops...", message: "Por favor, digite o nome da versão Due que deseja acessar")
        }
    }
    
    func filterEvents() {
        aux = 0
        code = ""
        Database.database().reference().child("Codes").observe(.childAdded, with: { (snap) in
            guard let data = snap.value as? [String: AnyObject] else { return }
            let name = data["eventName"] as? String
            if self.field.text! == name {
                self.aux = 1
                self.code = snap.key
            }
        })
    }
    
    func checkAux() {
        Database.database().reference().child("Codes").observeSingleEvent(of: .value, with: { (snapshot) in
            if self.aux == 1 {
                self.checkIfVersionIsOnline()
            } else {
                self.showAlert(title: "Oops...", message: "Não há uma versão Due correspondente a este nome")
            }
        })
    }
    
    func checkIfVersionIsOnline() {
        Database.database().reference().child("Codes").child(code).observe(.value, with: { (event) in
            if event.hasChild("dateEnd") {
                eventModel.eventCode = self.code
                guard let data = event.value as? [String: AnyObject] else { return }
                if let acc = data["stripeAccount"] as? String {
                    eventModel.stripeAcc = acc
                }
                self.present(LoadingVC(), animated: true, completion: nil)
            } else {
                self.showAlert(title: "Hmm...", message: "Esta versão Due ainda não está online")
            }
        })
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func amostra() {
        eventModel.eventCode = "-Kw1Pb89rM1ZZaO7cxNs"
        present(LoadingVC(), animated: true, completion: nil)
    }
    
    // MARK: KEYBOARD METHODS
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


