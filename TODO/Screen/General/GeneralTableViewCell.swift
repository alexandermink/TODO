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
    
    @IBOutlet weak var isFavoriteImage: UIImageView!
    @IBOutlet weak var isDoneImage: UIImageView!
    
    
    public func configure() {
        let theme = Main.instance.themeService.getTheme()
        notificationLabel.textColor = .black
        notificationLabel.backgroundColor = theme.interfaceColor
        checkProgressBar.tintColor = theme.interfaceColor
    }
}
