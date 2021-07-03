//
//  TaskDetailViewController.swift
//  TODO
//
//  Created by Алексей Мальков on 29.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, TaskDetailDelegate {
    
    //MARK: - VARIABLES
    let taskDetailView = TaskDetailView()
    var task: Task = Task()
    var router: BaseRouter?
    
    //MARK: - LIFE CYCLE
    override func loadView() {
        view = taskDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskDetailView.delegate = self
        taskDetailView.task = task
        taskDetailView.checkListTableView.dataSource = self
        updateData()
        router = BaseRouter(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDetailView.changeTheme()
    }
    
    func taskDetailDismiss(){
        router?.dismiss()
    }
    
    //MARK: - ACTION SET UP
    func updateData(){
        taskDetailView.taskDateTextField.inputAccessoryView = makeToolBarNotificationsDetail()
        taskDetailView.taskNameTextView.text = (task.name != "" ? task.name : "Напишите название задачи")
        taskDetailView.taskCreationDateLabel.text = taskDetailView.dateFormatter.string(from: task.creationDate)
        taskDetailView.taskDateTextField.text = task.notificationDate
        taskDetailView.taskDescriptionTextView.text = (task.taskDescription != "" ? task.taskDescription : "Напишите описание задачи")
        taskDetailView.addCheckButton.addTarget(self,
                                action: #selector(checkTablePlusAction),
                                                for: .touchUpInside)
        taskDetailView.doneButton.addTarget(self,
                                action: #selector(handleDoneTouchUpInside),
                                for: .touchUpInside)
        taskDetailView.checkListTableView.reloadData()
    }
    
    //MARK: - ACTIONS
    @objc func handleDoneTouchUpInside(){
        task.name = (taskDetailView.taskNameTextView.text == "Напишите название задачи" ? "" : taskDetailView.taskNameTextView.text)
        task.taskDescription = (taskDetailView.taskDescriptionTextView.text == "Напишите описание задачи" ? "" : taskDetailView.taskDescriptionTextView.text)
            
        if task.notificationDate == "" {
            if taskDetailView.taskDateTextField.text != "" {
                print("New notif")
                task.notificationDate = taskDetailView.taskDateTextField.text
                task.notificationID = UUID().uuidString
                task.notificationID = taskDetailView.notificationService.sendNotificationRequest(task: task)
            }
        } else {
            if taskDetailView.taskDateTextField.text != "" {
                if taskDetailView.taskDateTextField.text != task.notificationDate {
                    print("Update notif")
                    task.notificationDate = taskDetailView.taskDateTextField.text
                    task.notificationID = taskDetailView.notificationService.updateNotificationRequest(task: task, notificationIdentifier: task.notificationID!)
                }
            } else {
                print("Delete notif")
                taskDetailView.notificationService.deleteNotificationRequest(notificationIdentifier: (task.notificationID)!)
                task.notificationDate = ""
                task.notificationID = ""
                taskDetailView.taskDateTextField.text = ""
            }
        }
        
        task.notificationDate = taskDetailView.taskDateTextField.text
        
        try? Main.instance.updateTask(task: task)
        taskDetailView.delegate?.taskDetailDismiss()
    }
    
    @objc func chooseNotificationAction() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
        }
        taskDetailView.taskDateTextField.text = taskDetailView.dateFormatter.string(from: taskDetailView.notificationPicker.date)
        taskDetailView.endEditing(true)
    }
    
    @objc func checkTablePlusAction(){
        let id = (task.checkList.max()?.id ?? 0) + 1
        print("plus id: ", id)
        let checkMark = CheckMark(id: id, title: taskDetailView.addCheckElementTextField.text ?? "", isMarkSelected: false)
        task.checkList.append(checkMark)
        taskDetailView.addCheckElementTextField.text = ""
        taskDetailView.addCheckElementTextField.becomeFirstResponder()
        taskDetailView.checkListTableView.reloadData()
    }

}
