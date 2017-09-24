//
//  SecondVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class SecondVC: UIViewController, iCarouselDelegate, iCarouselDataSource {
    
    // MARK: ELEMENTS
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Padrinhos"
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
    
    let hintImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "padrinho")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // MARK: VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    func setup() {
        
        if eventModel.padrinhos.count > 0 {
            hintImg.isHidden = true
        }
        
        view.addSubview(hintImg)
        view.addSubview(viewTitle)
        view.addSubview(line)
        
        let titleY = view.frame.height * 0.38
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        hintImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintImg.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15).isActive = true
        hintImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        hintImg.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        let carousel: iCarousel = iCarousel(frame: CGRect(origin: .zero, size: view.frame.size))
        view.addSubview(carousel)
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = .cylinder
        carousel.reloadData()
        
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return eventModel.padrinhos.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let tempView = UIView()
        let width = self.view.frame.width * 0.9
        tempView.frame.size = CGSize(width: width, height: self.view.frame.height * 0.5)
        tempView.center = carousel.center
        tempView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        let image = NetworkImageView(frame: CGRect(x: 0, y: 0, width: tempView.frame.width, height: tempView.frame.height * 0.74))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        let foto = eventModel.padrinhos[(index)]
        if let url = foto.imageUrl {
            image.loadImageUsingCacheWithUrlString(url)
        }
        
        let message = UITextView()
        
        message.center.x = width * 0.05
        message.frame.origin.y = tempView.frame.height * 0.73
        message.frame.size = CGSize(width: tempView.frame.width * 0.9, height: tempView.frame.height * 0.26)
        message.text = eventModel.messages.object(at: index) as? String
        message.font = UIFont(name: "Avenir-Roman", size: 16)
        message.textColor = darker
        message.textAlignment = .justified
        message.backgroundColor = .clear
        message.isScrollEnabled = true
        message.isEditable = false
        message.isSelectable = false
        message.showsVerticalScrollIndicator = false
        
        tempView.insertSubview(message, at: 1)
        tempView.insertSubview(image, at: 0)
        tempView.layer.cornerRadius = 20
        tempView.layer.masksToBounds = true
        return tempView
        
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.1
        }
        return value
    }
    
}
