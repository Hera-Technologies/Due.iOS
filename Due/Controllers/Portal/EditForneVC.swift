//
//  EditForneVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/25/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class EditForneVC: UIViewController, UITextFieldDelegate {
    
    init(categoria: String, fornecedor: String, childID: String) {
        super.init(nibName: nil, bundle: nil)
        self.categoria = categoria
        self.fornecedor = fornecedor
        self.childID = childID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var fornecedor: String?
    var categoria: String?
    var childID: String?
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(.black, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let leftIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "dj")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let middleIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "chef")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let rightIcon: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "waiter")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let categoryTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Categoria"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let categoryField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Ex.: buffet, som, decoração..."
        txt.textColor = .black
        txt.textAlignment = .left
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let categoryLine: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let forneTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Fornecedor"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let forneField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Nome do fornecedor"
        txt.textColor = .black
        txt.textAlignment = .left
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let forneLine: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let updateBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Enviar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
        if let cat = categoria, let forne = fornecedor {
            categoryField.text = cat
            forneField.text = forne
        }
    }
    
    func setup() {
        
        view.addSubview(closeBtn)
        view.addSubview(leftIcon)
        view.addSubview(middleIcon)
        view.addSubview(rightIcon)
        view.addSubview(categoryTitle)
        view.addSubview(categoryField)
        view.addSubview(categoryLine)
        view.addSubview(forneTitle)
        view.addSubview(forneField)
        view.addSubview(forneLine)
        view.addSubview(updateBtn)
        
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        let iconY = view.frame.height * 0.25
        
        leftIcon.rightAnchor.constraint(equalTo: middleIcon.leftAnchor, constant: -25).isActive = true
        leftIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -iconY).isActive = true
        leftIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        leftIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        middleIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        middleIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -iconY).isActive = true
        middleIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        middleIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        rightIcon.leftAnchor.constraint(equalTo: middleIcon.rightAnchor, constant: 25).isActive = true
        rightIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -iconY).isActive = true
        rightIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        rightIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        categoryTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        categoryTitle.bottomAnchor.constraint(equalTo: categoryField.topAnchor, constant: -20).isActive = true
        
        categoryField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        categoryField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        categoryField.delegate = self
        
        categoryLine.topAnchor.constraint(equalTo: categoryField.bottomAnchor, constant: 2).isActive = true
        categoryLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryLine.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        categoryLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        forneTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        forneTitle.topAnchor.constraint(equalTo: categoryLine.bottomAnchor, constant: 25).isActive = true
        
        forneField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forneField.topAnchor.constraint(equalTo: forneTitle.bottomAnchor, constant: 20).isActive = true
        forneField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        forneField.delegate = self
        
        forneLine.topAnchor.constraint(equalTo: forneField.bottomAnchor, constant: 2).isActive = true
        forneLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forneLine.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        forneLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
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
        if categoryField.text != "" && forneField.text != "" {
            if childID != "" {
                updateOldForne()
            } else {
                createNewForne()
            }
        }
    }
    
    func updateOldForne() {
        if let child = childID {
            Database.database().reference().child("Codes").child(details.eventID!).child("evento").child("fornecedores").child(child).updateChildValues(["categoria": categoryField.text!, "fornecedor": forneField.text!])
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func createNewForne() {
        let ref = Database.database().reference().child("Codes").child(details.eventID!).child("evento").child("fornecedores").childByAutoId()
        ref.updateChildValues(["categoria": categoryField.text!, "fornecedor": forneField.text!])
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
