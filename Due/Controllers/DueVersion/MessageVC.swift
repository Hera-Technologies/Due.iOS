//
//  MessageVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class MessageVC: UIViewController {
    
    // MARK: ELEMENTS
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let sendBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Enviar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(dark, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Deixe sua mensagem"
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
    
    let field: UITextView = {
        let txt = UITextView()
        txt.textColor = .darkGray
        txt.font = UIFont(name: "Avenir-Roman", size: 16)
        txt.textAlignment = .justified
        txt.backgroundColor = .clear
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    func setup() {
        
        
        view.addSubview(closeBtn)
        view.addSubview(sendBtn)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(field)
        
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        sendBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        sendBtn.centerYAnchor.constraint(equalTo: closeBtn.centerYAnchor, constant: 6).isActive = true
        sendBtn.addTarget(self, action: #selector(send), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.35
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        field.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 12).isActive = true
        field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        field.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        field.becomeFirstResponder()
    }
    
    @objc func close() {
        field.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func send() {
        if field.text != "" {
            field.resignFirstResponder()
            sendMessageToFirebase()
        } else {
            let alert = UIAlertController(title: "Oops...", message: "Por favor, escreva uma mensagem", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func sendMessageToFirebase() {
        let ref = Database.database().reference().child("Codes").child(eventModel.eventCode!).child("mensagens").childByAutoId()
        ref.updateChildValues([
            "message": field.text,
            "email": details.email as Any,
            "name": details.name as Any,
            "photo": details.profilePhoto as Any,
            "timestamp": ServerValue.timestamp()
            ])
        _ = SweetAlert().showAlert("Mensagem enviada!", subTitle: "Muito obrigado por nos deixar uma mensagem!", style: .success, buttonTitle: "Ok") { (action) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: KEYBOARD METHOD
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
