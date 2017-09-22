//
//  FaqVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

fileprivate let cellID = "cell"

class FaqVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arr = [[String: String]]()
    
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
        lbl.text = "Dúvidas frequentes"
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
        tb.allowsSelection = false
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        setupTexts()
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
        table.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        table.dataSource = self
        table.delegate = self
        table.register(QuestionsCell.self, forCellReuseIdentifier: cellID)
        table.estimatedRowHeight = 44.0
        table.rowHeight = UITableViewAutomaticDimension
        table.separatorColor = linewhite
        
    }
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setupTexts() {
        
        let dic1 = ["question": "O que é?", "answer": "Due é uma plataforma voltada para casamentos. Nosso objetivo é hospedar diversos eventos pelo Brasil e pelo mundo. Cada casamento possui uma versão Due diferente, acessível através de um nome ou número que lhe é atribuído pelos próprios noivos."]
        
        let dic2 = ["question": "Como obter uma versão Due?", "answer": "Basta fazer o login e clicar em criar evento para adquirir uma versão Due dedicada ao seu casamento. Simplificamos ao máximo o processo de aquisição para que em poucos minutos vocês possam ter uma versão própria : )"]
        
        let dic3 = ["question": "Quais são as features?", "answer": "Estamos sempre buscando inovar e acrescentar novas features na nossa plataforma, mas desde já, o app oferece diversas funcionalidades, como os feeds de fotos e mensagens, cotas de Lua de Mel, trailer e fotos do pré casamento, informações sobre a cerimônia e muito mais!"]
        
        let dic4 = ["question": "Por que criar uma conta?", "answer": "Queremos que os noivos se sintam seguros ao utilizar nosso app, por isso pedimos que todos os usuários efetuem o cadastro para que possamos identificá-los. Obs: Não se preocupe, também não gostamos de spam. Seu email está seguro conosco."]
        
        let dic5 = ["question": "Convidados precisam pagar?", "answer": "Não. Convidados podem acessar eventos e interagir dentro deles gratuitamente. Basta saber o código do evento."]
        
        arr = [dic1, dic2, dic3, dic4, dic5]
        
    }
    
    // MARK: TABLE VIEW DELEGATE AND DATA SOURCE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! QuestionsCell
        let questions = arr.map{$0["question"]}
        let answers = arr.map{$0["answer"]}
        cell.label.text = questions[indexPath.row]
        cell.message.text = answers[indexPath.row]
        return cell
    }
    
    // MARK: TABLE VIEW CELL
    
    class QuestionsCell: UITableViewCell {
        
        let label: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.textColor = darker
            lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
            lbl.lineBreakMode = .byWordWrapping
            lbl.numberOfLines = 2
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
            
            self.backgroundColor = .white
            addSubview(label)
            addSubview(message)
            
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
            message.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
            message.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            message.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
            message.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}


