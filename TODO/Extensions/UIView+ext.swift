//
//  UIView+ext.swift
//  TODO
//
//  Created by Vit K on 07.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

extension UIView {
    func applyGradient(colours: [UIColor], startX: Double, startY: Double, endX: Double, endY: Double){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.startPoint = CGPoint(x: startX, y: startY)
        gradient.endPoint = CGPoint(x: endX, y: endY)
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        if let oldGradientLayer = layer.sublayers?.compactMap({ $0 as?  CAGradientLayer }).first {
            self.layer.replaceSublayer(oldGradientLayer, with: gradient)
        } else {
            self.layer.insertSublayer(gradient, at: 0)
        }        
    }
    
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }

    var topSuperview: UIView? {
        var view = superview
        while view?.superview != nil {
            view = view!.superview
        }
        return view
    }

    @objc func dismissKeyboard() {
        topSuperview?.endEditing(true)
    }
}
