//
//  SwitchBtn.swift
//  Due
//
//  Created by Lucas Andrade on 10/9/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class SwitchBtn: UIView {
    
    let ball: UIView = {
        let vi = UIView()
        vi.frame.size = CGSize(width: 27, height: 27)
        vi.layer.cornerRadius = 13.5
        vi.backgroundColor = .white
        return vi
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        isUserInteractionEnabled = true
        addSubview(ball)
        ball.frame.origin = CGPoint(x: 3, y: 2)
        
    }
    
    func moveBall() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.ball.frame.origin.x = 21
            self.backgroundColor = .green
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
