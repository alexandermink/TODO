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
    
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//extension Numeric {
//    var data: Data {
//        var bytes = self
//        return Data(bytes: &bytes, count: MemoryLayout<Self>.size)
//    }
//}
//extension Data {
//    func object<T>() -> T { withUnsafeBytes{$0.load(as: T.self)} }
//    var color: UIColor { .init(data: self) }
//}
//extension UIColor {
//    convenience init(data: Data) {
//        let size = MemoryLayout<CGFloat>.size
//        self.init(red:   data.subdata(in: size*0..<size*1).object(),
//                  green: data.subdata(in: size*1..<size*2).object(),
//                  blue:  data.subdata(in: size*2..<size*3).object(),
//                  alpha: data.subdata(in: size*3..<size*4).object())
//    }
//    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
//        var (red, green, blue, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
//        return getRed(&red, green: &green, blue: &blue, alpha: &alpha) ?
//        (red, green, blue, alpha) : nil
//    }
//    var data: Data? {
//        guard let rgba = rgba else { return nil }
//        return rgba.red.data + rgba.green.data + rgba.blue.data + rgba.alpha.data
//    }
//}
//extension UserDefaults {
//    func set(_ color: UIColor?, forKey defaultName: String) {
//        guard let data = color?.data else {
//            removeObject(forKey: defaultName)
//            return
//        }
//        set(data, forKey: defaultName)
//    }
//    func color(forKey defaultName: String) -> UIColor? {
//        data(forKey: defaultName)?.color
//    }
//}
//extension UserDefaults {
//    var backgroundColor: UIColor? {
//        get { color(forKey: "backgroundColor") }
//        set { set(newValue, forKey: "backgroundColor") }
//    }
//}

//extension UserDefaults {
//
//    func color(forKey key: String) -> UIColor? {
//
//        guard let colorData = data(forKey: key) else { return nil }
//
//        do {
//            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
//        } catch let error {
//            print("color error \(error.localizedDescription)")
//            return nil
//        }
//
//    }
//
//    func set(_ value: UIColor?, forKey key: String) {
//
//        guard let color = value else { return }
//        do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
//            set(data, forKey: key)
//        } catch let error {
//            print("error color key data not saved \(error.localizedDescription)")
//        }
//
//    }
//
//}

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
