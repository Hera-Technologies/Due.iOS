//
//  EditCoupleVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class EditCoupleVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    init(child: String, photo: String, name: String) {
        super.init(nibName: nil, bundle: nil)
        self.child = child
        self.previousPhoto = photo
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let indicator = UIActivityIndicatorView()
    var child: String?
    var name: String?
    var previousPhoto: String?
    var selectedImage: UIImage?
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 25)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let photo: NetworkImageView = {
        let img = NetworkImageView()
        img.clipsToBounds = true
        img.backgroundColor = offwhite
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let addBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "camera"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let field: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Nome"
        txt.textAlignment = .center
        txt.font = UIFont(name: "Avenir-Roman", size: 20)
        txt.textColor = darker
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let line: UIView = {
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
        btn.backgroundColor = darker
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        if let prevPic = previousPhoto, let nome = name {
            photo.loadImageUsingCacheWithUrlString(prevPic)
            field.text = nome
            viewTitle.text = child
        }
        
    }
    
    func setup() {
        
        view.addSubview(closeBtn)
        view.addSubview(viewTitle)
        view.addSubview(addBtn)
        view.addSubview(photo)
        view.addSubview(field)
        view.addSubview(line)
        view.addSubview(updateBtn)
        
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 30).isActive = true
        
        let btnY = view.frame.height * 0.26
        addBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -btnY).isActive = true
        addBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addBtn.addTarget(self, action: #selector(openPhotosApp), for: .touchUpInside)
        
        let size = view.frame.width * 0.4
        photo.topAnchor.constraint(equalTo: addBtn.bottomAnchor, constant: 4).isActive = true
        photo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photo.widthAnchor.constraint(equalToConstant: size).isActive = true
        photo.heightAnchor.constraint(equalToConstant: size).isActive = true
        photo.layer.cornerRadius = size / 2
        
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        field.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 30).isActive = true
        field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        field.delegate = self
        
        line.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 3).isActive = true
        line.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let updateBtnY = view.frame.height * 0.35
        let height = view.frame.height * 0.08
        updateBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: updateBtnY).isActive = true
        updateBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        updateBtn.heightAnchor.constraint(equalToConstant: height).isActive = true
        updateBtn.layer.cornerRadius = height / 2
        updateBtn.addTarget(self, action: #selector(updateVersion), for: .touchUpInside)
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: EDIT PHOTO
    
    @objc func openPhotosApp() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImage = editedImage as? UIImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImage = originalImage as? UIImage
        }
        if let theImage = selectedImage as UIImage? {
            photo.image = theImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UPDATE DUE VERSION
    
    @objc func updateVersion() {
        if photo.image != nil && field.text != "" {
            showActivityIndicator(view: self.view, indicator: indicator)
            updateName(name: field.text!)
            updatePhoto(image: photo.image!, childName: child!)
        } else {
            let alert = UIAlertController(title: "Oops...", message: "Não se esqueça de escolher uma foto e escrever seu nome!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: UPDATE PHOTO
    
    func updatePhoto(image: UIImage, childName: String) {
        let lowercaseChild = childName.lowercased()
        let ref = Storage.storage().reference().child(details.eventID!).child("casalPhotos").child(lowercaseChild)
        if let data = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(data, metadata: nil, completion: { (metadata, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "")
                    return
                }
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    Database.database().reference().child("Codes").child(details.eventID!).child("story").child(lowercaseChild).updateChildValues(["foto": imageUrl])
                    dismissActivityIndicator(view: self.view, indicator: self.indicator, completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    // MARK: UPDATE NAME
    
    func updateName(name: String) {
        if let lowercaseChild = child?.lowercased() {
            Database.database().reference().child("Codes").child(details.eventID!).child("story").child(lowercaseChild).updateChildValues(["nome": name])
        }
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
