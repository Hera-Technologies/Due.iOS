//
//  DiagonalView.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit
import Foundation

class DiagonalView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        
        let size = self.bounds.size
        let p1 = CGPoint(x: rect.minX, y: size.height)
        let p2 = CGPoint(x: p1.x, y: size.height * 0.4)
        let p3 = CGPoint(x: p1.x + size.width, y: size.height * 0.3)
        let p4 = CGPoint(x: rect.maxX, y: rect.maxY)
        
        // create the path
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.close()
        
        // fill the path
        UIColor.white.set()
        path.fill()
    }
}
