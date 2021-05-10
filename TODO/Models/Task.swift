//
//  Task.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift

struct CheckMark: Comparable {
    
    static func < (lhs: CheckMark, rhs: CheckMark) -> Bool {
        return lhs.id < rhs.id
    }
    
    var id: Int = -1
    var isMarkSelected: Bool = false
    var title: String = ""
    
    init () { }
    
    init (id: Int, title: String, isMarkSelected: Bool) {
        self.id = id
        self.title = title
        self.isMarkSelected = isMarkSelected
    }
}

class CheckMarkRealm: EmbeddedObject {
    @objc dynamic var id: Int = -1
    @objc dynamic var isMarkSelected: Bool = false
    @objc dynamic var title: String = ""
}

struct Task {
    
    var id: Int = -1
    var name: String = ""
    var backgroundColor: UIColor? = UIColor.clear
    var taskDescription: String? = ""
    var creationDate: Date = Date()
    var notificationDate: String? = ""
    var notificationID: String? = ""
    var checkList: [CheckMark] = []
    var markSelectedCount: Int = 0
    // TODO: сделать авторизацию
//    var members: [String]?
    
    init(id: Int, name: String, backgroundColor: UIColor?, taskDescription: String?, creationDate: Date, notificationDate: String?, notificationID: String?, checkList: [CheckMark], markSelectedCount: Int) {
        self.id = id
        self.name = name
        self.backgroundColor = backgroundColor
        self.taskDescription = taskDescription
        self.creationDate = creationDate
        self.notificationDate = notificationDate
        self.notificationID = notificationID
        self.checkList = checkList
        self.markSelectedCount = markSelectedCount
//        self.members = members
    }
    
    init() { }
    
}

class TaskRealm: Object {
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor: String? = ""
    @objc dynamic var taskDescription: String? = ""
    @objc dynamic var creationDate: Date = Date()
    @objc dynamic var notificationDate: String? = ""
    @objc dynamic var notificationID: String? = ""
    let checkList = List<CheckMarkRealm>()
    @objc dynamic var markSelectedCount: Int = 0
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
    @objc dynamic var sectionName: String = ""
    let sectionTasks = List<TaskRealm>()
    
    override class func primaryKey() -> String? {
        return "sectionName"
    }
}
