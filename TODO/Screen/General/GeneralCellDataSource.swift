//
//  GeneralCellDataSource.swift
//  TODO
//
//  Created by Vit K on 29.05.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class GeneralCellDataSource {
    
    
    func getCell (at tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == Main.instance.userSession.tasks[indexPath.section].sectionTasks.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddButtonCell", for: indexPath) as? AddButtonTableViewCell else { return UITableViewCell() }
            let theme = Main.instance.themeService.getTheme()
            cell.addFastTaskNameTextField.textColor = theme.interfaceColor
            cell.addButton.setTitleColor(theme.interfaceColor, for: .normal)
            cell.addFastTaskNameTextField.keyboardAppearance = .dark
            
            cell.indexPath = indexPath
            if !cell.styleEditing {
                cell.setEditing(false, animated: false)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralCell", for: indexPath) as? GeneralTableViewCell else { return UITableViewCell() }
            cell.selectedBackgroundView = {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
                view.backgroundColor = UIColor.hexStringToUIColor(hex: "#fcdab7")
                return view
            }()
            cell.taskNameLabel.text = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].name
            cell.descriptionLabel.text = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].taskDescription
            cell.notificationLabel.text = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].notificationDate
            cell.notificationLabel.layer.cornerRadius = 6
            cell.backgroundColor = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor
            cell.configure()
            
            let markSelectedCount = Float(Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].markSelectedCount)
            let allMarkCount = Float(Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].checkList.count)
            
            var progress: Float = 0
            if allMarkCount > 0  {
                progress = markSelectedCount / allMarkCount
            }
            cell.checkProgressBar.setProgress(progress, animated: true)
            return cell
        }
    }
    
    func selectRow(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, router: BaseRouter) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == Main.instance.userSession.tasks[indexPath.section].sectionTasks.count {
            print("ячейка с кнопкой 'Добавить' нажата")
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            if indexPath.row == Main.instance.userSession.tasks[indexPath.section].sectionTasks.count {
                print("ячейка с кнопкой 'Добавить' нажата")
            } else {
                let navigationController = UINavigationController()
                let destinationViewController = TaskDetailViewController()
                
                navigationController.viewControllers.append(destinationViewController)
                navigationController.presentationController?.delegate = destinationViewController
                let object = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
                destinationViewController.task = object
                router.present(vc: navigationController)
            }
        }
    }
    
    func isEditRow(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == Main.instance.userSession.tasks[indexPath.section].sectionTasks.count{
            return false
        } else {
            return true
        }
    }
    
    func editingStyle(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor = .clear
            try? Main.instance.deleteTask(task: Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row])
        }
        tableView.reloadData()
    }
    
    func viewHeaderSection(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "someHeaderViewIdentifier") as? HeaderView else { return nil }
        headerView.configure(sameColorView: nil)
        return headerView
    }
}
