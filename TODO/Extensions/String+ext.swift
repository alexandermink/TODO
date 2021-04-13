//
//  String+ext.swift
//  TODO
//
//  Created by Vit K on 31.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import Foundation

extension String {
    static func dateConverter(unixTime: Double) -> String {
        let timeInterval  = unixTime
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMMM yyyy HH:mm:a"
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension Date { // для локализации времени (оно приходит по всему миру в базовом часовом поясе)
    func localString(dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .short) -> String {
        return DateFormatter.localizedString(from: self, dateStyle: dateStyle, timeStyle: timeStyle)
    }
}
