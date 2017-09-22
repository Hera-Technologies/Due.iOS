//
//  AddPhotoVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class AddPhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let indicator = UIActivityIndicatorView()
    var selectedImage: UIImage?
    var heightAnchor: NSLayoutConstraint?
    var bottomAnchor: NSLayoutConstraint?
    
    let closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        btn.layer.shadowRadius = 1.8
        btn.layer.shadowOpacity = 0.45
        btn.layer.cornerRadius = 17.5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let galeria: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "gallery"), for: .normal)
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        btn.layer.shadowRadius = 1.8
        btn.layer.shadowOpacity = 0.45
        btn.layer.cornerRadius = 17.5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var photoView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let container: UIView = {
        let vi = UIView()
        vi.backgroundColor = .white
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let sendLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Enviar?"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let yesBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Sim", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 18)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let nayBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Não", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 18)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if photoView.image != nil {
            UIView.animate(withDuration: 0.5, animations: {
                self.heightAnchor?.constant = self.view.frame.height * 0.08
                self.bottomAnchor?.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func setup() {
        
        view.addSubview(photoView)
        view.addSubview(closeBtn)
        view.addSubview(galeria)
        view.addSubview(container)
        container.addSubview(sendLbl)
        container.addSubview(yesBtn)
        container.addSubview(nayBtn)
        
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        galeria.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        galeria.centerYAnchor.constraint(equalTo: closeBtn.centerYAnchor, constant: 0).isActive = true
        galeria.heightAnchor.constraint(equalToConstant: 38).isActive = true
        galeria.widthAnchor.constraint(equalToConstant: 38).isActive = true
        galeria.addTarget(self, action: #selector(openPhotosApp), for: .touchUpInside)
        
        photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        photoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        photoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        heightAnchor = container.heightAnchor.constraint(equalToConstant: 0)
        heightAnchor?.isActive = true
        bottomAnchor = container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 15)
        bottomAnchor?.isActive = true
        
        sendLbl.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 30).isActive = true
        sendLbl.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        yesBtn.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -30).isActive = true
        yesBtn.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        yesBtn.addTarget(self, action: #selector(sendPhoto), for: .touchUpInside)
        
        nayBtn.rightAnchor.constraint(equalTo: yesBtn.leftAnchor, constant: -35).isActive = true
        nayBtn.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        nayBtn.addTarget(self, action: #selector(rejectPhoto), for: .touchUpInside)
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rejectPhoto() {
        photoView.image = nil
        UIView.animate(withDuration: 0.5, animations: {
            self.heightAnchor?.constant = 0
            self.bottomAnchor?.constant = 15
            self.view.layoutIfNeeded()
        })
    }
    
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
            photoView.image = theImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendPhoto() {
        if photoView.image != nil {
            showActivityIndicator(view: self.view, indicator: indicator)
            if let image = selectedImage as UIImage? {
                let imageID = NSUUID().uuidString
                let ref = Storage.storage().reference().child(details.eventID!).child("albumPhotos").child(imageID)
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
    }
    
    func sendPhotoToDB(imageUrl: String) {
        let ref = Database.database().reference().child("Codes").child(details.eventID!).child("slideshow").childByAutoId()
        ref.updateChildValues(["foto": imageUrl])
        dismissActivityIndicator(view: self.view, indicator: indicator) {
            self.rejectPhoto()
        }
    }
    
}
