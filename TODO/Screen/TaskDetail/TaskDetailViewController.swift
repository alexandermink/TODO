//
//  TaskDetailViewController.swift
//  TODO
//
//  Created by Алексей Мальков on 29.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController{
    
    var taskNameTitleLabel: UILabel!
    var taskNameTextView: UITextView!
    var taskCreationDateTitleLabel: UILabel!
    var taskCreationDateLabel: UILabel!
    var taskDateTitleLabel: UILabel!
    var taskDateLabel: UILabel!
    var taskDetailTitleLabel: UILabel!
    var taskDetailTextView: UITextView!
    
    var task: Task? = Task()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        view.applyGradient(colours: [.darkBrown, .backgroundColor], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        
        taskNameTitleLabel = UILabel()
        taskNameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskNameTitleLabel.text = "Название:"
        taskNameTitleLabel.textColor = .systemGray
        taskNameTitleLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskNameTitleLabel)
        
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
        
        taskCreationDateTitleLabel = UILabel()
        taskCreationDateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskCreationDateTitleLabel.text = "Дата регестрации задачи:"
        taskCreationDateTitleLabel.textColor = .systemGray
        taskCreationDateTitleLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskCreationDateTitleLabel)
        
        taskCreationDateLabel = UILabel()
        taskCreationDateLabel.translatesAutoresizingMaskIntoConstraints = false
        taskCreationDateLabel.text = task?.creationDate.debugDescription
        taskCreationDateLabel.textColor = .systemYellow
        taskCreationDateLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskCreationDateLabel)
        
        taskDateTitleLabel = UILabel()
        taskDateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskDateTitleLabel.text = "Дата уведомления задачи:"
        taskDateTitleLabel.textColor = .systemGray
        taskDateTitleLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskDateTitleLabel)
        
        taskDateLabel = UILabel()
        taskDateLabel.translatesAutoresizingMaskIntoConstraints = false
        if task?.notificationDate != ""{
            taskDateLabel.text = task?.notificationDate
        } else {
            taskDateLabel.text = "Дата уведомления не назначена"
        }
        taskDateLabel.textColor = .systemYellow
        taskDateLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskDateLabel)
        
        taskDetailTitleLabel = UILabel()
        taskDetailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskDetailTitleLabel.text = "Описание задачи:"
        taskDetailTitleLabel.textColor = .systemGray
        taskDetailTitleLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskDetailTitleLabel)
        
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
            
            taskNameTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            taskNameTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskNameTextView.topAnchor.constraint(equalTo: taskNameTitleLabel.topAnchor, constant: 24),
            taskNameTextView.bottomAnchor.constraint(equalTo: taskCreationDateTitleLabel.topAnchor, constant: 2),
            taskNameTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            taskNameTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 4),
            
            taskCreationDateTitleLabel.topAnchor.constraint(equalTo: taskNameTextView.topAnchor, constant: 48),
            taskCreationDateTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskCreationDateLabel.topAnchor.constraint(equalTo: taskCreationDateTitleLabel.topAnchor, constant: 30),
            taskCreationDateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDateTitleLabel.topAnchor.constraint(equalTo: taskCreationDateLabel.topAnchor, constant: 48),
            taskDateTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDateLabel.topAnchor.constraint(equalTo: taskDateTitleLabel.topAnchor, constant: 30),
            taskDateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDetailTitleLabel.topAnchor.constraint(equalTo: taskDateLabel.topAnchor, constant: 40),
            taskDetailTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDetailTextView.topAnchor.constraint(equalTo: taskDetailTitleLabel.topAnchor, constant: 24),
            taskDetailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            taskDetailTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            taskDetailTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 4)
            
        ])
    }
    
}
