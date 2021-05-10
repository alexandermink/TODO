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
    
    var rowText = "your check task"
    var isMarkSelected = false
    var attributeString: NSMutableAttributedString? = nil
    var attributeString2: NSMutableAttributedString? = nil
    private var currentTheme : String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        uiSetUp()
        
        constrainsInit()
        
        changeState(state: Main.instance.state ?? "1")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiSetUp(){
        checkListItemTextField.translatesAutoresizingMaskIntoConstraints = false
        checkListItemTextField.font = UIFont(name: "HelveticaNeue", size: 17)
        checkListItemTextField.textColor = .black
        contentView.addSubview(checkListItemTextField)
        
        checkMarkButton.translatesAutoresizingMaskIntoConstraints = false
        checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        checkMarkButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 10)
        contentView.addSubview(checkMarkButton)
        checkMarkButton.addTarget(self,
                             action: #selector(checkMarkButtonAction),
                             for: .touchUpInside)
        
        attributeString = NSMutableAttributedString(string: rowText)
        attributeString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 4, range: NSMakeRange(0, attributeString!.length))
        attributeString2 = NSMutableAttributedString(string: rowText)
        attributeString2!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString2!.length))
    }
    
    func constrainsInit(){
        NSLayoutConstraint.activate([
            checkListItemTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkListItemTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 50),
            
            checkMarkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkMarkButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func checkMarkButtonAction(_ sender: Any) {
        isMarkSelected ? checkMarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) : checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        checkListItemTextField.attributedText = isMarkSelected ? attributeString : attributeString2
        
        isMarkSelected.toggle()
    }
    
    func changeState(state: String) {
        self.currentTheme = state
        switch Main.instance.state {
        case "1":
            checkMarkButton.tintColor = .systemYellow
        case "2":
            checkMarkButton.tintColor = .alexeyBackground
        case "3":
            checkMarkButton.tintColor = .alexDarkRed
        default:
            break
        }
    }
    
}
