//
//  CheckListCell.swift
//  TODO
//
//  Created by Vit K on 28.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class CheckListCell: UITableViewCell {

    @IBOutlet weak var checkMarkButton: UIButton!    
    @IBOutlet weak var titleLabel: UILabel!
    
    public func configure() {
        let theme = Main.instance.themeService.getTheme()
        checkMarkButton.tintColor = theme.interfaceColor
        titleLabel.textColor = theme.interfaceColor
    }
}

