//
//  AlbumPhotoCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

protocol AlbumPhotoCellDelegate {
    func deletePhoto(cell: AlbumPhotoCell)
}

class AlbumPhotoCell: UICollectionViewCell {
    
    var model: AlbumPhoto?
    var vc: PhotoAlbumVC!
    var delegate: AlbumPhotoCellDelegate?
    
    let photo: NetworkImageView = {
        let img = NetworkImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "red"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 18
        layer.masksToBounds = true
        addSubview(photo)
        addSubview(deleteBtn)
        
        photo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        photo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        photo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        photo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        deleteBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        deleteBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        deleteBtn.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
        
    }
    
    func configureCell(foto: AlbumPhoto) {
        self.model = foto
        if let image = foto.imageUrl {
            self.photo.loadImageUsingCacheWithUrlString(image)
        }
    }
    
    @objc func deletePhoto() {
        delegate?.deletePhoto(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

