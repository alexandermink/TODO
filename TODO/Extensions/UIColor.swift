//
//  UIColor.swift
//  TODO
//
//  Created by Vit K on 07.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    static let backgroundColor = UIColor.rgb(r: 31, g: 33, b: 36)
    static let darkBrown = UIColor.rgb(r: 79, g: 52, b: 11)
}
