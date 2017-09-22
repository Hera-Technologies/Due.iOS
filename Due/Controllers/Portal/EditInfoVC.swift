//
//  EditInfoVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class EditInfoVC: UIViewController, UITextFieldDelegate {
    
    init(titulo: String, message: String, childID: String) {
        super.init(nibName: nil, bundle: nil)
        self.titulo = titulo
        self.message = message
        self.childID = childID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var message: String?
    var titulo: String?
    var childID: String?
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let topicTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Tópico"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let topicField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Ex.: Cerimônia & Recepção"
        txt.textColor = darker
        txt.textAlignment = .left
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let topicLine: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let infoTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Conteúdo"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let infoField: UITextView = {
        let txt = UITextView()
        txt.textAlignment = .justified
        txt.font = UIFont(name: "Avenir-Roman", size: 16)
        txt.textColor = darker
        txt.layer.borderColor = linewhite.cgColor
        txt.layer.borderWidth = 0.8
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let updateBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Enviar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = darker
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        if let msg = message, let tlt = titulo {
            topicField.text = tlt
            infoField.text = msg
        }
    }
    
    func setup() {
        
        view.addSubview(closeBtn)
        view.addSubview(topicTitle)
        view.addSubview(topicField)
        view.addSubview(topicLine)
        view.addSubview(infoTitle)
        view.addSubview(infoField)
        view.addSubview(updateBtn)
        
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        topicTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        topicTitle.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 30).isActive = true
        
        topicField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topicField.topAnchor.constraint(equalTo: topicTitle.bottomAnchor, constant: 20).isActive = true
        topicField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        topicField.delegate = self
        
        topicLine.topAnchor.constraint(equalTo: topicField.bottomAnchor, constant: 2).isActive = true
        topicLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topicLine.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        topicLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        infoTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        infoTitle.topAnchor.constraint(equalTo: topicLine.bottomAnchor, constant: 30).isActive = true
        
        infoField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        infoField.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: 15).isActive = true
        infoField.bottomAnchor.constraint(equalTo: updateBtn.topAnchor, constant: -15).isActive = true
        
        let height = view.frame.height * 0.08
        var btnY: CGFloat?
        let size = UIScreen.main.bounds.width
        if size >= 414 {
            btnY = view.frame.height * 0.35
        } else if size < 414 && size > 320 {
            btnY = view.frame.height * 0.4
        } else if size <= 320 {
            btnY = view.frame.height * 0.43
        }
        updateBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: btnY!).isActive = true
        updateBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        updateBtn.heightAnchor.constraint(equalToConstant: height).isActive = true
        updateBtn.layer.cornerRadius = height / 2
        updateBtn.addTarget(self, action: #selector(updateVersion), for: .touchUpInside)
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateVersion() {
        if topicField.text != "" && infoField.text != "" {
            if childID != "" {
                updateOldInfo()
            } else {
                createNewInfo()
            }
        }
    }
    
    func updateOldInfo() {
        if let child = childID {
            Database.database().reference().child("Codes").child(details.eventID!).child("evento").child("info").child(child).updateChildValues(["title": topicField.text!, "message": infoField.text!])
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func createNewInfo() {
        let ref = Database.database().reference().child("Codes").child(details.eventID!).child("evento").child("info").childByAutoId()
        ref.updateChildValues(["title": topicField.text!, "message": infoField.text!])
        dismiss(animated: true, completion: nil)
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
