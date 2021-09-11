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
        
        let interface = SettingsCategory(name: "Интерфейс", settingsFields: [
            SettingsField(name: "Выбор темы", state: nil, picture: "sun.min", isDisclosure: true)
        ])
        
        let social = SettingsCategory(name: "Обратная связь", settingsFields: [
            SettingsField(name: "Сайт проекта", state: nil, picture: "newspaper", isDisclosure: false),
            SettingsField(name: "О разработчиках", state: true, picture: "person.3", isDisclosure: true)
        ])
        

        let data = SettingsCategory(name: "Данные", settingsFields: [
            SettingsField(name: "Обучение", state: nil, picture: "info.circle", isDisclosure: true),
            SettingsField(name: "Очистить данные", state: nil, picture: "trash", isDisclosure: false)
            
        ])
        
        return [interface, social, data]
    }
}
