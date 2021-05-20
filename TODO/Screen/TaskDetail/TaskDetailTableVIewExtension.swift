//
//  TaskDetailTableVIewExtension.swift
//  TODO
//
//  Created by Алексей Мальков on 20.05.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

extension TaskDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.checkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CheckTableViewCell else { return UITableViewCell() }
        
        let checkMark = task.checkList[indexPath.row]
        
        cell.checkListItemTextField.text = checkMark.title
        
        checkMark.isMarkSelected ? cell.checkMarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) : cell.checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        
        let strikedText = NSMutableAttributedString(string: checkMark.title)
        strikedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 3, range: NSMakeRange(0, strikedText.length))
        let normalText = NSMutableAttributedString(string: checkMark.title)
        normalText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, normalText.length))
        cell.checkListItemTextField.text = checkMark.title
        cell.checkListItemTextField.attributedText = checkMark.isMarkSelected ?  strikedText : normalText
        cell.checkListItemTextField.tag = indexPath.row
        cell.checkListItemTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cell.checkMarkButton.addTarget(self, action: #selector(self.toggleSelected(button:)), for: .touchUpInside)
        cell.checkMarkButton.tag = indexPath.row
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            task.checkList.remove(at: indexPath.row)
            checkListTableView.deleteRows(at: [indexPath], with: .fade)
        }
        checkListTableView.reloadData()
    }
    
    
    //MARK: - TEBLEVIEW ACTIONS
    @objc func toggleSelected(button: UIButton) {
        if task.checkList[button.tag].isMarkSelected {
            task.markSelectedCount -= 1
        } else {
            task.markSelectedCount += 1
        }
        task.checkList[button.tag].isMarkSelected.toggle()
        checkListTableView.reloadData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        task.checkList[textField.tag].title = textField.text ?? ""

    }
    
}
