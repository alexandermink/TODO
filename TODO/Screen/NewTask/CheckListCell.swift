//
//  CheckListCell.swift
//  TODO
//
//  Created by Vit K on 28.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class CheckListCell: UITableViewCell {
    
    @IBOutlet weak var checkListItemTextField: UITextField!
    @IBOutlet weak var checkMarkButton: UIButton!
    

    var id: Int = -1
    var isMarkSelected: Bool = false
    var title: String = ""
    var strikedText: NSMutableAttributedString? = nil
    var normalText: NSMutableAttributedString? = nil
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkListItemTextField.text = title
        
        isMarkSelected ? checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal) : checkMarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        
        checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        strikedText = NSMutableAttributedString(string: checkListItemTextField.text ?? "")
        strikedText!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 4, range: NSMakeRange(0, strikedText!.length))
        normalText = NSMutableAttributedString(string: checkListItemTextField.text ?? "")
        normalText!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, normalText!.length))
        checkListItemTextField.addTarget(self, action: #selector(CheckListCell.textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        title = textField.text ?? ""
        
        for index in 0...Main.instance.tempCheckList.count - 1 {
            if id == Main.instance.tempCheckList[index].id {
                print("cell id:", id, " checkMarkid:", Main.instance.tempCheckList[index].id)
                Main.instance.tempCheckList[index].title = title
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func checkMarkButtonAction(_ sender: Any) {
        
        for index in 0...Main.instance.tempCheckList.count - 1 {
            if id == Main.instance.tempCheckList[index].id {
                Main.instance.tempCheckList[index].isMarkSelected = isMarkSelected
            }
        }
        
        isMarkSelected ? checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal) : checkMarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//        checkListItemTextField.attributedText = attributeString
        checkListItemTextField.attributedText = isMarkSelected ? normalText : strikedText
        
        isMarkSelected.toggle()
    }
}

