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
//        contentView.frame = CGRect(x: 0, y: 0, width: width, height: 20)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = CGSize(width: 3, height: 13)
//        let lbl = UILabel(frame: CGRect(x: 15, y: 5, width: contentView.frame.width - 10, height: 20))
//        lbl.textAlignment = .center
//        lbl.font = UIFont.boldSystemFont(ofSize: 17)
//        lbl.textColor = .vitBackground
//        lbl.text = text
//        contentView.addSubview(lbl)
        
        switch theme {
        case "1":
            contentView.backgroundColor = .systemYellow
        case "2":
            contentView.backgroundColor = .alexeyBackground
        case "3":
            contentView.backgroundColor = .red
        default:
            break
        }
    }

}
