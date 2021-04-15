//
//  ParalaxEffect.swift
//  TODO
//
//  Created by Vit K on 15.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class ParalaxEffect {
    static func paralaxEffect(view: UIView, magnitude: Double) {
        let xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xAxis.minimumRelativeValue = -magnitude
        xAxis.maximumRelativeValue = magnitude
        
        let yAxis = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yAxis.minimumRelativeValue = -magnitude
        yAxis.maximumRelativeValue = magnitude
        
        let effectGroup = UIMotionEffectGroup()
        effectGroup.motionEffects = [xAxis, yAxis]
        
        view.addMotionEffect(effectGroup)
    }
}
