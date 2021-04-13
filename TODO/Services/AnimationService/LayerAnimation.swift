//
//  LayerAnimation.swift
//  TODO
//
//  Created by Vit K on 11.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

//class LayerAnimation {
//    func setLayerAnimation(path: UIBezierPath, view: UIView, lineWidth: CGFloat, shadowColor: CGColor, strokeColor: CGColor, fillColor: CGColor, lineSizeFrom: CGFloat, lineSizeTo: CGFloat, duration: Double) {
//        let layer = CAShapeLayer()
//        layer.path = path.cgPath
//        layer.strokeEnd = 0
//        layer.lineWidth = lineWidth
////        layer.shadowColor = shadowColor
////        layer.shadowRadius = 10
////        layer.shadowOffset = CGSize(width: 1, height: 1)
////        layer.shadowOpacity = 0.8
//        layer.strokeColor = strokeColor
//        layer.fillColor = fillColor
//        layer.lineCap = .round
//
//        view.layer.addSublayer(layer)
//
//        let animation = CABasicAnimation(keyPath: "strokeStart")
//        animation.fromValue = 0
//        animation.toValue = 1
//
//        let animationEnd = CABasicAnimation(keyPath: "strokeEnd")
//        animationEnd.fromValue = lineSizeFrom // чтобы длина обводки не росла - цифры после запятой - одинаковые
//        animationEnd.toValue = lineSizeTo // длина обводки например 0.002 - маленькая, 0.5 - в половину всего пути
//
//        let animationGroup = CAAnimationGroup()
//        animationGroup.duration = duration
//        animationGroup.repeatCount = .infinity
//        animationGroup.animations = [animation, animationEnd]
//
//        layer.add(animationGroup, forKey: "line")
//    }
//}
