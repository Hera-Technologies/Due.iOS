//
//  MainVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//


import UIKit
import Firebase
import MobileCoreServices

class MainVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var video: URL?
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
        lbl.text = "Tela inicial"
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
    
    // MARK: VIDEO
    
    let videoTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Video"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let videoDesc: UILabel = {
        let lbl = UILabel()
        // sugerir clipchamp para edição e compressão do video.
        lbl.text = "Orientação vertical para melhores resultados!"
        lbl.textColor = .gray
        lbl.textAlignment = .justified
        lbl.font = UIFont(name: "Avenir-Roman", size: 15)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let videoContainer: UIView = {
        let vi = UIView()
        vi.backgroundColor = offwhite
        vi.layer.cornerRadius = 10
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let videoIcon:  NetworkImageView = {
        let img = NetworkImageView()
        img.image = UIImage(named: "videocamera")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let videoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: MUSIC
    
    let songTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Música"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let songDesc: UILabel = {
        let lbl = UILabel()
        lbl.text = "Escolha uma música de fundo!"
        lbl.textColor = .gray
        lbl.textAlignment = .justified
        lbl.font = UIFont(name: "Avenir-Roman", size: 15)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let songContainer: UIView = {
        let vi = UIView()
        vi.backgroundColor = offwhite
        vi.layer.cornerRadius = 10
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let songIcon:  NetworkImageView = {
        let img = NetworkImageView()
        img.image = UIImage(named: "note")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let songBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: DATA
    
    let dateTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Data"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let dateField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "dia do casamento"
        txt.textColor = darker
        txt.textAlignment = .center
        txt.font = UIFont(name: "Avenir-Roman", size: 18)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let dateLine: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.minimumDate = Date()
        return dp
    }()
    
    let updateBtn: BounceButton = {
        let btn = BounceButton()
        btn.setTitle("Atualizar", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(.white, for: UIControlState())
        btn.backgroundColor = darker
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        fetchData()
        
    }
    
    func setup() {
        
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(nextBtn)
        view.addSubview(line)
        view.addSubview(videoTitle)
        view.addSubview(videoDesc)
        view.addSubview(videoContainer)
        view.addSubview(videoIcon)
        view.addSubview(videoBtn)
        view.addSubview(songTitle)
        view.addSubview(songDesc)
        view.addSubview(songContainer)
        view.addSubview(songIcon)
        view.addSubview(songBtn)
        view.addSubview(dateTitle)
        view.addSubview(dateField)
        view.addSubview(dateLine)
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
        
        // VIDEO ELEMENTS SETUP
        
        videoTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        videoTitle.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 30).isActive = true
        
        videoDesc.leadingAnchor.constraint(equalTo: videoTitle.leadingAnchor, constant: 0).isActive = true
        videoDesc.topAnchor.constraint(equalTo: videoTitle.bottomAnchor, constant: 10).isActive = true
        videoDesc.rightAnchor.constraint(equalTo: videoContainer.leftAnchor, constant: -15).isActive = true
        
        videoContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        videoContainer.centerYAnchor.constraint(equalTo: videoDesc.centerYAnchor).isActive = true
        videoContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        videoContainer.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.22).isActive = true
        
        videoIcon.centerXAnchor.constraint(equalTo: videoContainer.centerXAnchor).isActive = true
        videoIcon.centerYAnchor.constraint(equalTo: videoContainer.centerYAnchor).isActive = true
        videoIcon.widthAnchor.constraint(equalTo: videoContainer.widthAnchor, multiplier: 0.68).isActive = true
        videoIcon.heightAnchor.constraint(equalTo: videoContainer.heightAnchor, multiplier: 0.6).isActive = true
        
        videoBtn.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor).isActive = true
        videoBtn.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: -20).isActive = true
        videoBtn.addTarget(self, action: #selector(uploadVideo), for: .touchUpInside)
        
        // MUSIC ELEMENTS SETUP
        
        songTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        songTitle.topAnchor.constraint(equalTo: videoBtn.bottomAnchor, constant: 10).isActive = true
        
        songDesc.leadingAnchor.constraint(equalTo: songTitle.leadingAnchor, constant: 0).isActive = true
        songDesc.topAnchor.constraint(equalTo: songTitle.bottomAnchor, constant: 10).isActive = true
        songDesc.rightAnchor.constraint(equalTo: songContainer.leftAnchor, constant: -15).isActive = true
        
        songContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        songContainer.centerYAnchor.constraint(equalTo: songDesc.centerYAnchor).isActive = true
        songContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        songContainer.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.22).isActive = true
        
        songIcon.centerXAnchor.constraint(equalTo: songContainer.centerXAnchor).isActive = true
        songIcon.centerYAnchor.constraint(equalTo: songContainer.centerYAnchor).isActive = true
        songIcon.widthAnchor.constraint(equalTo: songContainer.widthAnchor, multiplier: 0.5).isActive = true
        songIcon.heightAnchor.constraint(equalTo: songContainer.heightAnchor, multiplier: 0.6).isActive = true
        
        songBtn.trailingAnchor.constraint(equalTo: songContainer.trailingAnchor).isActive = true
        songBtn.topAnchor.constraint(equalTo: songContainer.bottomAnchor, constant: -20).isActive = true
        songBtn.addTarget(self, action: #selector(uploadSong), for: .touchUpInside)
        
        // DATE ELEMENTS SETUP
        
        dateTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        dateTitle.topAnchor.constraint(equalTo: songBtn.bottomAnchor, constant: 15).isActive = true
        
        dateField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateField.topAnchor.constraint(equalTo: dateTitle.bottomAnchor, constant: 15).isActive = true
        dateField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        dateField.inputView = datePicker
        dateField.delegate = self
        datePicker.addTarget(self, action: #selector(setDate), for: .valueChanged)
        
        dateLine.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: 2).isActive = true
        dateLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateLine.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        dateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
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
    
    // MARK: NAVIGATION METHODS
    
    @objc func uploadSong() {
        present(EditSongVC(), animated: true, completion: nil)
    }
    
    @objc func nextScreen() {
        navigationController?.pushViewController(CoupleVC(), animated: true)
    }
    
    @objc func goBack() {
        navigationController?.popToViewController(navigationController!.viewControllers[2], animated: true)
    }
    
    // MARK: FETCH DATA FROM FIREBASE
    
    func fetchData() {
        Database.database().reference().child("Codes").child(details.eventID!).child("video").observe(.value, with: { (snap) in
            guard let data = snap.value as? [String: AnyObject] else { return }
            let date = data["data"] as? String
            self.dateField.text = date
            if snap.hasChild("songUrl") {
                self.songIcon.image = UIImage(named: "tick")
            }
            if snap.hasChild("videoUrl") {
                self.videoIcon.image = UIImage(named: "tick")
            }
        })
    }
    
    // MARK: SETTING DATE
    
    @objc func setDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateField.text = formatter.string(from: datePicker.date)
    }
    
    // MARK: CHOOSING VIDEO
    
    @objc func uploadVideo() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.mediaTypes = [kUTTypeMovie as String]
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            video = videoUrl
            videoIcon.image = UIImage(named: "tick")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UPDATING DUE VERSION
    
    @objc func updateVersion() {
        if dateField.text != "" || video != nil {
            if dateField.text != "" {
                Database.database().reference().child("Codes").child(details.eventID!).child("video").updateChildValues(["data": dateField.text!])
            }
            if let videoUrl = video {
                showActivityIndicator(view: self.view, indicator: self.indicator)
                Storage.storage().reference().child(details.eventID!).child("video").putFile(from: videoUrl, metadata: nil, completion: { (metadata, err) in
                    if err != nil {
                        print(err?.localizedDescription ?? "")
                        return
                    }
                    if let storageUrl = metadata?.downloadURL()?.absoluteString {
                        Database.database().reference().child("Codes").child(details.eventID!).child("video").updateChildValues(["videoUrl": storageUrl])
                        dismissActivityIndicator(view: self.view, indicator: self.indicator, completion: {
                            _ = SweetAlert().showAlert("Muito bem!", subTitle: "Versão atualizada", style: .success, buttonTitle: "Ok")
                        })
                    }
                })
            }
        }
    }
    
    // MARK: KEYBOARD METHODS
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
