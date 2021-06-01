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
//    static let vitBackground = UIColor.rgb(r: 31, g: 33, b: 36)
    static let vitBackground = UIColor.rgb(r: 79, g: 52, b: 11)
    static let vitDarkBrown = UIColor.rgb(r: 79, g: 52, b: 11)
    static let vitInterface = UIColor.systemYellow
    
    static let alexeyBackground = UIColor.rgb(r: 185, g: 196, b: 201)
    static let alexeyFog = UIColor.rgb(r: 185, g: 196, b: 201)
    static let alexeyInterface = UIColor.rgb(r: 82, g: 149, b: 139)
//    static let alexeyText = UIColor.rgb(r: 45, g: 200, b: 180)
    
    
    
    
    static let alexDarkRed = UIColor.rgb(r: 106, g: 26, b: 22)
    static let alexRed = UIColor.rgb(r: 130, g: 25, b: 16)
    static let alexDark = UIColor.rgb(r: 31, g: 31, b: 31)
    static let alexDarkGray = UIColor.rgb(r: 112, g: 112, b: 112)
    static let alexLightGray = UIColor.rgb(r: 212, g: 212, b: 212)
    
    static let alexanderBackground = UIColor.rgb(r: 31, g: 31, b: 31)
    static let alexanderInterface = UIColor.red
    
    
    
    static let mainBackground = UIColor.rgb(r: 31, g: 33, b: 36)
    
    
    
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var colorString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (colorString.hasPrefix("#")) {
            colorString.remove(at: colorString.startIndex)
        }

        if ((colorString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toString() -> String {
        let color = self.cgColor
        return CIColor(cgColor: color).stringRepresentation
    }
}

extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        if let colorData = data(forKey: key),
            let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        {
            return color
        } else {
            return nil
        }
    }

    // But why an Option<UIColor> here?
    func setColor(color: UIColor?, forKey key: String) {
        if let color = color,
            let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
        {
            set(colorData, forKey: key)
        }
    }
}
