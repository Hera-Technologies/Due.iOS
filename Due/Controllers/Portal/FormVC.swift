//
//  FormVC.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class FormVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
    }
    
    func setup() {
        let data: [String: String] = ["code": details.eventID!, "userEmail": details.email!]
        let params = data.stringFromHttpParameters()
        let url = "https://herasoft.com.br/form.html"
        if let requestURL = URL(string:"\(url)?\(params)") {
            let request = URLRequest(url: requestURL)
            let web = UIWebView(frame: view.frame)
            web.backgroundColor = .white
            view.addSubview(web)
            web.loadRequest(request)
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
}
