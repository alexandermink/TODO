//
//  DropsData.swift
//  TODO
//
//  Created by Vit K on 22.08.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit
//import Drops

class DropsData {
    
    let isFirstStart = UserDefaults.standard.bool(forKey: "isFirstStart")
    
    func makeGreatingDrop() {
        if !isFirstStart {
            
//            let tit = UILabel
            
            let dropFirst = Drop(title: "Приветствуем!", subtitle: "Надеемся Вам понравиться пользоваться приложением Memo It!", icon: UIImage(systemName: "hand.raised"), action: .init(handler: {
                Drops.hideCurrent()
            }), position: .top, duration: 3.0)
            let dropSecond = Drop(title: "", subtitle: "Ознакомиться с функционалом приложения можно в разделе 'Настройки', в меню 'Обучение'", action: .init(handler: {
                Drops.hideCurrent()
            }), position: .top, duration: 16.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                Drops.show(dropFirst)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    Drops.show(dropSecond)
                    
                }
            }
        }
    }
}
