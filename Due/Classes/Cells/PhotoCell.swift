//
//  PhotoCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate {
    func savePhoto(cell: PhotoCell)
}

class PhotoCell: UITableViewCell {
    
    var model: Photo!
    var vc: PhotosVC?
    var delegate: PhotoCellDelegate?
    
    let profilePhoto: NetworkImageView = {
        let img = NetworkImageView()
        img.image = #imageLiteral(resourceName: "hint")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 20
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let username: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = darker
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let saveBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "save"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let photo: NetworkImageView = {
        let img = NetworkImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 16
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let caption: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .justified
        lbl.textColor = .darkGray
        lbl.font = UIFont(name: "Avenir-Roman", size: 16)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "photoCell")
        
        addSubview(profilePhoto)
        addSubview(username)
        addSubview(saveBtn)
        addSubview(photo)
        addSubview(caption)
        
        profilePhoto.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        profilePhoto.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        profilePhoto.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profilePhoto.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        username.leftAnchor.constraint(equalTo: profilePhoto.rightAnchor, constant: 12).isActive = true
        username.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor).isActive = true
        
        saveBtn.trailingAnchor.constraint(equalTo: photo.trailingAnchor, constant: -8).isActive = true
        saveBtn.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor).isActive = true
        saveBtn.addTarget(self, action: #selector(savePic), for: .touchUpInside)
        
        let hgt = UIScreen.main.bounds.height * 0.32
        photo.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 12).isActive = true
        photo.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor, constant: 5).isActive = true
        photo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        photo.heightAnchor.constraint(equalToConstant: hgt).isActive = true
        
        caption.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 12).isActive = true
        caption.leadingAnchor.constraint(equalTo: photo.leadingAnchor, constant: 5).isActive = true
        caption.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        caption.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        
    }
    
    @objc func savePic() {
        delegate?.savePhoto(cell: self)
    }
    
    func configureCell(foto: Photo) {
        self.model = foto
        self.username.text = foto.name
        if let profilePic = foto.profilePhoto {
            self.profilePhoto.loadImageUsingCacheWithUrlString(profilePic)
        }
        if let image = foto.imageUrl {
            self.photo.loadImageUsingCacheWithUrlString(image)
        }
        if let legenda = foto.caption {
            self.caption.text = legenda
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

