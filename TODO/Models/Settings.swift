//
//  Settings.swift
//  TODO
//
//  Created by Vit K on 26.05.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import Foundation

struct SettingsCategory {
    let name: String
    let settingsFields: [SettingsField]
}

struct SettingsField {
    let name: String
    let state: Bool?
    let picture: String?
    let isDisclosure: Bool
}

final class SettingsFactory {
    static func makeSetting() -> [SettingsCategory] {
        
        let themes = SettingsCategory(name: "Темы", settingsFields: [
            SettingsField(name: "Тема 1", state: nil, picture: "sun.min", isDisclosure: true),
            SettingsField(name: "Тема 2", state: nil, picture: "cloud.sun.fill", isDisclosure: true),
            SettingsField(name: "Тема 3", state: nil, picture: "cloud.sun.bolt", isDisclosure: true)
        ])
        
        let some = SettingsCategory(name: "Some", settingsFields: [
            SettingsField(name: "что-то", state: nil, picture: "", isDisclosure: false)
        ])
        
        return [themes, some]
    }
}
