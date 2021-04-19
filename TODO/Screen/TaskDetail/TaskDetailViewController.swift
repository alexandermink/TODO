//
//  TaskDetailViewController.swift
//  TODO
//
//  Created by Алексей Мальков on 29.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController{
    
    var taskNameTitleLabel = UILabel()
    var taskNameTextView: UITextView!
    var taskCreationDateTitleLabel = UILabel()
    var taskCreationDateLabel = UILabel()
    var taskDateTitleLabel = UILabel()
    var taskDateLabel = UILabel()
    var taskDetailTitleLabel = UILabel()
    var taskDetailTextView: UITextView!
    
    
    var task: Task? = Task()
    let dateFormatter = DateFormatter()
    
    
    func makeTF(lab: UILabel, text: String, color: UIColor) -> UILabel {
        var label = lab
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.textColor = color
        view.addSubview(label)
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        view.backgroundColor = UIColor.lightGray
        view.applyGradient(colours: [.vitDarkBrown, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        
        taskNameTitleLabel = makeTF(lab: self.taskNameTitleLabel, text: "Задача", color: .systemGray)
        
        taskNameTextView = UITextView()
        taskNameTextView.translatesAutoresizingMaskIntoConstraints = false
        taskNameTextView.text = task?.name
        taskNameTextView.backgroundColor = UIColor.clear
        taskNameTextView.isEditable = true
        taskNameTextView.isScrollEnabled = true
        taskNameTextView.textColor = .systemYellow
        taskNameTextView.contentInsetAdjustmentBehavior = .automatic
        taskNameTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskNameTextView)
        
        taskCreationDateTitleLabel = makeTF(lab: self.taskCreationDateTitleLabel, text: "Дата регестрации задачи:", color: .systemGray)
        
        taskCreationDateLabel = makeTF(lab: self.taskCreationDateLabel, text: dateFormatter.string(from: task?.creationDate ?? Date()), color: .systemYellow)
        
        taskDateTitleLabel = makeTF(lab: self.taskDateTitleLabel, text: "Дата уведомления задачи:", color: .systemGray)
        
        taskDateLabel = makeTF(lab: self.taskDateLabel, text: task?.notificationDate ?? Date().localString(), color: .systemYellow)
        
        if taskDateLabel.text == "" { taskDateLabel.text = "дата уведомления не назначена" }
        
        taskDetailTitleLabel = makeTF(lab: self.taskDetailTitleLabel, text: "Описание задачи:", color: .systemGray)
        
        taskDetailTextView = UITextView()
        taskDetailTextView.translatesAutoresizingMaskIntoConstraints = false
        taskDetailTextView.backgroundColor = UIColor.clear
        taskDetailTextView.contentInsetAdjustmentBehavior = .automatic
        taskDetailTextView.isEditable = true
        taskDetailTextView.isScrollEnabled = true
        if task?.taskDescription != ""{
            taskDetailTextView.text = task?.taskDescription
        } else {
            taskDetailTextView.text = "Напишите описание задачи"
        }
        taskDetailTextView.textAlignment = .left
        taskDetailTextView.textColor = .systemYellow
        taskDetailTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskDetailTextView)
        
        constrainsInit()
    }
    
    func constrainsInit(){
        NSLayoutConstraint.activate([
            
            taskNameTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            taskNameTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskNameTextView.topAnchor.constraint(equalTo: taskNameTitleLabel.topAnchor, constant: 24),
            taskNameTextView.bottomAnchor.constraint(equalTo: taskCreationDateTitleLabel.topAnchor, constant: 2),
            taskNameTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            taskNameTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            
            taskCreationDateTitleLabel.topAnchor.constraint(equalTo: taskNameTextView.topAnchor, constant: 48),
            taskCreationDateTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskCreationDateLabel.topAnchor.constraint(equalTo: taskCreationDateTitleLabel.topAnchor, constant: 28),
            taskCreationDateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDateTitleLabel.topAnchor.constraint(equalTo: taskCreationDateLabel.topAnchor, constant: 36),
            taskDateTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDateLabel.topAnchor.constraint(equalTo: taskDateTitleLabel.topAnchor, constant: 28),
            taskDateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDetailTitleLabel.topAnchor.constraint(equalTo: taskDateLabel.topAnchor, constant: 36),
            taskDetailTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDetailTextView.topAnchor.constraint(equalTo: taskDetailTitleLabel.topAnchor, constant: 24),
            taskDetailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            taskDetailTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            taskDetailTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12)
            
        ])
    }
}
