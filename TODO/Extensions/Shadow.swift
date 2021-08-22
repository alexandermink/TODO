//
//  Shadow.swift
//  TODO
//
//  Created by Vit K on 08.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

 class Shadow: UIView { // класс для слоёв с тенью(вьюхам подписаться на него)
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    var shadowLayer: CAShapeLayer { // вычисляемая переменная
        return self.layer as! CAShapeLayer
    }
    
    
    @IBInspectable var color: UIColor = .red {
        didSet { self.updateColors() }
    }
    @IBInspectable var opacity: CGFloat = 1 {
        didSet { self.updateOpacity() }
    }
    @IBInspectable var radius: CGFloat = 7 {
        didSet { self.udateRadius() }
    }
    @IBInspectable var offset: CGSize = .zero {
        didSet { self.updateOffset() }
    }
    
  
        
    func updateColors() {
        self.shadowLayer.shadowColor = self.color.cgColor
    }
    func updateOpacity() {
        self.shadowLayer.shadowOpacity = Float(self.opacity)
    }
    func udateRadius() {
        self.shadowLayer.shadowRadius = self.radius
    }
    func updateOffset() {
        self.shadowLayer.shadowOffset = offset
    }
}
