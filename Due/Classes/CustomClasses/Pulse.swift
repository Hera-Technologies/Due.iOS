//
//  Pulse.swift
//  Due
//
//  Created by Lucas Andrade on 10/4/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class Pulse: CALayer {
    
    var group = CAAnimationGroup()
    var initialScale: Float = 0
    var nextPulse: TimeInterval = 0
    var animationDuration: TimeInterval = 1.5
    var radius: CGFloat = 200
    var pulses: Float = 1
    
    
    init(pulses: Float, radius: CGFloat, position: CGPoint) {
        super.init()
        
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.pulses = pulses
        self.position = position
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = radius 
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupAnimationGroup()
            DispatchQueue.main.async {
                self.add(self.group, forKey: "pulse")
            }
        }
        
    }
    
    func scaleAnimation() -> CABasicAnimation {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnim.fromValue = NSNumber(value: initialScale)
        scaleAnim.toValue = NSNumber(value: 1)
        scaleAnim.duration = animationDuration
        return scaleAnim
    }
    
    func opacityAnimation() -> CAKeyframeAnimation {
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.duration = animationDuration
        opacityAnim.values = [0.4, 0.8, 0]
        opacityAnim.keyTimes = [0, 0.3, 1]
        return opacityAnim
    }
    
    func setupAnimationGroup() {
        self.group = CAAnimationGroup()
        self.group.duration = animationDuration + nextPulse
        self.group.repeatCount = pulses
        let curve = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.group.timingFunction = curve
        self.group.animations = [scaleAnimation(), opacityAnimation()]
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
