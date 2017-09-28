//
//  MessagesVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

fileprivate let cellID = "cell"

class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var messages = [Message]()
    var ownerID = String()
    
    let indicator: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.activityIndicatorViewStyle = .gray
        ind.color = .blue
        ind.hidesWhenStopped = true
        return ind
    }()
    
    let back: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("<", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let write: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "chat"), for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let viewTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Mensagens"
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
    
    let table: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.showsVerticalScrollIndicator = false
        tb.separatorColor = linewhite
        return tb
    }()
    
    // MARK: VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEventOwner()
        view.backgroundColor = .white
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        fetchMessages()
    }
    
    override func willMove(toParentViewController parent: UIViewController?){
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func fetchMessages() {
        indicator.startAnimating()
        Database.database().reference().child("Codes").child(eventModel.eventCode!).child("mensagens").queryOrdered(byChild: "timestamp").observe(.value, with: { (snap) in
            self.messages = []
            if let mensagens = snap.children.allObjects as? [DataSnapshot] {
                for message in mensagens {
                    if let data = message.value as? [String: AnyObject] {
                        let msg = Message(postID: message.key, postData: data)
                        self.messages.append(msg)
                    }
                }
            }
            DispatchQueue.main.async {
                self.table.reloadData()
                self.indicator.stopAnimating()
            }
        })
    }
    
    func fetchEventOwner() {
        Database.database().reference().child("Codes").child(eventModel.eventCode!).observeSingleEvent(of: .value, with: { (snap) in
            guard let dict = snap.value as? [String: AnyObject] else { return }
            self.ownerID = dict["user"] as! String
        })
    }
    
    func setup() {
        
        view.addSubview(indicator)
        view.addSubview(back)
        view.addSubview(write)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(table)
        
        indicator.center = view.center
        
        back.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        back.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        write.centerYAnchor.constraint(equalTo: back.centerYAnchor, constant: 5).isActive = true
        write.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        write.heightAnchor.constraint(equalToConstant: 38).isActive = true
        write.widthAnchor.constraint(equalToConstant: 38).isActive = true
        write.addTarget(self, action: #selector(writeMessage), for: .touchUpInside)
        
        let titleY = view.frame.height * 0.35
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -titleY).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        table.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        table.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 0).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.dataSource = self
        table.delegate = self
        table.register(MessageCell.self, forCellReuseIdentifier: cellID)
        table.estimatedRowHeight = 44
        table.rowHeight = UITableViewAutomaticDimension
        table.tableFooterView = UIView()
        
    }
    
    @objc func writeMessage() {
        let vc = MessageVC()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: TABLE VIEW DELEGATE AND DATA SOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessageCell
        cell.vc = self
        let mensagem = messages[indexPath.row]
        cell.configureCell(message: mensagem)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        if editingStyle == .delete {
            if userID == ownerID {
                let postID = messages[indexPath.row].postID
                Database.database().reference().child("Codes").child(eventModel.eventCode!).child("mensagens").child(postID!).removeValue()
                messages.remove(at: indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            } else {
                let alert = UIAlertController(title: "Acesso Restrito", message: "Somente os noivos têm acesso à esta área.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: TABLE VIEW CELL
    
    class MessageCell: UITableViewCell {
        
        var model: Message!
        var vc: MessagesVC?
        
        let profilePhoto: NetworkImageView = {
            let img = NetworkImageView()
            img.image = #imageLiteral(resourceName: "hint")
            img.contentMode = .scaleAspectFill
            img.clipsToBounds = true
            img.layer.cornerRadius = 20
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
        }()
        
        let username: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .left
            lbl.textColor = darker
            lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        let message: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .justified
            lbl.textColor = .darkGray
            lbl.font = UIFont(name: "Avenir-Roman", size: 15)
            lbl.numberOfLines = 0
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: cellID)
            
            addSubview(profilePhoto)
            addSubview(username)
            addSubview(message)
            
            profilePhoto.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
            profilePhoto.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
            profilePhoto.widthAnchor.constraint(equalToConstant: 40).isActive = true
            profilePhoto.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            username.leftAnchor.constraint(equalTo: profilePhoto.rightAnchor, constant: 12).isActive = true
            username.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor).isActive = true
            
            message.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 12).isActive = true
            message.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor, constant: 5).isActive = true
            message.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
            message.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
            
        }
        
        func configureCell(message: Message) {
            self.model = message
            self.username.text = message.name
            self.message.text = message.message
            if let photo = message.photo {
                self.profilePhoto.loadImageUsingCacheWithUrlString(photo)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}
