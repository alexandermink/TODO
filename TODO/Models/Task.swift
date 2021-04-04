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
    var date: Date = Date()
    var descriptionDetail: String = ""
    
    init(id: Int, name: String, date: Date, descriptionDetail: String) {
        self.id = id
        self.name = name
        self.date = date
        self.descriptionDetail = descriptionDetail
    }
    
    init() { }
    
}

class TaskRealm: Object {
    @objc var id: Int = -1
    @objc var name: String = ""
    @objc var date: Date = Date()
    @objc var descriptionDetail: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

struct TasksStruct: Comparable {
    static func < (lhs: TasksStruct, rhs: TasksStruct) -> Bool {
        return lhs.sectionName < rhs.sectionName
    }
    
    static func == (lhs: TasksStruct, rhs: TasksStruct) -> Bool {
        return lhs.sectionName == rhs.sectionName
    }
    
    var sectionName: String = ""
    var sectionTasks: [Task] = []
    
    init() { }
    
    init(section: String, tasks: [Task]) {
        self.sectionName = section
        self.sectionTasks = tasks
    }
    
    mutating func addTaskInSection(task: Task) {
        self.sectionTasks.append(task)
    }
}

class TasksStructRealm: Object {
    @objc var sectionName: String = ""
    let sectionTasks = List<TaskRealm>()
    
    override class func primaryKey() -> String? {
        return "sectionName"
    }
}
