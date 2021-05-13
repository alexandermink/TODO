//
//  AddButtonTableViewCell.swift
//  TODO
//
//  Created by Александр Минк on 23.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class AddButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var addFastTaskNameTextField: UITextField!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    var indexPath: IndexPath = IndexPath()
    var styleEditing = false
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        addFastTaskNameTextField.isHidden = false
        addButton.isHidden = false
        plusButton.isHidden = true
        addFastTaskNameTextField.becomeFirstResponder()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        config()
        addFastTaskNameTextField.isHidden = true
        addButton.isHidden = true
        plusButton.isHidden = false
        addFastTaskNameTextField.text = ""
    }
    
    func config() {
        let sectionName = Main.instance.userSession.tasks[indexPath.section].sectionName
        guard let name = addFastTaskNameTextField.text else { return }
        try? Main.instance.addTask(sectionName: sectionName, name: name, backgroundColor: .clear, taskDescription: "", notificationDate: "", checkList: [], markSelectedCount: 0)
    }
}
