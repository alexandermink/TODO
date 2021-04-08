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
    var taskNameLabel: UILabel!
    var taskDateTitleLabel: UILabel!
    var taskDateLabel: UILabel!
    var taskDetailTitleLabel: UILabel!
    var taskDetailLabel: UILabel!
    
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
        
        taskNameLabel = UILabel()
        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        taskNameLabel.text = task?.name
        taskNameLabel.textColor = .systemYellow
        taskNameLabel.numberOfLines = 2
        taskNameLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskNameLabel)
        
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
        
        taskDetailLabel = UILabel()
        taskDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        taskDetailLabel.text = task?.taskDescription
        taskDetailLabel.numberOfLines = 3
        taskDetailLabel.textAlignment = .left
        taskDetailLabel.textColor = .systemYellow
        taskDetailLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskDetailLabel)
        
        constrainsInit()
    }
    
    func constrainsInit(){
        NSLayoutConstraint.activate([
            
            taskNameTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            taskNameTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskNameLabel.topAnchor.constraint(equalTo: taskNameTitleLabel.topAnchor, constant: 24),
            taskNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            taskNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 4),
            
            taskDateTitleLabel.topAnchor.constraint(equalTo: taskNameLabel.topAnchor, constant: 40),
            taskDateTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDateLabel.topAnchor.constraint(equalTo: taskDateTitleLabel.topAnchor, constant: 24),
            taskDateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDetailTitleLabel.topAnchor.constraint(equalTo: taskDateLabel.topAnchor, constant: 40),
            taskDetailTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDetailLabel.topAnchor.constraint(equalTo: taskDetailTitleLabel.topAnchor, constant: 24),
//            taskDetailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskDetailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            taskDetailLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 4)
            
        ])
    }
    
}
