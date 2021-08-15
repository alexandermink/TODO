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
    var userInterfaceStyle: UIUserInterfaceStyle = .dark
    
    var backgroundColor: UIColor = .clear
    var interfaceColor: UIColor = .clear
    var mainBackgroundImageName: String = ""
    var minorBackgroundImageName: String = ""
    var isFavouriteImageName = ""
    var isDoneImageName = ""
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
        switch state {
        case .Vitaliy:
            print("Vitaliy")
            theme.userInterfaceStyle = .dark
            theme.backgroundColor = UIColor.vitBackground
            theme.interfaceColor = UIColor.vitInterface
            theme.mainBackgroundImageName = "888"
            theme.minorBackgroundImageName = "def"
            theme.isFavouriteImageName = "star-0"
            theme.isDoneImageName = "done-0"
        case .Alexey:
            print("Alexey")
            theme.userInterfaceStyle = .light
            theme.backgroundColor = UIColor.alexeyBackground
            theme.interfaceColor = UIColor.alexeyInterface
            theme.mainBackgroundImageName = "boat2"
            theme.minorBackgroundImageName = "def"
            theme.isFavouriteImageName = "star-1"
            theme.isDoneImageName = "done-1"
        case .Alexander:
            print("Alexander")
            theme.userInterfaceStyle = .dark
            theme.backgroundColor = UIColor.alexanderBackground
            theme.interfaceColor = UIColor.alexanderInterface
            theme.mainBackgroundImageName = "Alex_layer1"
            theme.minorBackgroundImageName = "Alex_layer2"
            theme.isFavouriteImageName = "star-2"
            theme.isDoneImageName = "done-2"
        }
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
        UIApplication.shared.windows.first?.applyGradient(colours: [theme.backgroundColor, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        print("backgroundColor = ", theme.backgroundColor, ", interfaceColor = ", theme.interfaceColor)
    }
}
