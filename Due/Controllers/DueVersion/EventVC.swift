//
//  EventVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

class EventVC: UIViewController {
    
    var lat: String?
    var long: String?
    
    let back: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let photo: NetworkImageView = {
        let img = NetworkImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = offwhite
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let directions: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "directions"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let location: UILabel = {
        let lbl = UILabel()
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.font = UIFont(name: "Avenir-Black", size: 28)
        return lbl
    }()
    
    let address: UILabel = {
        let lbl = UILabel()
        lbl.textColor = dark
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Roman", size: 16)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    let line: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let seeAllBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("ver lista", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 16)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let middleIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "chatinfo")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let forneTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Informações"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let forneMessage: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        Clique em "ver lista" para conferir informações que os noivos deixaram para os convidados.
        """
        lbl.textColor = .gray
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 16)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        view.backgroundColor = .white
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func willMove(toParentViewController parent: UIViewController?){
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func setup() {
        
        view.addSubview(back)
        view.addSubview(photo)
        view.addSubview(location)
        view.addSubview(address)
        view.addSubview(directions)
        view.addSubview(line)
        view.addSubview(seeAllBtn)
        view.addSubview(middleIcon)
        view.addSubview(forneTitle)
        view.addSubview(forneMessage)
        
        back.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        back.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        photo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photo.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 6).isActive = true
        photo.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        photo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        location.frame = CGRect(x: 20, y: view.frame.height * 0.44, width: view.frame.width * 0.7, height: 40)
        address.frame = CGRect(x: 25, y: view.frame.height * 0.5, width: view.frame.width * 0.75, height: 25)
        
        directions.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        directions.centerYAnchor.constraint(equalTo: location.centerYAnchor, constant: 0).isActive = true
        directions.heightAnchor.constraint(equalToConstant: 38).isActive = true
        directions.widthAnchor.constraint(equalToConstant: 38).isActive = true
        directions.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 5).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        forneTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        forneTitle.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20).isActive = true
        
        seeAllBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        seeAllBtn.centerYAnchor.constraint(equalTo: forneTitle.centerYAnchor, constant: 0).isActive = true
        seeAllBtn.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        
        middleIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        middleIcon.topAnchor.constraint(equalTo: seeAllBtn.bottomAnchor, constant: 10).isActive = true
        middleIcon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        middleIcon.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24).isActive = true
        
        forneMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forneMessage.topAnchor.constraint(equalTo: middleIcon.bottomAnchor, constant: 10).isActive = true
        forneMessage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
    }
    
    // MARK: RETRIEVE DATA FROM FIREBASE
    
    func fetchData() {
        Database.database().reference().child("Codes").child(eventModel.eventCode!).child("evento").observe(.value, with: { (snap) in
            guard let data = snap.value as? [String: AnyObject] else { return }
            let address = data["locationAddress"] as? String
            self.address.text = address
            let name = data["locationName"] as? String
            self.location.text = name
            let latitute = data["coordLat"] as? String
            let longitude = data["coordLong"] as? String
            self.lat = latitute
            self.long = longitude
            if let foto = data["locationPhoto"] as? String {
                self.photo.loadImageUsingCacheWithUrlString(foto)
            }
        })
    }
    
    // MARK: BUTTONS METHODS
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showInfo() {
        let vc = InfoVC()
        present(vc, animated: true, completion: nil)
    }
    
    func getDirections() {
        if let longitude = long, let latitude = lat {
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")
                UIApplication.shared.openURL(url!)
            } else {
                UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/dir/?api=1&destination=\(latitude),\(longitude)&travelmode=driving")!)
            }
        }
    }
    
    func fetchDirections() {
        if let longitude = long, let latitude = lat {
            let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string:"https://www.google.com/maps/dir/?api=1&destination=\(latitude),\(longitude)&travelmode=driving")!)
            }
        }
        
    }
    
}
