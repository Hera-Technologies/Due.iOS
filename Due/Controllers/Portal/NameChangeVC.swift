//
//  NameChangeVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

var newEventName: String?

class NameChangeVC: UIViewController, UITextFieldDelegate {
    
    var aux = 0
    
    let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Como vai se chamar seu evento a partir de agora?"
        lbl.textColor = darker
        lbl.textAlignment = .justified
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont(name: "Avenir-Roman", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let field: UITextField = {
        let txt = UITextField()
        txt.textAlignment = .center
        txt.placeholder = "Novo nome"
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = darker
        txt.returnKeyType = .done
        return txt
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let confirm: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Alterar", for: UIControlState())
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        btn.setTitleColor(darker, for: UIControlState())
        btn.backgroundColor = .clear
        btn.layer.borderColor = linewhite.cgColor
        btn.layer.borderWidth = 0.5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let cancel: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancelar", for: UIControlState())
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        btn.setTitleColor(UIColor(red: 224/255, green: 103/255, blue: 125/255, alpha: 1), for: UIControlState())
        btn.backgroundColor = .clear
        btn.layer.borderColor = linewhite.cgColor
        btn.layer.borderWidth = 0.5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        field.delegate = self
        cancel.addTarget(self, action: #selector(cancelChange), for: .touchUpInside)
        confirm.addTarget(self, action: #selector(changeName), for: .touchUpInside)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    // Check for empty field
    
    @objc func changeName() {
        if field.text != "" {
            checkNames()
            checkAux()
        } else {
            let alert = UIAlertController(title: "Oops...", message: "Por favor, escolha um nome para o seu evento", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Check if name is avaiable
    
    func checkNames() {
        aux = 0
        Database.database().reference().child("Codes").observe(.childAdded, with: { (snap) in
            guard let data = snap.value as? [String: AnyObject] else { return }
            let name = data["eventName"] as? String
            if self.field.text! == name {
                self.aux = 1
            }
        })
    }
    
    func checkAux() {
        Database.database().reference().observeSingleEvent(of: .value, with: { (snap) in
            if self.aux == 1 {
                self.view.endEditing(true)
                _ = SweetAlert().showAlert("Oops...", subTitle: "Já existe uma versão Due com este nome", style: .error, buttonTitle: "Ok")
            } else {
                newEventName = self.field.text
                self.changeEventNameInUserNode(completion: { (success) in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayEventName"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        })
    }
    
    // Change eventName in user's node
    
    func changeEventNameInUserNode(completion: @escaping (_ success: Bool) -> Void) {
        let newName = String(describing: self.field.text!)
        let user = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(user!).updateChildValues(["eventName": newName]) { (err, _) in
            if err != nil {
                print("something happened")
                return
            } else {
                completion(true)
            }
        }
    }
    
    @objc func cancelChange() {
        dismiss(animated: true, completion: nil)
    }
    
    func setup() {
        
        view.addSubview(titulo)
        view.addSubview(field)
        view.addSubview(line)
        view.addSubview(confirm)
        view.addSubview(cancel)
        
        confirm.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        confirm.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        confirm.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        confirm.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        cancel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        cancel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cancel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        field.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        line.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 3).isActive = true
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        titulo.bottomAnchor.constraint(equalTo: field.topAnchor, constant: -30).isActive = true
        titulo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titulo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
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
