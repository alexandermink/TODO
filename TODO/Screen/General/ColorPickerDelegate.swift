//
//  ColorPickerDelegate.swift
//  TODO
//
//  Created by Vit K on 09.06.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

extension GeneralTableViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        Main.instance.rowBGColor = viewController.selectedColor
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pickColorButton = pickColorAction(at: indexPath)
        let okButton = okAction(at: indexPath)
        pickColorButton.backgroundColor = .darkGray
        okButton.backgroundColor = .darkGray
        let configuration = UISwipeActionsConfiguration(actions: [pickColorButton, okButton])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func pickColorAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Выбрать цвет") { (action, view, completion) in
            let colorPickerVC = UIColorPickerViewController()
            colorPickerVC.delegate = self
            self.present(colorPickerVC, animated: true)
            Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor = Main.instance.rowBGColor
        }
        return action
    }
    
    func okAction(at indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: "ОК") { [self] (action, view, completion) in
            var task = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
            task.backgroundColor = Main.instance.rowBGColor
            Main.instance.rowBGColor = .clear
            try? Main.instance.updateTask(task: task)
            tableView.reloadData()
        }
    }
}
