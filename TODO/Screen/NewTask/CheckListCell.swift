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
    
    var rowText = "test777"
    var isMarkSelected = false
    var attributeString: NSMutableAttributedString? = nil
    var attributeString2: NSMutableAttributedString? = nil
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        attributeString = NSMutableAttributedString(string: rowText)
        attributeString!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 4, range: NSMakeRange(0, attributeString!.length))
        attributeString2 = NSMutableAttributedString(string: rowText)
        attributeString2!.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString2!.length))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func checkMarkButtonAction(_ sender: Any) {
        isMarkSelected ? checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal) : checkMarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
//        checkListItemTextField.attributedText = attributeString
        titleLabel.attributedText = isMarkSelected ? attributeString2 : attributeString
        
        
        
        isMarkSelected.toggle()
    }
}
