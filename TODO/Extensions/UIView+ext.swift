//
//  UIView+ext.swift
//  TODO
//
//  Created by Vit K on 07.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

extension UIView {
    func applyGradient(colours: [UIColor], startX: Double, startY: Double, endX: Double, endY: Double) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.startPoint = CGPoint(x: startX, y: startY)
        gradient.endPoint = CGPoint(x: endX, y: endY)
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
