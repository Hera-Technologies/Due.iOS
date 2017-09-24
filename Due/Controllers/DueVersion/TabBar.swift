//
//  TabBar.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//


import UIKit

class TabBar: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let one = FirstVC()
        let navOne = UINavigationController(rootViewController: one)
        navOne.title = "Principal"
        navOne.tabBarItem.image = UIImage(named: "infinity")
        
        let two = SecondVC()
        two.title = "Padrinhos"
        two.tabBarItem.image = UIImage(named: "love")
        
        let three = ThirdVC()
        let navThree = UINavigationController(rootViewController: three)
        navThree.title = "Casamento"
        navThree.tabBarItem.image = UIImage(named: "home")
        
        let four = FourthVC()
        let navFour = UINavigationController(rootViewController: four)
        navFour.title = "Presentes"
        navFour.tabBarItem.image = UIImage(named: "present")
        
        viewControllers = [navOne, two, navThree, navFour]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.selectedIndex = 0
    }
    
}
