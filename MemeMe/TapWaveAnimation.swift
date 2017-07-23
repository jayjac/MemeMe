//
//  TapWaveAnimation.swift
//  MemeMe
//
//  Created by Jean-Yves Jacaria on 21/07/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit



//MARK: This struct contains the function that does the wave-like effect on the main screen
struct TapWaveAnimation {
    
    static let flickerLayer = CALayer()
    static let duration = 0.5
    static let totalDuration = 4.0
    static let beginTime = 1.5
    
    
    static func beginAnimation(on view: UIView) {
        view.layoutIfNeeded()
        let width = view.bounds.width
        let height = view.bounds.height
        flickerLayer.cornerRadius = 75
        flickerLayer.backgroundColor = UIColor(white: 0.0, alpha: 0.05).cgColor
        flickerLayer.frame = CGRect(x: width / 2 - 75.0, y: height / 2 - 75.0, width: 150.0, height: 150.0)
        view.layer.addSublayer(flickerLayer)
        let stretchAnimation = CABasicAnimation(keyPath: "transform.scale")
        stretchAnimation.fromValue = 0
        stretchAnimation.toValue = 5
        stretchAnimation.duration = duration
        stretchAnimation.fillMode = kCAFillModeBoth
        stretchAnimation.beginTime = beginTime
        
        let fadeoutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeoutAnimation.fromValue = 1.0
        fadeoutAnimation.toValue = 0.0
        fadeoutAnimation.duration = duration
        fadeoutAnimation.fillMode = kCAFillModeBoth
        fadeoutAnimation.beginTime = beginTime
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = totalDuration
        animationGroup.animations = [stretchAnimation, fadeoutAnimation]
        animationGroup.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false
        flickerLayer.add(animationGroup, forKey: "touch-wave")
    }
}
