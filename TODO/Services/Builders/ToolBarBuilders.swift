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
        let doneBtn: [NSAttributedString.Key: Any]
        doneBtn = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: textSize),
         NSAttributedString.Key.foregroundColor: UIColor.systemYellow]
        return doneBtn
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
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .normal)
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size2)), for: .highlighted)
        deleteButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .normal)
        deleteButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size2)), for: .highlighted)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, deleteButton, doneButton], animated: true)
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
    
    func makeToolBarTaskName() -> UIToolbar {
        let toolBar = ToolBarBuilder.configDoneButton()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(NewTaskViewController.dismissKeyboard))
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .normal)
        doneButton.setTitleTextAttributes(ToolBarBuilder.setAttributedString(textSize: CGFloat(ToolBarBuilder.size1)), for: .highlighted)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        return toolBar
    }
    
    
}
