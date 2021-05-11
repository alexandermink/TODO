//
//  ToolBarBuilders.swift
//  TODO
//
//  Created by Vit K on 02.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class ToolBarBuilder {
    
    static let size1 = 22
    static let size2 = 18
    
    static func setAttributedString(textSize: CGFloat) -> [NSAttributedString.Key: Any]{
        let doneButton: [NSAttributedString.Key: Any]
        doneButton = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: textSize),
         NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        return doneButton
    }
    
    static func configDoneButton() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
}

extension UIViewController {
    
    func makeToolBarCategories() -> UIToolbar {
        let toolBar = ToolBarBuilder.configDoneButton()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(NewTaskViewController.chooseCategoryAction))
        let deleteButton = UIBarButtonItem(title: "Удалить", style: .done, target: self, action: #selector(NewTaskViewController.deleteCategoryAction))
        let keyboard = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "keyboard24"), style: .done, target: self, action: #selector(NewTaskViewController.changePickerAndKeyboard))
        keyboard.tintColor = .lightGray        
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .normal)
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size2)), for: .highlighted)
        deleteButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .normal)
        deleteButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size2)), for: .highlighted)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([deleteButton, flexSpace, keyboard, flexSpace, doneButton], animated: true)
        return toolBar
    }
    
    func makeToolBarNotifications() -> UIToolbar {
        let toolBar = ToolBarBuilder.configDoneButton()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(NewTaskViewController.chooseNotificationAction))
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .normal)
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .highlighted)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        return toolBar
    }
    
    func makeToolBarNotificationsDetail() -> UIToolbar {
        let toolBar = ToolBarBuilder.configDoneButton()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(TaskDetailViewController.chooseNotificationAction))
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .normal)
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .highlighted)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        return toolBar
    }
    
    func makeToolBarCategory() -> UIToolbar {
        let toolBar = ToolBarBuilder.configDoneButton()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(NewTaskViewController.changePickerAndKeyboard))
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .normal)
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .highlighted)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        return toolBar
    }
    
    
}
