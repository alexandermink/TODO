//
//  TaskDetailViewController.swift
//  TODO
//
//  Created by Алексей Мальков on 29.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, TaskDetailDelegate, UITextViewDelegate, UITextFieldDelegate, UIAdaptivePresentationControllerDelegate {
    
    //MARK: - VARIABLES
    let taskDetailView = TaskDetailView()
    var task: Task = Task()
    var editedTask = Task() {
        didSet {
            viewIfLoaded?.setNeedsLayout()
        }
    }
    var hasChanges: Bool {
        return task != editedTask
    }
    var router: BaseRouter?
    
    //MARK: - LIFE CYCLE
    override func loadView() {
        view = taskDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskDetailView.delegate = self
        taskDetailView.checkListTableView.dataSource = self
        router = BaseRouter(viewController: self)
        editedTask = task
        
        taskDetailView.taskDateTextField.delegate = self
        taskDetailView.taskNameTextView.delegate = self
        taskDetailView.taskDescriptionTextView.delegate = self
        
        
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        taskDetailView.changeTheme()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        isModalInPresentation = hasChanges
    }
    
    func taskDetailDismiss(){
        router?.dismiss()
    }
    
    //MARK: - DELEGATE TEXT OBSERVER
    func textViewDidChange(_ textView: UITextView) {
        editedTask.name = taskDetailView.taskNameTextView.text
        editedTask.taskDescription = taskDetailView.taskDescriptionTextView.text
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        editedTask.notificationDate = taskDetailView.taskDateTextField.text
    }
    
    //MARK: - ACTION SETUP
    func updateData(){
        taskDetailView.taskDateTextField.inputAccessoryView = makeToolBarNotificationsDetail()
        taskDetailView.taskNameTextView.text = (editedTask.name != "" ? editedTask.name : "Напишите название задачи")
        taskDetailView.taskCreationDateLabel.text = taskDetailView.dateFormatter.string(from: editedTask.creationDate)
        taskDetailView.taskDateTextField.text = editedTask.notificationDate
        taskDetailView.taskDescriptionTextView.text = (editedTask.taskDescription != "" ? editedTask.taskDescription : "Напишите описание задачи")
        taskDetailView.addCheckButton.addTarget(self,
                                action: #selector(checkTablePlusAction),
                                                for: .touchUpInside)
        taskDetailView.doneButton.addTarget(self,
                                action: #selector(handleDoneTouchUpInside),
                                for: .touchUpInside)
        taskDetailView.checkListTableView.reloadData()
    }
    
    //MARK: - ACTIONS
    @objc func handleDoneTouchUpInside() {
        editedTask.name = (taskDetailView.taskNameTextView.text == "Напишите название задачи" ? "" : taskDetailView.taskNameTextView.text)
        editedTask.taskDescription = (taskDetailView.taskDescriptionTextView.text == "Напишите описание задачи" ? "" : taskDetailView.taskDescriptionTextView.text)
            
        if editedTask.notificationDate == "" {
            if taskDetailView.taskDateTextField.text != "" {
                print("New notif")
                editedTask.notificationDate = taskDetailView.taskDateTextField.text
                editedTask.notificationID = UUID().uuidString
                editedTask.notificationID = taskDetailView.notificationService.sendNotificationRequest(task: editedTask)
            }
        } else {
            if taskDetailView.taskDateTextField.text != "" {
                if taskDetailView.taskDateTextField.text != editedTask.notificationDate {
                    print("Update notif")
                    editedTask.notificationDate = taskDetailView.taskDateTextField.text
                    editedTask.notificationID = taskDetailView.notificationService.updateNotificationRequest(task: editedTask, notificationIdentifier: editedTask.notificationID!)
                }
        } else {
            print("Delete notif")
            taskDetailView.notificationService.deleteNotificationRequest(notificationIdentifier: (editedTask.notificationID)!)
            editedTask.notificationDate = ""
            editedTask.notificationID = ""
            taskDetailView.taskDateTextField.text = ""
            }
        }
        
        editedTask.notificationDate = taskDetailView.taskDateTextField.text
        
        try? Main.instance.updateTask(task: editedTask)
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
    
    @objc func checkTablePlusAction() {
        let id = (editedTask.checkList.max()?.id ?? 0) + 1
        print("plus id: ", id)
        let checkMark = CheckMark(id: id, title: taskDetailView.addCheckElementTextField.text ?? "", isMarkSelected: false)
        editedTask.checkList.append(checkMark)
        taskDetailView.addCheckElementTextField.text = ""
        taskDetailView.addCheckElementTextField.becomeFirstResponder()
        taskDetailView.checkListTableView.reloadData()
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        confirmCancel(showingSave: true)
    }

    // MARK: - Cancellation Confirmation
    
    func confirmCancel(showingSave: Bool) {
        // Present a UIAlertController as an action sheet to have the user confirm losing any
        // recent changes.
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Only ask if the user wants to save if they attempt to pull to dismiss, not if they tap Cancel.
        if showingSave {
            alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                self.handleDoneTouchUpInside()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive) { _ in
            self.taskDetailDismiss()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // If presenting the alert controller as a popover, point the popover at the Cancel button.
//        alert.popoverPresentationController = cancelButton
        
        present(alert, animated: true, completion: nil)
    }

}
