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
        
        let themes = SettingsCategory(name: "Внешний вид", settingsFields: [
            SettingsField(name: "Выбор темы", state: nil, picture: "sun.min", isDisclosure: true)
        ])
        
        let some = SettingsCategory(name: "Some", settingsFields: [
            SettingsField(name: "что-то", state: nil, picture: "", isDisclosure: false)
        ])
        
        return [themes, some]
    }
}
