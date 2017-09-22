//
//  DocsVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class DocsVC: UIViewController {
    
    var page: String?
    
    init(webpage: String) {
        super.init(nibName: nil, bundle: nil)
        page = webpage
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("x", for: .normal)
        btn.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 28)
        btn.setTitleColor(dark, for: UIControlState())
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let web = UIWebView(frame: view.frame)
        view.addSubview(web)
        if let webpage = page {
            if let url = URL(string: webpage) {
                web.loadRequest(URLRequest(url: url))
            }
        }
        
        view.addSubview(closeBtn)
        closeBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
}


