//
//  EventNameVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class EventNameVC: UIViewController, UITextFieldDelegate {
    
    var aux = 0
    
    let titulo: UILabel = {
        let lbl = UILabel()
        lbl.text = "Como vai chamar o seu evento?"
        lbl.textColor  = darker
        lbl.textAlignment = .justified
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont(name: "Avenir-Roman", size: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let field: UITextField = {
        let txt = UITextField()
        txt.textAlignment = .center
        txt.placeholder = "Ex: Ela+Ele=S2"
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.textColor = darker
        txt.returnKeyType = .done
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let confirm: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Confirmar", for: UIControlState())
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = darker
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let message: UILabel = {
        let lbl = UILabel()
        lbl.text = "Repasse este nome aos seus convidados para que possam acessar sua versão quando ela estiver online."
        lbl.textColor  = .gray
        lbl.textAlignment = .justified
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Roman", size: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        confirm.addTarget(self, action: #selector(setName), for: .touchUpInside)
        field.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @objc func setName() {
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
    
    // Check if user input is equal to the eventName child value in every child in Codes
    
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
                self.createEvent()
            }
        })
    }
    
    func createEvent() {
        
        details.nameSet = true
        newEventName = field.text!
        
        let user = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        // Create new event
        let eventID = ref.child("Codes").childByAutoId()
        eventID.updateChildValues(["user": user!, "eventName": field.text!])
        
        // Add eventName to user's node
        let value: [String : Any] = ["eventName": field.text!, "eventID": eventID.key, "nameSet": true]
        ref.child("Users").child(user!).updateChildValues(value)
        
        details.eventID = eventID.key
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "displayEventName"), object: nil)
        dismiss(animated: true, completion: nil)
        
    }
    
    func setup() {
        
        view.addSubview(titulo)
        view.addSubview(field)
        view.addSubview(line)
        view.addSubview(confirm)
        view.addSubview(message)
        
        let qstY = view.frame.height * 0.16
        titulo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titulo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -qstY).isActive = true
        titulo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        field.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20).isActive = true
        field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        line.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 3).isActive = true
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let height = view.frame.height * 0.075
        confirm.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirm.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 25).isActive = true
        confirm.heightAnchor.constraint(equalToConstant: height).isActive = true
        confirm.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55).isActive = true
        confirm.layer.cornerRadius = height / 2
        
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        message.topAnchor.constraint(equalTo: confirm.bottomAnchor, constant: 18).isActive = true
        message.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
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
