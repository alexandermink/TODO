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
        taskRealm.backgroundColor = task.backgroundColor ?? UIColor()
        taskRealm.taskDescription = task.taskDescription
        taskRealm.creationDate = task.creationDate
        taskRealm.notificationDate = task.notificationDate
        
        return taskRealm
    }
    
    func convert(_ taskRealm: TaskRealm) -> Task {
        
        var task = Task()
        
        task.id = taskRealm.value(forKey: "id") as! Int
        task.name = taskRealm.value(forKey: "name") as! String
        task.backgroundColor = taskRealm.value(forKey: "backgroundColor") as? UIColor
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
