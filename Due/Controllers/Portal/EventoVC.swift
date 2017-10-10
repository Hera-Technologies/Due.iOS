//
//  EventoVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class EventoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage: UIImage?
    let indicator = UIActivityIndicatorView()
    
    let backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Evento"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 23)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let nextBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Próxima", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-heavy", size: 18)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let locationTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Local"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let locationPhoto:  NetworkImageView = {
        let img = NetworkImageView()
        img.backgroundColor = offwhite
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let addBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "camera"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let nameField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Nome do local"
        txt.textColor = darker
        txt.textAlignment = .left
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let nameLine: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let addressField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Endereço"
        txt.textColor = darker
        txt.textAlignment = .left
        txt.font = UIFont(name: "Avenir-Roman", size: 16)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let addressLine: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let coordTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Coordenadas"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let latField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Latitude"
        txt.textColor = darker
        txt.textAlignment = .left
        txt.font = UIFont(name: "Avenir-Roman", size: 16)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let longField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Longitude"
        txt.textColor = darker
        txt.textAlignment = .left
        txt.font = UIFont(name: "Avenir-Roman", size: 16)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let coordLine: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let obsLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        *Para obter as coordenadas, acesse o Google Maps e coloque um marco no local desejado. Ou, pesquise o local, clique no marco com o botão direito e selecione a opção "O que tem aqui?."
        """
        lbl.textColor = .gray
        lbl.textAlignment = .justified
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Roman", size: 13)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let updateBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Atualizar", for: UIControlState())
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func setup() {
        
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(nextBtn)
        view.addSubview(line)
        view.addSubview(locationTitle)
        view.addSubview(locationPhoto)
        view.addSubview(addBtn)
        view.addSubview(nameField)
        view.addSubview(nameLine)
        view.addSubview(addressField)
        view.addSubview(addressLine)
        view.addSubview(coordTitle)
        view.addSubview(latField)
        view.addSubview(longField)
        view.addSubview(coordLine)
        view.addSubview(obsLbl)
        view.addSubview(updateBtn)
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: 4).isActive = true
        
        let lineY = view.frame.height * 0.32
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -lineY).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        nextBtn.bottomAnchor.constraint(equalTo: line.topAnchor, constant: 0).isActive = true
        nextBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nextBtn.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        
        locationTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        locationTitle.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 30).isActive = true
        
        locationPhoto.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        locationPhoto.topAnchor.constraint(equalTo: locationTitle.topAnchor, constant: 0).isActive = true
        locationPhoto.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35).isActive = true
        locationPhoto.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
        
        addBtn.rightAnchor.constraint(equalTo: locationPhoto.leftAnchor, constant: -8).isActive = true
        addBtn.bottomAnchor.constraint(equalTo: locationPhoto.bottomAnchor).isActive = true
        addBtn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        addBtn.addTarget(self, action: #selector(openPhotosApp), for: .touchUpInside)
        
        nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameField.topAnchor.constraint(equalTo: locationPhoto.bottomAnchor, constant: 30).isActive = true
        nameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        nameLine.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 2).isActive = true
        nameLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLine.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        nameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addressField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressField.topAnchor.constraint(equalTo: nameLine.bottomAnchor, constant: 30).isActive = true
        addressField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        addressLine.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 2).isActive = true
        addressLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressLine.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        addressLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        coordTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        coordTitle.topAnchor.constraint(equalTo: addressLine.bottomAnchor, constant: 25).isActive = true
        
        latField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23).isActive = true
        latField.topAnchor.constraint(equalTo: coordTitle.bottomAnchor, constant: 15).isActive = true
        latField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        
        longField.leftAnchor.constraint(equalTo: latField.rightAnchor, constant: 10).isActive = true
        longField.topAnchor.constraint(equalTo: coordTitle.bottomAnchor, constant: 15).isActive = true
        longField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        
        coordLine.topAnchor.constraint(equalTo: latField.bottomAnchor, constant: 2).isActive = true
        coordLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coordLine.widthAnchor.constraint(equalTo: addressLine.widthAnchor).isActive = true
        coordLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        obsLbl.topAnchor.constraint(equalTo: coordLine.bottomAnchor, constant: 8).isActive = true
        obsLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        obsLbl.widthAnchor.constraint(equalTo: coordLine.widthAnchor).isActive = true
        
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
    
    @objc func nextScreen() {
        navigationController?.pushViewController(InfoListVC(), animated: true)
    }
    
    @objc func goBack() {
        self.navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
    
    // MARK: FETCH DATA FROM FIREBASE
    
    func fetchData() {
        Database.database().reference().child("Codes").child(details.eventID!).child("evento").observe(.value, with: { (snap) in
            guard let data = snap.value as? [String: AnyObject] else { return }
            // Location
            if let photo = data["locationPhoto"] as? String {
                self.locationPhoto.loadImageUsingCacheWithUrlString(photo)
            }
            let locationName = data["locationName"] as? String
            let address = data["locationAddress"] as? String
            self.nameField.text = locationName
            self.addressField.text = address
            // Coordinates
            let lat = data["coordLat"] as? String
            let long = data["coordLong"] as? String
            self.latField.text = lat
            self.longField.text = long
        })
    }
    
    // MARK: UPDATE VERSION METHODS
    
    @objc func updateVersion() {
        updateLocationInfo()
        updatePhoto()
        _ = SweetAlert().showAlert("Muito bem!", subTitle: "Versão atualizada", style: .success, buttonTitle: "Ok")
    }
    
    // MARK: LOCATION INFO
    
    func updateLocationInfo() {
        if nameField.text != "" {
            sendData(data: ["locationName": nameField.text!])
        }
        if addressField.text != "" {
            sendData(data: ["locationAddress": addressField.text!])
        }
        if latField.text != "" && longField.text != "" {
            sendData(data: ["coordLat": latField.text!, "coordLong": longField.text!])
        }
    }
    
    // MARK: LOCATION PHOTO
    
    @objc func openPhotosApp() {
        let picker = UIImagePickerController()
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
            locationPhoto.image = theImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func updatePhoto() {
        if locationPhoto.image != nil {
            if let image = selectedImage as UIImage? {
                if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
                    Storage.storage().reference().child(details.eventID!).child("locationPhoto").putData(uploadData, metadata: nil, completion: { (metadata, err) in
                        if err != nil {
                            print(err!)
                            return
                        }
                        if let imageUrl = metadata?.downloadURL()?.absoluteString {
                            self.sendData(data: ["locationPhoto": imageUrl])
                        }
                    })
                }
            }
        }
    }
    
    // MARK: HELPER METHOD
    
    func sendData(data: [String: Any]) {
        Database.database().reference().child("Codes").child(details.eventID!).child("evento").updateChildValues(data)
    }
    
}
