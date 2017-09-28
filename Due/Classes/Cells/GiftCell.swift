//
//  GiftCell.swift
//  Due
//
//  Created by Lucas Andrade on 9/27/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class GiftCell: UICollectionViewCell {
    
    var vc: FourthVC?
    var model: Gift?
    var desc: String?
    
    let photo: NetworkImageView = {
        let img = NetworkImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 15
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let giftLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = darker
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Roman", size: 15)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        backgroundColor = .white
    
    }
    
    func setup() {
        
        addSubview(photo)
        addSubview(giftLbl)
        addSubview(priceLbl)
        
        photo.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photo.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        photo.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        photo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
        
        giftLbl.leadingAnchor.constraint(equalTo: photo.leadingAnchor, constant: 5).isActive = true
        giftLbl.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 6).isActive = true
        
        priceLbl.leadingAnchor.constraint(equalTo: photo.leadingAnchor, constant: 5).isActive = true
        priceLbl.topAnchor.constraint(equalTo: giftLbl.bottomAnchor, constant: 2).isActive = true
        
    }
    
    func configureCell(model: Gift) {
        self.model = model
        if let image = model.image {
            self.photo.loadImageUsingCacheWithUrlString(image)
        }
        self.giftLbl.text = model.name
        self.desc = model.desc
        self.priceLbl.text = model.amount
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
