//
//  TaskRealmConverter.swift
//  TODO
//
//  Created by Александр Минк on 05.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift

class TaskRealmConverter {
    
    func convert(_ task: Task) -> TaskRealm {
        
        let taskRealm = TaskRealm()
        
        taskRealm.id = task.id
        taskRealm.name = task.name
        taskRealm.backgroundColor = task.backgroundColor?.toString()
        taskRealm.taskDescription = task.taskDescription
        taskRealm.creationDate = task.creationDate
        taskRealm.notificationDate = task.notificationDate
        
        return taskRealm
    }
    
    func convert(_ taskRealm: TaskRealm) -> Task {
        
        var task = Task()
        
        task.id = taskRealm.value(forKey: "id") as! Int
        task.name = taskRealm.value(forKey: "name") as! String
        
        let backgroundColor: String = taskRealm.value(forKey: "backgroundColor") as? String ?? ""
        let colorComponents: [String] = backgroundColor.components(separatedBy: " ")
        let tempBackgroundColor: UIColor = UIColor(cgColor: CGColor(
            red: CGFloat(colorComponents[0].floatValue),
            green: CGFloat(colorComponents[1].floatValue),
            blue: CGFloat(colorComponents[2].floatValue),
            alpha: CGFloat(colorComponents[3].floatValue))
        )
        task.backgroundColor = tempBackgroundColor
        task.taskDescription = taskRealm.value(forKey: "taskDescription") as? String
        task.creationDate = taskRealm.value(forKey: "creationDate") as! Date
        task.notificationDate = taskRealm.value(forKey: "notificationDate") as? String
        
        return task
    }
    
    func convert(_ tasksRealm: List<TaskRealm>) -> [Task] {
        var tasks: [Task] = []
        for taskRealm in tasksRealm {
            tasks.append(convert(taskRealm))
        }
        return tasks
    }
    
    func convert(_ sectionTaskRealm: SectionTaskRealm) -> SectionTask {
        return SectionTask(sectionName: sectionTaskRealm.sectionName, tasks: convert(sectionTaskRealm.sectionTasks))
    }
}
