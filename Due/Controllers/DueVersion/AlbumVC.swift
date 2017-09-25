//
//  AlbumVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

fileprivate var cellID = "Cell"

class AlbumVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let userDefaults = UserDefaults.standard
    
    let hintImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "photos")
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let back: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "left"), for: .normal)
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        btn.layer.shadowRadius = 1.8
        btn.layer.shadowOpacity = 0.45
        btn.layer.cornerRadius = 17.5
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let collec: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.showsHorizontalScrollIndicator = false
        col.isPagingEnabled = true
        col.backgroundColor = .clear
        col.decelerationRate = UIScrollViewDecelerationRateFast
        return col
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        oneTimeAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func willMove(toParentViewController parent: UIViewController?){
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func setup() {
        
        view.addSubview(hintImg)
        hintImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintImg.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15).isActive = true
        hintImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        hintImg.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        if eventModel.photos.count > 0 {
            hintImg.isHidden = true
        }
        
        view.addSubview(collec)
        view.addSubview(back)
        
        back.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        back.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        collec.frame = view.frame
        collec.center = view.center
        collec.delegate = self
        collec.dataSource = self
        collec.register(AlbumCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func oneTimeAlert() {
        if !userDefaults.bool(forKey: "oneTimeAlert") {
            userDefaults.set(true, forKey: "oneTimeAlert")
            let alert = UIAlertController(title: nil, message: "Deslize para a direita para ver mais fotos!", preferredStyle: .actionSheet)
            let action = UIAlertAction( title: "Ok", style:.default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: COLLECTION VIEW PROTOCOL AND DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AlbumCell
        cell.vc = self
        let photo = eventModel.photos[indexPath.item]
        cell.configureCell(foto: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collec.frame.width, height: collec.frame.height * 1.1)
    }
    
    // MARK: COLLECTION VIEW CELL
    
    class AlbumCell: UICollectionViewCell {
        
        var model: Foto!
        var vc: AlbumVC?
        
        let photo: NetworkImageView = {
            let img = NetworkImageView()
            img.contentMode = .scaleAspectFill
            img.clipsToBounds = true
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(photo)
            photo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            photo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            photo.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            photo.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        }
        
        func configureCell(foto: Foto) {
            self.model = foto
            if let image = foto.imageUrl {
                self.photo.loadImageUsingCacheWithUrlString(image)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
