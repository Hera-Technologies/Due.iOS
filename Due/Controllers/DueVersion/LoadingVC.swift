//
//  LoadingVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation

class LoadingVC: UIViewController {
    
    let indicatorView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showActivityIndicator(uiView: self.view)
        setupDueVersion {
            self.indicatorView.indicator.stopAnimating()
            let vc = TabBar()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func setupDueVersion(completion: @escaping () -> Void) {
        if eventModel.eventCode != nil {
            fetchFirstScreen {
                self.fetchPadrinhos {
                    self.fetchPhotos {
                        self.fetchCouple {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func fetchFirstScreen(completion: @escaping () -> Void) {
        Database.database().reference().child("Codes").child(eventModel.eventCode!).child("video").observeSingleEvent(of: .value, with: { (snap) in
            if let data = snap.value as? [String : AnyObject] {
                let date = data["data"] as? String
                eventModel.date = date
                if let video = data["videoUrl"] as? String {
                    eventModel.videoUrl = URL(string: video)
                    player = AVPlayer(url: eventModel.videoUrl!)
                }
                if let urlString = data["songUrl"] as? String {
                    eventModel.songUrl = NSURL(string: urlString)
                    do {
                        let playerItem = AVPlayerItem(url: eventModel.songUrl! as URL)
                        audioPlayer = AVPlayer(playerItem: playerItem)
                        audioPlayer?.play()
                    }
                }
            }
            completion()
        })
    }
    
    func fetchPadrinhos(completion: @escaping () -> Void) {
        Database.database().reference().child("Codes").child(eventModel.eventCode!).child("padrinhos").observe(.value, with: { (snap) in
            if let padrinhos = snap.children.allObjects as? [DataSnapshot] {
                for padrinho in padrinhos {
                    if let data = padrinho.value as? [String: AnyObject] {
                        let texto = data["texto"] as? String
                        eventModel.messages.add(texto ?? "")
                        let foto = data["foto"] as? String
                        let photo = Foto()
                        photo.imageUrl = foto
                        eventModel.padrinhos.append(photo)
                    }
                }
            }
            completion()
        })
    }
    
    func fetchCouple(completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("Codes").child(eventModel.eventCode!).child("story")
        ref.observeSingleEvent(of: .value, with: { (snap) in
            if let data = snap.value as? [String : AnyObject] {
                let texto = data["texto"] as? String
                eventModel.story = texto
            }
        })
        ref.child("noivo").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String : AnyObject] {
                let hubPhoto = data["foto"] as? String
                eventModel.hubPhoto = hubPhoto
                let nome = data["nome"] as? String
                eventModel.hubName = nome
            }
        })
        ref.child("noiva").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String : AnyObject] {
                let bridePhoto = data["foto"] as? String
                eventModel.bridePhoto = bridePhoto
                let nome = data["nome"] as? String
                eventModel.brideName = nome
            }
            completion()
        })
    }
    
    func fetchPhotos(completion: @escaping () -> Void) {
        Database.database().reference().child("Codes").child(eventModel.eventCode!).child("slideshow").observe(.value, with: { (snap) in
            eventModel.photos = []
            if let photos = snap.children.allObjects as? [DataSnapshot] {
                for photo in photos {
                    if let data = photo.value as? [String: AnyObject] {
                        let photoUrl = data["foto"] as? String
                        let item = Foto()
                        item.imageUrl = photoUrl
                        eventModel.photos.append(item)
                    }
                }
            }
            completion()
        })
    }
    
    func showActivityIndicator(uiView: UIView) {
        indicatorView.tag = 5
        indicatorView.frame = uiView.frame
        indicatorView.center = uiView.center
        uiView.addSubview(indicatorView)
    }
    
}
