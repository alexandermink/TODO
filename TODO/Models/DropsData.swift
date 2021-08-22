//
//  DropsData.swift
//  TODO
//
//  Created by Vit K on 22.08.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit
import Drops

class DropsData {
    
    let isFirstStart777 = UserDefaults.standard.bool(forKey: "isFirstStart")
    
    func makeGreatingDrop() {
        if !isFirstStart777 {
            let dropFirst = Drop(title: "Приветствуем!", subtitle: "Это ознакомительный режим.", icon: UIImage(systemName: "hand.raised"), action: .init(handler: {
                Drops.hideCurrent()
            }), position: .top, duration: 3.0)
            let dropSecond = Drop(title: "", subtitle: "Ниже представлены ячейки, объясняющие основной функционал. После ознакомления все презентационные данные можно удалить в настройках и приступить к полноценному использованию приложения.", action: .init(handler: {
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
