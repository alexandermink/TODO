//
//  ToolBar.swift
//  TODO
//
//  Created by Vit K on 25.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class ToolBar {
    
    static func setAttributedString(textSize: CGFloat) -> [NSAttributedString.Key: Any]{
        let doneBtn: [NSAttributedString.Key: Any]
        doneBtn = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: textSize),
         NSAttributedString.Key.foregroundColor: UIColor.systemIndigo]
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
    
    func createToolBarCategories() -> UIToolbar {
        let toolBar = ToolBar.configDoneButton()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(NewTaskViewController.toolBarDoneAction))
        let deleteButton = UIBarButtonItem(title: "Удалить", style: .done, target: self, action: #selector(NewTaskViewController.toolBarDeleteAction))
        doneButton.setTitleTextAttributes(ToolBar.setAttributedString(textSize: 22), for: .normal)
        doneButton.setTitleTextAttributes(ToolBar.setAttributedString(textSize: 18), for: .highlighted)
        deleteButton.setTitleTextAttributes(ToolBar.setAttributedString(textSize: 22), for: .normal)
        deleteButton.setTitleTextAttributes(ToolBar.setAttributedString(textSize: 18), for: .highlighted)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, deleteButton, doneButton], animated: true)
        return toolBar
    }
}
