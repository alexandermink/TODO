//
//  String+ext.swift
//  TODO
//
//  Created by Vit K on 31.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import Foundation

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

//extension Date { // для локализации времени (оно приходит по всему миру в базовом часовом поясе)
//    func localString(dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .short) -> String {
//        return DateFormatter.localizedString(from: self, dateStyle: dateStyle, timeStyle: timeStyle)
//    }
//}
