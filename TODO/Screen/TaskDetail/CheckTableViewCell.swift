//
//  CheckTableViewCell.swift
//  TODO
//
//  Created by Алексей Мальков on 29.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {

    var checkListItemTextField = UITextField()
    var checkMarkButton =  UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        uiSetUp()
        
        constrainsInit()
        
        changeTheme()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiSetUp(){
        
        checkListItemTextField.translatesAutoresizingMaskIntoConstraints = false
        checkListItemTextField.font = UIFont(name: "HelveticaNeue", size: 17)
        checkListItemTextField.textColor = .systemYellow
        checkListItemTextField.keyboardAppearance = .dark
        checkListItemTextField.adjustsFontSizeToFitWidth = true
        contentView.addSubview(checkListItemTextField)
        
        checkMarkButton.translatesAutoresizingMaskIntoConstraints = false
        checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        checkMarkButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 10)
        checkMarkButton.tintColor = .systemYellow
        contentView.addSubview(checkMarkButton)

    }
    
    func constrainsInit(){
        NSLayoutConstraint.activate([
            checkListItemTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkListItemTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 50),
            checkListItemTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 4),
            
            checkMarkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkMarkButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            ])
    }
    
    func changeTheme() {
        let theme = Main.instance.themeService.getTheme()
        checkMarkButton.tintColor = theme.interfaceColor
        checkListItemTextField.textColor = theme.interfaceColor
    }
    
}
