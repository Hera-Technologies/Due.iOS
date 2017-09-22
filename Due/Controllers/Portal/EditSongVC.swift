//
//  EditSongVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

fileprivate let cellID = "cell"

class EditSongVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isPlaying = false
    var musicPlayer: AVPlayer?
    
    struct Song {
        var name: String
        var artist: String
        var duration: String
        var url: String
    }
    
    var songs = [Song]()
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let sendBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Enviar", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: 20)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let songImage:  NetworkImageView = {
        let img = NetworkImageView()
        img.image = #imageLiteral(resourceName: "song1")
        img.backgroundColor = linewhite
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let noteIcon:  NetworkImageView = {
        let img = NetworkImageView()
        img.image = #imageLiteral(resourceName: "note")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let line: UIView = {
        let vi = UIView()
        vi.backgroundColor = .white
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()
    
    let trackLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Book", size: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let playBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "playsong"), for: .normal)
        btn.backgroundColor = offwhite
        btn.layer.shadowColor = UIColor.darkGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        btn.layer.shadowRadius = 1.8
        btn.layer.shadowOpacity = 0.45
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let playlistLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Playlist"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let lineTwo: UIView = {
        let ln = UIView()
        ln.backgroundColor = linewhite
        ln.translatesAutoresizingMaskIntoConstraints = false
        return ln
    }()
    
    let table: UITableView = {
        let tb = UITableView()
        tb.backgroundColor = .clear
        tb.showsVerticalScrollIndicator = false
        tb.separatorStyle = .none
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSongs()
        view.backgroundColor = .white
        setup()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        musicPlayer?.pause()
    }
    
    func setup() {
        
        view.addSubview(closeBtn)
        view.addSubview(sendBtn)
        view.addSubview(songImage)
        view.addSubview(noteIcon)
        view.addSubview(line)
        view.addSubview(trackLbl)
        view.addSubview(playBtn)
        view.addSubview(playlistLbl)
        view.addSubview(lineTwo)
        view.addSubview(table)
        
        closeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        sendBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        sendBtn.centerYAnchor.constraint(equalTo: closeBtn.centerYAnchor, constant: 5).isActive = true
        sendBtn.addTarget(self, action: #selector(updateSong), for: .touchUpInside)
        
        songImage.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 30).isActive = true
        songImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        songImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        songImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive = true
        
        noteIcon.topAnchor.constraint(equalTo: songImage.topAnchor, constant: 10).isActive = true
        noteIcon.leftAnchor.constraint(equalTo: songImage.leftAnchor, constant: 12).isActive = true
        noteIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        noteIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        line.leftAnchor.constraint(equalTo: noteIcon.rightAnchor, constant: 12).isActive = true
        line.centerYAnchor.constraint(equalTo: noteIcon.centerYAnchor, constant: 0).isActive = true
        line.widthAnchor.constraint(equalToConstant: 1).isActive = true
        line.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        trackLbl.centerYAnchor.constraint(equalTo: noteIcon.centerYAnchor, constant: 0).isActive = true
        trackLbl.leftAnchor.constraint(equalTo: line.rightAnchor, constant: 15).isActive = true
        
        playBtn.bottomAnchor.constraint(equalTo: songImage.bottomAnchor, constant: 30).isActive = true
        playBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        playBtn.layer.cornerRadius = 30
        playBtn.addTarget(self, action: #selector(playPause), for: .touchUpInside)
        
        playlistLbl.leadingAnchor.constraint(equalTo: songImage.leadingAnchor, constant: 8).isActive = true
        playlistLbl.topAnchor.constraint(equalTo: playBtn.bottomAnchor, constant: 10).isActive = true
        
        lineTwo.leadingAnchor.constraint(equalTo: songImage.leadingAnchor, constant: 0).isActive = true
        lineTwo.topAnchor.constraint(equalTo: playlistLbl.bottomAnchor, constant: 3).isActive = true
        lineTwo.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lineTwo.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        table.leadingAnchor.constraint(equalTo: songImage.leadingAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        table.topAnchor.constraint(equalTo: lineTwo.bottomAnchor, constant: 0).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.dataSource = self
        table.delegate = self
        table.register(SongCell.self, forCellReuseIdentifier: cellID)
        table.tableFooterView = UIView()
        
        
        
    }
    
    @objc func updateSong() {
        if let indexPath = table.indexPathForSelectedRow {
            let cell = table.cellForRow(at: indexPath) as! SongCell
            guard let songUrl = cell.song?.url else { return }
            sendSongToDB(url: songUrl, completion: {
                self.close()
            })
        }
    }
    
    func sendSongToDB(url: String, completion: () -> Void) {
        Database.database().reference().child("Codes").child(details.eventID!).child("video").updateChildValues(["songUrl": url])
        completion()
    }
    
    func fetchSongs() {
        Database.database().reference().child("Music").observe(.value, with: { (snap) in
            self.songs = []
            if let songs = snap.children.allObjects as? [DataSnapshot] {
                for song in songs {
                    if let data = song.value as? [String: AnyObject] {
                        let url = data["songUrl"] as? String
                        let name = data["name"] as? String
                        let artist = data["artist"] as? String
                        let duration = data["duration"] as? String
                        let song = Song(name: name!, artist: artist!, duration: duration!, url: url!)
                        self.songs.append(song)
                    }
                }
            }
            self.table.reloadData()
        })
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func playPause() {
        if musicPlayer?.currentItem != nil {
            isPlaying = !isPlaying
            if isPlaying == true {
                playBtn.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
                musicPlayer?.play()
            } else {
                playBtn.setImage(#imageLiteral(resourceName: "playsong"), for: .normal)
                musicPlayer?.pause()
            }
        }
    }
    
    // MARK: TABLE VIEW DELEGATE AND DATA SOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SongCell
        let song = songs[indexPath.row]
        cell.song = song
        let arr = ["I.", "II.", "III."]
        cell.trackNumber.text = arr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.12
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SongCell
        trackLbl.text = cell.song?.name
        if let songUrl = cell.song?.url {
            guard let url = URL(string: songUrl) else { return }
            do {
                let item = AVPlayerItem(url: url)
                musicPlayer = AVPlayer(playerItem: item)
                musicPlayer?.play()
                isPlaying = true
                playBtn.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            }
        }
    }
    
    // MARK: TABLE VIEW CELL
    
    class SongCell: UITableViewCell {
        
        var song: Song? {
            didSet {
                guard let song = song else { return }
                songUrl = song.url
                trackName.text = song.name
                artist.text = song.artist
                duration.text = song.duration
            }
        }
        
        var songUrl: String?
        
        let trackNumber: UILabel = {
            let lbl = UILabel()
            lbl.textColor = .gray
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Avenir-Roman", size: 14)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let trackName: UILabel = {
            let lbl = UILabel()
            lbl.textColor = darker
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Avenir-Roman", size: 18)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let artist: UILabel = {
            let lbl = UILabel()
            lbl.textColor = .gray
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Avenir-Roman", size: 15)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let duration: UILabel = {
            let lbl = UILabel()
            lbl.textColor = .gray
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Avenir-Roman", size: 16)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: cellID)
            backgroundColor = .clear
            setup()
        }
        
        func setup() {
            
            addSubview(trackNumber)
            addSubview(trackName)
            addSubview(artist)
            addSubview(duration)
            
            trackNumber.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            trackNumber.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
            trackNumber.heightAnchor.constraint(equalToConstant: 18).isActive = true
            
            trackName.leftAnchor.constraint(equalTo: trackNumber.rightAnchor, constant: 15).isActive = true
            trackName.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
            
            artist.leftAnchor.constraint(equalTo: trackNumber.rightAnchor, constant: 18).isActive = true
            artist.topAnchor.constraint(equalTo: trackName.bottomAnchor, constant: 3).isActive = true
            
            duration.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            duration.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
