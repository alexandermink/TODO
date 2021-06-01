//
//  ThemeService.swift
//  TODO
//
//  Created by Александр Минк on 01.06.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

public enum ThemeState: Int {
    case Vitaliy
    case Alexey
    case Alexander
}

struct Theme {
    var backgroundColor: UIColor = .clear
    var interfaceColor: UIColor = .clear
}

class ThemeService {
    
    //Получаем переменную через getTheme()
    private var theme: Theme = Theme()
    
    private var state: ThemeState {
        get {ThemeState(rawValue: UserDefaults.standard.integer(forKey: "themeState")) ?? ThemeState(rawValue: 0)!}
        set {UserDefaults.standard.set(newValue.rawValue, forKey: "themeState")}
    }
    
    func getTheme() -> Theme {
        return theme
    }
    
    func getState() -> ThemeState {
        return state
    }
    
    init() {
        updateTheme()
    }
    
    func changeState(state: ThemeState) {
        self.state = state
        updateTheme()
    }
    
    private func updateTheme() {
        var userInterfaceStyle: UIUserInterfaceStyle = .dark
        switch state {
        case .Vitaliy:
            print("Vitaliy")
            userInterfaceStyle = .light
            theme.backgroundColor = UIColor.vitBackground
            theme.interfaceColor = UIColor.vitInterface
        case .Alexey:
            print("Alexey")
            userInterfaceStyle = .light
            theme.backgroundColor = UIColor.alexeyBackground
            theme.interfaceColor = UIColor.alexeyInterface
        case .Alexander:
            print("Alexander")
            userInterfaceStyle = .dark
            theme.backgroundColor = UIColor.alexanderBackground
            theme.interfaceColor = UIColor.alexanderInterface
        }
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = userInterfaceStyle
        }
        print("backgroundColor = ", theme.backgroundColor, ", interfaceColor = ", theme.interfaceColor)
        
        updateInterface()
    }
    
    //Функция под вопросом, возможно стоит проверять state при инициализации контроллеров
    private func updateInterface() {
        print("Заглушка")
    }
}
