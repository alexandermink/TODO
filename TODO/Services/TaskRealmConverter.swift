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
        taskRealm.notificationID = task.notificationID
        taskRealm.markSelectedCount = task.markSelectedCount
        
        for checkMark in task.checkList {
            let checkMarkRealm = CheckMarkRealm()
            checkMarkRealm.isMarkSelected = checkMark.isMarkSelected
            checkMarkRealm.title = checkMark.title
            taskRealm.checkList.append(checkMarkRealm)
        }
        
        return taskRealm
    }
    
    func convert(_ taskRealm: TaskRealm) -> Task {
        
        var task = Task()
        
        task.id = taskRealm.id
        task.name = taskRealm.name
        
        let backgroundColor: String = taskRealm.backgroundColor ?? ""
        let colorComponents: [String] = backgroundColor.components(separatedBy: " ")
        let tempBackgroundColor: UIColor = UIColor(cgColor: CGColor(
            red: CGFloat(colorComponents[0].floatValue),
            green: CGFloat(colorComponents[1].floatValue),
            blue: CGFloat(colorComponents[2].floatValue),
            alpha: CGFloat(colorComponents[3].floatValue))
        )
        task.backgroundColor = tempBackgroundColor
        task.taskDescription = taskRealm.taskDescription
        task.creationDate = taskRealm.creationDate
        task.notificationDate = taskRealm.notificationDate
        task.notificationID = taskRealm.notificationID
        task.markSelectedCount = taskRealm.markSelectedCount
        
        
        for checkMarkRealm in taskRealm.checkList {
            var checkMark = CheckMark()
            checkMark.isMarkSelected = checkMarkRealm.isMarkSelected
            checkMark.title = checkMarkRealm.title
            task.checkList.append(checkMark)
        }
        
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
    
    func convert(_ checkMarkRealm: CheckMarkRealm) -> CheckMark {
        
        var checkMark = CheckMark()
        
        checkMark.id = checkMarkRealm.id
        checkMark.isMarkSelected = checkMarkRealm.isMarkSelected
        checkMark.title = checkMarkRealm.title
        
        return checkMark
    }
    
    func convert(_ checkMark: CheckMark) -> CheckMarkRealm {

        let checkMarkRealm = CheckMarkRealm()

        checkMarkRealm.id = checkMark.id
        checkMarkRealm.title = checkMark.title
        checkMarkRealm.isMarkSelected = checkMark.isMarkSelected

        return checkMarkRealm
    }
    
    func convert(_ checksMarkRealm: List<CheckMarkRealm>) -> [CheckMark] {
        var checkMark: [CheckMark] = []
        for checkMarkRealm in checksMarkRealm {
//            checkMark.append(convert(taskRealm))
             checkMark.append(convert(checkMarkRealm))
        }
        return checkMark
    }
    
}
