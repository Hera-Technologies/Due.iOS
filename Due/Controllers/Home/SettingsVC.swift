//
//  SettingsVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FBSDKLoginKit

fileprivate let cellID = "cell"

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    let arr = ["Compartilhe o app", "FAQ", "Contato", "Termos de Uso", "Política de Privacidade", "Sair"]
    
    let logo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "gradicon")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
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
        lbl.text = "Menu"
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
        tb.separatorStyle = .none
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    let versionLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = """
        App versão 2.0
        2017 Hera Technologies
        """
        lbl.textColor = darker
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Avenir-Roman", size: 15)
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    func setup() {
        
        view.addSubview(logo)
        view.addSubview(backBtn)
        view.addSubview(viewTitle)
        view.addSubview(line)
        view.addSubview(table)
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 30).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: -3).isActive = true
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        viewTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        viewTitle.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 12).isActive = true
        
        line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        line.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        table.topAnchor.constraint(equalTo: line.bottomAnchor).isActive = true
        table.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        table.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        table.dataSource = self
        table.delegate = self
        table.register(MenuCell.self, forCellReuseIdentifier: cellID)
        
        let footer = UIView()
        footer.addSubview(versionLbl)
        var lblY = CGFloat()
        let size = UIScreen.main.bounds.width
        if size <= 320 {
            lblY = view.frame.height * 0.15
        } else {
            lblY = view.frame.height * 0.2
        }
        versionLbl.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
        versionLbl.centerYAnchor.constraint(equalTo: footer.centerYAnchor, constant: lblY).isActive = true
        table.tableFooterView = footer
        
    }
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: TABLE VIEW DELEGATE AND DATA SOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MenuCell
        cell.labelBtn.text = arr[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuCell
        switch indexPath.row {
        case 0: animateCell(cell: cell, completion: { self.share() })
        case 1: animateCell(cell: cell, completion: { self.showFAQ() })
        case 2: animateCell(cell: cell, completion: { self.contactUs() })
        case 3: animateCell(cell: cell, completion: {
            self.showDocs(link: "https://herasoft.com.br/terms.html")
        })
        case 4: animateCell(cell: cell, completion: {
            self.showDocs(link: "https://herasoft.com.br/privacy.html")
        })
        default: animateCell(cell: cell, completion: { self.confirmLogout() })
        }
    }
    
    func animateCell(cell: MenuCell, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            cell.transform = CGAffineTransform.identity
        }) { (boo) in
            completion()
        }
    }
    
    // MARK: TABLE VIEW CELL METHODS
    
    func share() {
        let message = """
        Baixe o app Due!
        
        https://play.google.com/store/apps/details?id=com.herasoft.due
        
        https://itunes.apple.com/br/app/due/id1221772362?l=en&mt=8
        """
        let actionSheet = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        actionSheet.popoverPresentationController?.sourceView = self.view
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showFAQ() {
        navigationController?.pushViewController(FaqVC(), animated: true)
    }
    
    func contactUs() {
        let alert = UIAlertController()
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        let hate = UIAlertAction(title: "Não gostou de alguma coisa?", style: .default) { (action) in
            mailVC.setToRecipients(["contato@herasoft.com.br"])
            mailVC.setSubject("Defeitos")
            self.present(mailVC, animated: true, completion: nil)
        }
        let help = UIAlertAction(title: "Alguma dúvida?", style: .default) { (action) in
            mailVC.setToRecipients(["contato@herasoft.com.br"])
            mailVC.setSubject("Perguntas")
            self.present(mailVC, animated: true, completion: nil)
        }
        let bug = UIAlertAction(title: "Encontrou algum erro?", style: .default) { (action) in
            mailVC.setToRecipients(["contato@herasoft.com.br"])
            mailVC.setSubject("Bugs")
            self.present(mailVC, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(hate)
        alert.addAction(help)
        alert.addAction(bug)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error != nil {
            let alert = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showDocs(link: String) {
        let web = DocsVC(webpage: link)
        present(web, animated: true, completion: nil)
    }
    
    func confirmLogout() {
        let alert = UIAlertController(title: "", message: "Tem certeza que deseja sair?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "Sim", style: .default) { (_) in
            self.signout()
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    func signout() {
        let manager = FBSDKLoginManager()
        manager.logOut()
        do {
            try Auth.auth().signOut()
            let cadastro = InitialVC()
            self.present(cadastro, animated: true, completion: nil)
        } catch let logoutErr {
            print(logoutErr)
        }
    }
    
    // MARK: TABLE VIEW CELL
    
    class MenuCell: UITableViewCell {
        
        let labelBtn: UILabel = {
            let lbl = UILabel()
            lbl.textColor = .gray
            lbl.font = UIFont(name: "Avenir-Heavy", size: 22)
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: cellID)
            
            addSubview(labelBtn)
            labelBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
            labelBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

