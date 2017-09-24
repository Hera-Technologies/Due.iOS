//
//  PhotoZoomVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class PhotoZoomVC: UIViewController, UIScrollViewDelegate {
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.photo.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let scrollView: UIScrollView = {
        let vi = UIScrollView()
        vi.backgroundColor = .clear
        vi.minimumZoomScale = 1
        vi.maximumZoomScale = 6
        vi.bouncesZoom = true
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    var photo: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
    }
    
    func setup() {
        
        view.addSubview(scrollView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        scrollView.delegate = self
        scrollView.addSubview(photo)
        
        view.addSubview(closeBtn)
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        photo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        photo.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        photo.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        photo.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 0.5).isActive = true
        
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photo
    }
    
}
