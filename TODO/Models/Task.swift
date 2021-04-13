//
//  Task.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift

struct Task {
    
    var id: Int = -1
    var name: String = ""
    var backgroundColor: UIColor? = UIColor.clear
    var taskDescription: String? = ""
    var creationDate: Date = Date()
    var notificationDate: String? = ""
    // TODO: сделать авторизацию
//    var members: [String]?
    
    init(id: Int, name: String, backgroundColor: UIColor?, taskDescription: String?, creationDate: Date, notificationDate: String?) {
        self.id = id
        self.name = name
        self.backgroundColor = backgroundColor
        self.taskDescription = taskDescription
        self.creationDate = creationDate
        self.notificationDate = notificationDate
//        self.members = members
    }
    
    init() { }
    
}

class TaskRealm: Object {
    @objc var id: Int = -1
    @objc var name: String = ""
    @objc var backgroundColor: String? = ""
    @objc var taskDescription: String? = ""
    @objc var creationDate: Date = Date()
    @objc var notificationDate: String? = ""
//    var members = List<String>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

struct SectionTask: Comparable {
    static func < (lhs: SectionTask, rhs: SectionTask) -> Bool {
        return lhs.sectionName < rhs.sectionName
    }
    
    static func == (lhs: SectionTask, rhs: SectionTask) -> Bool {
        return lhs.sectionName == rhs.sectionName
    }
    
    var sectionName: String = ""
    var sectionTasks: [Task] = []
    
    init() { }
    
    init(sectionName: String, tasks: [Task]) {
        self.sectionName = sectionName
        self.sectionTasks = tasks
    }
    
    mutating func addTaskInSection(task: Task) {
        self.sectionTasks.append(task)
    }
}

class SectionTaskRealm: Object {
    @objc var sectionName: String = ""
    let sectionTasks = List<TaskRealm>()
    
    override class func primaryKey() -> String? {
        return "sectionName"
    }
}
