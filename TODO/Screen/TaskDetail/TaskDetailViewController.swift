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
    var rightNavButton = UIBarButtonItem()
    var leftNavButton = UIBarButtonItem()
    let dateFormatter = Main.instance.dateFormatter
    
    let theme = Main.instance.themeService.getTheme()
    
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

        navigationBarSetUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        taskDetailView.changeTheme()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        emptyCheck()
        isModalInPresentation = hasChanges
        rightNavButton.isEnabled = hasChanges
    }
    
    @objc func taskDetailDismiss(){
        router?.dismiss()
    }
    
    //MARK: - DELEGATE TEXT OBSERVER
    func textViewDidChange(_ textView: UITextView) {
        editedTask.name = taskDetailView.taskNameTextView.text
        editedTask.taskDescription = taskDetailView.taskDescriptionTextView.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editedTask.notificationDate = taskDetailView.taskDateTextField.text
    }
    
    //MARK: - ACTION SETUP
    func updateData() {
        taskDetailView.taskDateTextField.inputAccessoryView = makeToolBarNotificationsDetail()
        taskDetailView.taskNameTextView.text = (editedTask.name != "" ? editedTask.name : "Напишите название задачи")
        taskDetailView.taskCreationDateLabel.text = dateFormatter.string(from: editedTask.creationDate)
        taskDetailView.taskDateTextField.text = editedTask.notificationDate
        taskDetailView.taskDescriptionTextView.text = editedTask.taskDescription
        taskDetailView.addCheckButton.addTarget(self,
                                action: #selector(checkTablePlusAction),
                                                for: .touchUpInside)
        taskDetailView.checkListTableView.reloadData()
        taskDetailView.isDoneImage.image = UIImage(named: task.isDone ? theme.isDoneImageName : "def")
        taskDetailView.isFavoriteImage.image = UIImage(named: task.isFavorite ? theme.isFavouriteImageName : "def")
    }
    
    func emptyCheck() {
        if taskDetailView.addCheckElementTextField.text == "" {
            taskDetailView.addCheckButton.isEnabled = false
        } else {
            taskDetailView.addCheckButton.isEnabled = true
        }
    }
    
    func navigationBarSetUp() {
        navigationController!.navigationBar.barTintColor = theme.backgroundColor
        leftNavButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(confirmCancel))
        self.navigationItem.leftBarButtonItem  = leftNavButton
        leftNavButton.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: theme.interfaceColor], for: .normal)
        
        rightNavButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(handleDoneTouchUpInside))
        self.navigationItem.rightBarButtonItem  = rightNavButton
        rightNavButton.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: theme.interfaceColor], for: .normal)
        rightNavButton.isEnabled = hasChanges
    }
    
    //MARK: - ACTIONS
    @objc func handleDoneTouchUpInside() {
        editedTask.name = (taskDetailView.taskNameTextView.text == "Напишите название задачи" ? "" : taskDetailView.taskNameTextView.text)
        editedTask.taskDescription = (taskDetailView.taskDescriptionTextView.text == "Напишите описание задачи" ? "" : taskDetailView.taskDescriptionTextView.text)
        
        if task.notificationDate != editedTask.notificationDate {
            if task.notificationDate == "" && editedTask.notificationDate != "" {
                print("New notif")
                editedTask.notificationID = taskDetailView.notificationService.sendNotificationRequest(task: editedTask)
            } else if task.notificationDate != "" && editedTask.notificationDate != "" {
                print("Update notif")
                editedTask.notificationID = taskDetailView.notificationService.updateNotificationRequest(task: editedTask)
            } else if task.notificationDate != "" && editedTask.notificationDate == "" {
                print("Delete notif")
                taskDetailView.notificationService.deleteNotificationRequest(task: editedTask)
                editedTask.notificationDate = ""
                editedTask.notificationID = ""
            }
        }
        
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
        taskDetailView.taskDateTextField.text = dateFormatter.string(from: taskDetailView.notificationPicker.date)
        taskDetailView.endEditing(true)
    }
    
    @objc func deleteNotificationAction() {
        taskDetailView.taskDateTextField.text = ""
        
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
        confirmCancel()
    }

    // MARK: - Cancellation Confirmation
    
    @objc func confirmCancel() {
        if hasChanges {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default) { _ in
                self.handleDoneTouchUpInside()
            })
            alert.addAction(UIAlertAction(title: "Отменить изменения", style: .destructive) { _ in
                self.taskDetailDismiss()
            })
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            taskDetailDismiss()
        }
    }
}
