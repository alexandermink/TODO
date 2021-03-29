//
//  TaskDetailViewController.swift
//  TODO
//
//  Created by Алексей Мальков on 29.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController{
    
    var taskNameLabel: UILabel!
    var taskDateLabel: UILabel!
    
    var taskName: String?
    var taskDate: Date?
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        let formattedDate = dateFormatter.string(from: taskDate!)
        
        
        taskNameLabel = UILabel()
        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        taskNameLabel.text = taskName
        taskNameLabel.textColor = .black
        taskNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        view.addSubview(taskNameLabel)
        
        taskDateLabel = UILabel()
        taskDateLabel.translatesAutoresizingMaskIntoConstraints = false
        taskDateLabel.text = formattedDate
        taskDateLabel.textColor = .black
        taskDateLabel.font = UIFont.boldSystemFont(ofSize: 17)
        view.addSubview(taskDateLabel)
        
        constrainsInit()
    }
    
    func constrainsInit(){
        NSLayoutConstraint.activate([
            taskNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            taskNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            taskDateLabel.topAnchor.constraint(equalTo: taskNameLabel.topAnchor, constant: 50),
            taskDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
}
