//
//  PhotoVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class PhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage: UIImage?
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let sendBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Enviar", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(dark, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Envie uma foto"
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
    
    let libBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "gallery"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let camBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let photo: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 16
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let hintImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "image")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let hintMessage: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sua foto aparecerá aqui. Compartilhe quantas fotos quiser ; )"
        lbl.textColor  = .lightGray
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Roman", size: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let captionTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Legenda"
        lbl.textColor  = dark
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let field: UITextView = {
        let txt = UITextView()
        txt.textColor = darker
        txt.font = UIFont(name: "Avenir-Roman", size: 16)
        txt.textAlignment = .justified
        txt.backgroundColor = .clear
        txt.layer.borderColor = linewhite.cgColor
        txt.layer.borderWidth = 0.8
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
        view.addSubview(libBtn)
        view.addSubview(camBtn)
        view.addSubview(photo)
        view.addSubview(hintImg)
        view.addSubview(hintMessage)
        view.addSubview(captionTitle)
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
        
        camBtn.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 15).isActive = true
        camBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        camBtn.heightAnchor.constraint(equalToConstant: 38).isActive = true
        camBtn.widthAnchor.constraint(equalToConstant: 38).isActive = true
        camBtn.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        
        libBtn.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 15).isActive = true
        libBtn.rightAnchor.constraint(equalTo: camBtn.leftAnchor, constant: -20).isActive = true
        libBtn.heightAnchor.constraint(equalToConstant: 38).isActive = true
        libBtn.widthAnchor.constraint(equalToConstant: 38).isActive = true
        libBtn.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        
        let photoY = view.frame.height * 0.05
        photo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -photoY).isActive = true
        photo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        photo.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55).isActive = true
        
        hintImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintImg.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -photoY).isActive = true
        hintImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        hintImg.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        hintMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintMessage.topAnchor.constraint(equalTo: hintImg.bottomAnchor, constant: 4).isActive = true
        hintMessage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        captionTitle.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 25).isActive = true
        captionTitle.leadingAnchor.constraint(equalTo: photo.leadingAnchor).isActive = true
        
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        field.topAnchor.constraint(equalTo: captionTitle.bottomAnchor, constant: 6).isActive = true
        field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        field.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.22).isActive = true
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: FIREBASE METHODS
    
    @objc func send() {
        if photo.image != nil {
            storePhoto()
        } else {
            let alert = UIAlertController(title: "Oops...", message: "Por favor, selecione uma foto", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func storePhoto() {
        if let image = selectedImage as UIImage? {
            let imageID = NSUUID().uuidString
            let ref = Storage.storage().reference().child(eventModel.eventCode!).child("feedPhotos").child(imageID)
            if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
                ref.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                    if err != nil {
                        print(err!)
                        return
                    }
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {
                        self.sendPhotoToDB(imageUrl: imageUrl)
                    }
                })
            }
        }
    }
    
    func sendPhotoToDB(imageUrl: String) {
        let ref = Database.database().reference().child("Codes").child(eventModel.eventCode!).child("fotos").childByAutoId()
        ref.updateChildValues([
            "imageUrl": imageUrl,
            "caption": field.text,
            "email": details.email as Any,
            "name": details.name as Any,
            "profilePhoto": details.profilePhoto as Any,
            "timestamp": ServerValue.timestamp()
            ])
        _ = SweetAlert().showAlert("Bela foto!", subTitle: "Muito obrigado por compartilhar seu momento conosco!", style: .success, buttonTitle: "Ok") { (action) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: PICKER VIEW CONTROLLER METHODS
    
    @objc func openGallery() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @objc func openCamera() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraFlashMode = .auto
        picker.allowsEditing = true
        picker.showsCameraControls = true
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
            hintImg.isHidden = true
            hintMessage.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: KEYBOARD METHODS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
