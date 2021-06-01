//
//  HeaderView.swift
//  TODO
//
//  Created by Vit K on 21.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    public func configure(theme: String, sameColorView: UIView?) {
        let theme = Main.instance.themeService.getTheme()
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = CGSize(width: 3, height: 13)
        
        contentView.backgroundColor = theme.interfaceColor
        
//        switch theme {
//        case "1":
//            contentView.backgroundColor = .systemYellow
//        case "2":
//            contentView.backgroundColor = .alexeyBackground
//        case "3":
//            contentView.backgroundColor = .red
//        default:
//            break
//        }
    }

}
