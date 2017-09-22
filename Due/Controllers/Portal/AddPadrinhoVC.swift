//
//  AddPadrinhoVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class AddPadrinhoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    init(previousPhotoUrl: String, message: String, childID: String) {
        super.init(nibName: nil, bundle: nil)
        prevPic = previousPhotoUrl
        self.message = message
        child = childID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var prevPic: String?
    var message: String?
    var child: String?
    var selectedImage: UIImage?
    
    let backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let photoTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Foto"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let photo: NetworkImageView = {
        let img = NetworkImageView()
        img.clipsToBounds = true
        img.backgroundColor = offwhite
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 16
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let addBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "camera"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let msgTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Mensagem"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let field: UITextView = {
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
        if let previousPhoto = prevPic, let mensagem = message {
            photo.loadImageUsingCacheWithUrlString(previousPhoto)
            field.text = mensagem
        }
        
    }
    
    func setup() {
        
        view.addSubview(backBtn)
        view.addSubview(photoTitle)
        view.addSubview(addBtn)
        view.addSubview(photo)
        view.addSubview(msgTitle)
        view.addSubview(field)
        view.addSubview(updateBtn)
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.3
        photoTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        photoTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        addBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addBtn.centerYAnchor.constraint(equalTo: photoTitle.centerYAnchor, constant: 0).isActive = true
        addBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addBtn.addTarget(self, action: #selector(openPhotosApp), for: .touchUpInside)
        
        photo.topAnchor.constraint(equalTo: photoTitle.bottomAnchor, constant: 15).isActive = true
        photo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        photo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        msgTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        msgTitle.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 20).isActive = true
        
        field.topAnchor.constraint(equalTo: msgTitle.bottomAnchor, constant: 8).isActive = true
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        field.bottomAnchor.constraint(equalTo: updateBtn.topAnchor, constant: -15).isActive = true
        
        let height = view.frame.height * 0.08
        var btnY: CGFloat?
        let size = UIScreen.main.bounds.width
        if size <= 320 {
            btnY = view.frame.height * 0.43
        } else {
            btnY = view.frame.height * 0.4
        }
        updateBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: btnY!).isActive = true
        updateBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        updateBtn.heightAnchor.constraint(equalToConstant: height).isActive = true
        updateBtn.layer.cornerRadius = height / 2
        updateBtn.addTarget(self, action: #selector(updateVersion), for: .touchUpInside)
        
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UPDATING DUE VERSION
    
    @objc func updateVersion() {
        if photo.image != nil && field.text != "" {
            if child != "" {
                // Updating existing padrinho
                if selectedImage != nil {
                    // This means User picked a different picture
                    // Delete previous photo
                    Storage.storage().reference(forURL: prevPic!).delete(completion: { (err) in
                        if err != nil {
                            print(err?.localizedDescription ?? "")
                        }
                        // Store new picture and update DB
                        self.updatePadrinhoPhoto()
                    })
                }
                if field.text != message {
                    // This means User modified the message
                    Database.database().reference().child("Codes").child(details.eventID!).child("padrinhos").child(child!).updateChildValues(["texto": field.text!])
                }
                _ = SweetAlert().showAlert("Muito bem!", subTitle: "Versão atualizada", style: .success, buttonTitle: "Ok") { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                // Creating new padrinho
                createNewPadrinho()
            }
        } else {
            let alert = UIAlertController(title: "Oops...", message: "Não se esqueça de escolher uma foto e escrever uma mensagem!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: PICKING PHOTO
    
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
    
    // MARK: UPDATING PADRINHO PHOTO
    
    func updatePadrinhoPhoto() {
        if let image = selectedImage as UIImage? {
            let imageID = NSUUID().uuidString
            let ref = Storage.storage().reference().child(details.eventID!).child("padrinhosPhotos").child(imageID)
            if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
                ref.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                        Database.database().reference().child("Codes").child(details.eventID!).child("padrinhos").child(self.child!).updateChildValues(["foto": imageUrl])
                    }
                })
            }
        }
    }
    
    // MARK: CREATING A NEW PADRINHO
    
    func createNewPadrinho() {
        if let image = selectedImage as UIImage? {
            let imageID = NSUUID().uuidString
            let ref = Storage.storage().reference().child(details.eventID!).child("padrinhosPhotos").child(imageID)
            if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
                ref.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                        self.updateDB(imageUrl: imageUrl, completion: {
                            self.photo.image = nil
                            self.field.text = ""
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                })
            }
        }
    }
    
    func updateDB(imageUrl: String, completion: () -> Void) {
        let ref = Database.database().reference().child("Codes").child(details.eventID!).child("padrinhos").childByAutoId()
        ref.updateChildValues(["foto": imageUrl, "texto": field.text])
        completion()
    }
    
    // KEYBOARD METHODS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
