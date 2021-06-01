//
//  GeneralTableViewCell.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var checkProgressBar: UIProgressView!
    
    var styleEditing = true
    
    
    
    
    public func configure(theme: String) {
        let theme = Main.instance.themeService.getTheme()
        notificationLabel.textColor = theme.interfaceColor
        checkProgressBar.tintColor = theme.interfaceColor
        
        
//        switch theme {
//        case "1":
//            notificationLabel.textColor = .systemYellow
//            checkProgressBar.tintColor = .systemYellow
//        case "2":
//            notificationLabel.textColor = .alexeyBackground
//            checkProgressBar.tintColor = .alexeyBackground
//        case "3":
//            notificationLabel.textColor = .red
//            checkProgressBar.tintColor = .alexDarkRed
//        default:
//            break
//        }
    }
}
