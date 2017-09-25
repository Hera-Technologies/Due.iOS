//
//  FirstVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

var audioPlayer: AVPlayer?
var player: AVPlayer?

class FirstVC: UITabBarController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: ELEMENTS
    
    var timer: Timer?
    
    let hintImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "movie")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let days: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "Avenir-Book", size: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .white
        lbl.layer.masksToBounds = true
        lbl.textAlignment = .center
        lbl.alpha = 0.7
        return lbl
    }()
    
    let hours: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "Avenir-Book", size: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .white
        lbl.layer.masksToBounds = true
        lbl.textAlignment = .center
        lbl.alpha = 0.7
        return lbl
    }()
    
    let minutes: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "Avenir-Book", size: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .white
        lbl.layer.masksToBounds = true
        lbl.textAlignment = .center
        lbl.alpha = 0.7
        return lbl
    }()
    
    let seconds: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "Avenir-Book", size: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .white
        lbl.layer.masksToBounds = true
        lbl.textAlignment = .center
        lbl.alpha = 0.7
        return lbl
    }()
    
    let diaLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "Dias"
        lbl.backgroundColor = UIColor.clear
        lbl.font = UIFont(name: "Avenir-Book", size: 15)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let horaLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "Horas"
        lbl.backgroundColor = UIColor.clear
        lbl.font = UIFont(name: "Avenir-Book", size: 15)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let minLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "Minutos"
        lbl.backgroundColor = UIColor.clear
        lbl.font = UIFont(name: "Avenir-Book", size: 15)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let secLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.text = "Segundos"
        lbl.backgroundColor = UIColor.clear
        lbl.font = UIFont(name: "Avenir-Book", size: 15)
        lbl.textColor = .black
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let menu: KCFloatingActionButton = {
        let btn = KCFloatingActionButton()
        btn.buttonColor = .white
        btn.plusColor = dark
        btn.autoCloseOnTap = true
        btn.paddingY = 58
        btn.openAnimationType = .pop
        return btn
    }()
    
    // MARK: VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        setupMenu()
        
    }
    
    func setup() {
        
        if eventModel.videoUrl != nil {
            hintImg.isHidden = true
        }
        
        view.addSubview(hintImg)
        view.addSubview(days)
        view.addSubview(hours)
        view.addSubview(minutes)
        view.addSubview(seconds)
        view.addSubview(diaLbl)
        view.addSubview(horaLbl)
        view.addSubview(minLbl)
        view.addSubview(secLbl)
        view.addSubview(menu)
        
        hintImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintImg.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15).isActive = true
        hintImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        hintImg.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        days.layer.cornerRadius = 32
        hours.layer.cornerRadius = 32
        minutes.layer.cornerRadius = 32
        seconds.layer.cornerRadius = 32
        
        days.rightAnchor.constraint(equalTo: hours.leftAnchor, constant: -15).isActive = true
        days.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        days.widthAnchor.constraint(equalToConstant: 64).isActive = true
        days.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        hours.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40).isActive = true
        hours.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        hours.widthAnchor.constraint(equalToConstant: 64).isActive = true
        hours.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        minutes.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40).isActive = true
        minutes.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        minutes.widthAnchor.constraint(equalToConstant: 64).isActive = true
        minutes.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        seconds.leftAnchor.constraint(equalTo: minutes.rightAnchor, constant: 15).isActive = true
        seconds.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        seconds.widthAnchor.constraint(equalToConstant: 64).isActive = true
        seconds.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        diaLbl.topAnchor.constraint(equalTo: days.bottomAnchor, constant: 3).isActive = true
        diaLbl.centerXAnchor.constraint(equalTo: days.centerXAnchor).isActive = true
        
        horaLbl.topAnchor.constraint(equalTo: hours.bottomAnchor, constant: 3).isActive = true
        horaLbl.centerXAnchor.constraint(equalTo: hours.centerXAnchor).isActive = true
        
        minLbl.topAnchor.constraint(equalTo: minutes.bottomAnchor, constant: 3).isActive = true
        minLbl.centerXAnchor.constraint(equalTo: minutes.centerXAnchor).isActive = true
        
        secLbl.topAnchor.constraint(equalTo: seconds.bottomAnchor, constant: 3).isActive = true
        secLbl.centerXAnchor.constraint(equalTo: seconds.centerXAnchor).isActive = true
        
    }
    
    // MARK: INITIATE FEATURES
    
    func initiateFeatures() {
        
        // Countdown
        if eventModel.date != nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
            timer?.fire()
            hideCountdown()
        } else {
            diaLbl.isHidden = true
            horaLbl.isHidden = true
            minLbl.isHidden = true
            secLbl.isHidden = true
        }
        
        // Video
        
        player?.actionAtItemEnd = .none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        playerLayer.frame = self.view.frame
        view.layer.addSublayer(playerLayer)
        player?.isMuted = true
        player?.play()
        NotificationCenter.default.addObserver(self, selector: #selector(loopVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    // MARK: VIDEO LOOP
    
    @objc func loopVideo() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    // MARK: COUNTDOWN
    
    @objc func countdown() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let startTime = Date()
        let calendar = Calendar.current
        guard let endTimeLbl = eventModel.date else { return }
        guard let end = formatter.date(from: endTimeLbl) else { return }
        let comp: NSCalendar.Unit = [NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second]
        let timeDifference = (calendar as NSCalendar).components(comp, from: startTime, to: end, options: [])
        
        if startTime == end {
            timer?.invalidate()
        }
        
        var opD: Int?
        opD = timeDifference.day
        if let opd = opD {
            days.text = "\(opd)"
        }
        
        var opH: Int?
        opH = timeDifference.hour
        if let oph = opH {
            hours.text = "\(oph)"
        }
        
        var opM: Int?
        opM = timeDifference.minute
        if let opm = opM {
            minutes.text = "\(opm)"
        }
        
        var opS: Int?
        opS = timeDifference.second
        if let ops = opS {
            seconds.text = "\(ops)"
        }
        
    }
    
    func setupMenu() {
        
        let audio = KCFloatingActionButtonItem()
        audio.title = "Som"
        audio.buttonColor = .white
        audio.icon = #imageLiteral(resourceName: "pause")
        audio.handler = { item in
            
            if audio.icon == #imageLiteral(resourceName: "pause") {
                audioPlayer?.pause()
            } else {
                audioPlayer?.play()
            }
            
            self.toggle(button: audio, onImage: #imageLiteral(resourceName: "play"), offImage: #imageLiteral(resourceName: "pause"))
            
        }
        
        menu.addItem(item: audio)
        
        let album = KCFloatingActionButtonItem()
        album.title = "Album"
        album.icon = #imageLiteral(resourceName: "album")
        album.buttonColor = .white
        album.handler = { item in
            self.goToAlbum()
        }
        
        menu.addItem(item: album)
        
        let casal = KCFloatingActionButtonItem()
        casal.title = "Casal"
        casal.icon = #imageLiteral(resourceName: "casal")
        casal.buttonColor = .white
        casal.handler = { item in
            self.goToCasal()
        }
        
        menu.addItem(item: casal)
        
    }
    
    func goToCasal() {
        let casal = CasalVC()
        self.navigationController?.pushViewController(casal, animated: true)
    }
    
    func goToAlbum() {
        let album = AlbumVC()
        self.navigationController?.pushViewController(album, animated: true)
    }
    
    func toggle(button: KCFloatingActionButtonItem, onImage: UIImage, offImage: UIImage) {
        if button.icon == offImage {
            button.icon = onImage
        } else {
            button.icon = offImage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        initiateFeatures()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func hideCountdown() {
        
        if let dia = days.text, let hora = hours.text, let minuto = minutes.text, let segundos = seconds.text {
            let day = Int(dia)
            let hour = Int(hora)
            let minute = Int(minuto)
            let sec = Int(segundos)
            if day! <= 0 && hour! <= 0 && minute! <= 0 && sec! <= 0 {
                self.days.isHidden = true
                self.diaLbl.isHidden = true
                self.hours.isHidden = true
                self.horaLbl.isHidden = true
                self.minutes.isHidden = true
                self.minLbl.isHidden = true
                self.seconds.isHidden = true
                self.secLbl.isHidden = true
                
            }
            
        }
        
    }
    
}
