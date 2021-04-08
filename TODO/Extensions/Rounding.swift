//
//  Rounding.swift
//  TODO
//
//  Created by Vit K on 08.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

 class Rounding: UIView {
    
    override class var layerClass: AnyClass {
          return CAShapeLayer.self
      }
      var roundedLayer: CAShapeLayer {
          return self.layer as! CAShapeLayer
      }

    
    @IBInspectable var color: UIColor = .lightGray {
           didSet { self.updateColors() }
       }
    @IBInspectable var borderWidth: CGFloat = 3 {
        didSet { self.updateWidth() }
    }
    @IBInspectable var radius: CGFloat = 25 {
        didSet { self.udateRadius() }
    }
    
    
    
    func updateColors() {
        self.roundedLayer.borderColor = self.color.cgColor
    }
    func updateWidth() {
        self.roundedLayer.borderWidth = self.borderWidth
    }
    func udateRadius() {
        self.roundedLayer.cornerRadius = self.radius
    }
 }
