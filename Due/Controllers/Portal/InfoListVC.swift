//
//  InfoListVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Firebase

fileprivate let cellID = "cell"

class InfoListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arr = [Info]()
    
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
        lbl.text = "Info"
        lbl.textColor = dark
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Black", size: 23)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let previousBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Anterior", for: UIControlState())
        btn.titleLabel!.font = UIFont(name: "Avenir-heavy", size: 18)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let addBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ChalkboardSE-Light", size: 30)
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
    
    let table: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.showsVerticalScrollIndicator = false
        tb.allowsSelection = true
        tb.separatorColor = linewhite
        return tb
    }()
    
    let hintImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "info")
        img.backgroundColor = .clear
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let hintMessage: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        Mantenha seus convidados informados!
        """
        lbl.textColor  = .lightGray
        lbl.textAlignment = .center
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir-Roman", size: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchInfo()
    }
    
    func setup() {
        
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(previousBtn)
        view.addSubview(addBtn)
        view.addSubview(line)
        view.addSubview(table)
        view.addSubview(hintImg)
        view.addSubview(hintMessage)
        
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
        
        previousBtn.bottomAnchor.constraint(equalTo: line.topAnchor).isActive = true
        previousBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        previousBtn.addTarget(self, action: #selector(previousScreen), for: .touchUpInside)
        
        addBtn.bottomAnchor.constraint(equalTo: line.topAnchor, constant: 3).isActive = true
        addBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addBtn.addTarget(self, action: #selector(addInfo), for: .touchUpInside)
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        
        table.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        table.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.dataSource = self
        table.delegate = self
        table.register(InfoCell.self, forCellReuseIdentifier: cellID)
        table.estimatedRowHeight = 44
        table.rowHeight = UITableViewAutomaticDimension
        table.tableFooterView = UIView()
        
        hintImg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintImg.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hintImg.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        hintImg.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        
        hintMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hintMessage.topAnchor.constraint(equalTo: hintImg.bottomAnchor, constant: 18).isActive = true
        hintMessage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
    }
    
    @objc func addInfo() {
        let vc = EditInfoVC(titulo: "", message: "", childID: "")
        present(vc, animated: true, completion: nil)
    }
    
    @objc func previousScreen() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func goBack() {
        self.navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
    }
    
    func fetchInfo() {
        let ref = Database.database().reference().child("Codes").child(details.eventID!).child("evento")
        ref.child("info").observe(.value, with: { (snap) in
            self.arr = []
            if let infos = snap.children.allObjects as? [DataSnapshot] {
                for info in infos {
                    if let data = info.value as? [String: AnyObject] {
                        let inf = Info(childID: info.key, postData: data)
                        self.arr.append(inf)
                    }
                }
            }
            DispatchQueue.main.async(execute: {
                self.table.reloadData()
                self.hideHints()
            })
        })
    }
    
    func hideHints() {
        if arr.count > 0 {
            hintImg.isHidden = true
            hintMessage.isHidden = true
        } else {
            hintImg.isHidden = false
            hintMessage.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! InfoCell
        cell.otherVC = self
        cell.selectionStyle = .none
        let inf = arr[indexPath.row]
        cell.configureCell(info: inf)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! InfoCell
        let child = cell.model.childID
        let msg = cell.message.text
        let tlt = cell.titulo.text
        let vc = EditInfoVC(titulo: tlt!, message: msg!, childID: child)
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let childID = arr[indexPath.row].childID
            Database.database().reference().child("Codes").child(details.eventID!).child("evento").child("info").child(childID).removeValue()
            arr.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            hideHints()
        }
    }
    
}
