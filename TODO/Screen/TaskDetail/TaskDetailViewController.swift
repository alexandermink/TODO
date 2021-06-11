//
//  TaskDetailViewController.swift
//  TODO
//
//  Created by Алексей Мальков on 29.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, TaskDetailDelegate {
    
    var taskDetailView = TaskDetailView()
    var task: Task = Task()
    var router: BaseRouter?
    
    override func loadView() {
        taskDetailView.delegate = self
        view = taskDetailView
        taskDetailView.task = task
        taskDetailView.updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = BaseRouter(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDetailView.changeTheme()
    }
    
    func taskDetailDismiss(){
        router?.dismiss()
    }

}
