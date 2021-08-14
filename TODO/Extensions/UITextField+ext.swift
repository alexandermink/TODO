//
//  UITextField+ext.swift
//  TODO
//
//  Created by Александр Минк on 14.08.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

extension UITextField {
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
