//
//  AddButtonCheckListTableViewCell.swift
//  TODO
//
//  Created by Александр Минк on 06.05.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class AddButtonCheckListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addCheckListButton: UIButton!
    @IBOutlet weak var plusCheckListButton: UIButton!
    
    var indexPath: IndexPath = IndexPath()
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        addCheckMark()
        titleTextField.isHidden = true
        addCheckListButton.isHidden = true
        plusCheckListButton.isHidden = false
        titleTextField.text = ""
    }
    
    @IBAction func plusButtonAction(_ sender: UIButton) {
        addCheckListButton.isHidden = false
        titleTextField.isHidden = false
        addCheckListButton.isHidden = false
        plusCheckListButton.isHidden = true
        titleTextField.becomeFirstResponder()
    }
    
    func addCheckMark() {
        
        let id = (Main.instance.tempCheckList.max()?.id ?? 0) + 1
        let title = titleTextField.text ?? ""
        
        Main.instance.tempCheckList.append(CheckMark(id: id, title: title, isMarkSelected: false))
        
    }
    
}
