//
//  Main.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift

class Main {
    
    static let instance = Main()
    
    var dateFormatter = DateFormatter()
    
    var userSession: UserSession = UserSession()
    var notificationDate: String?
    var taskRealmConverter = TaskRealmConverter()
    var rowBGCcolor: UIColor = .clear
    var notifID: String?
    var notifBadgeCount = 0
    var notificationDateInterval = 0.0
    let notificationService = NotificationService()
    var tempCheckList: [CheckMark] = []
    var state: String? {
        get {return UserDefaults.standard.string(forKey: "k")}
        set {UserDefaults.standard.set(newValue, forKey: "k")}
    }
    var isCloudsHidden: Bool? {
        get {return UserDefaults.standard.bool(forKey: "clouds")}
        set {UserDefaults.standard.set(newValue, forKey: "clouds")}
    }
    var transitionSide = "left"
    
    

    private init() {
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
    }
    
}

extension Main: LocalDataBaseService {
    
    func addSection(sectionName: String) throws {

        guard userSession.tasks.map(\.sectionName).contains(sectionName) else {
            //Создание секции в локальном массиве
            userSession.tasks.append(SectionTask(sectionName: sectionName, tasks: []))
            
            //Сохранение секции в базу данных Realm
            let realm = try Realm()
            let taskArray = SectionTaskRealm()
            taskArray.sectionName = sectionName
            try realm.write {
                realm.add(taskArray, update: .modified)
            }
            return
        }
    }
    
    func addTask(sectionName: String, name: String, backgroundColor: UIColor?, taskDescription: String?, notificationDate: String?, checkList: [CheckMark], markSelectedCount: Int) throws -> Task {
        if !userSession.tasks.map(\.sectionName).contains(sectionName) {
            try addSection(sectionName: sectionName)
            let task = try addTask(sectionName: sectionName, name: name, backgroundColor: backgroundColor, taskDescription: taskDescription, notificationDate: notificationDate, checkList: checkList, markSelectedCount: markSelectedCount)
            return task
        } else {
            let realm = try Realm()
            let id = (realm.objects(TaskRealm.self).sorted(byKeyPath: "id", ascending: false).first?.id ?? 0) + 1
            let creationDate = Date()
            let tempNotificationID = notificationDate == "" ? "" : UUID().uuidString
            let task = Task(id: id, name: name, backgroundColor: backgroundColor, taskDescription: taskDescription, creationDate: creationDate, notificationDate: notificationDate, notificationID: tempNotificationID, checkList: checkList, markSelectedCount: markSelectedCount)
            //Создание таски в локальном массиве
            for indexSection in 0..<userSession.tasks.count {
                if userSession.tasks[indexSection].sectionName == sectionName {
                    userSession.tasks[indexSection].sectionTasks.append(task)
                }
            }
            
            //Создание таски в базе данных Realm
            try realm.write {
                let tTaskRealm = realm.objects(SectionTaskRealm.self).filter("sectionName = '\(sectionName)'").first
                tTaskRealm?.sectionTasks.append(taskRealmConverter.convert(task))
            }
            return task
        }
    }

    func updateTasksFromRealm() throws {
        
        let realm = try Realm()
        userSession.tasks = []
        let tasksRealm = realm.objects(SectionTaskRealm.self)
        for taskRealm in tasksRealm {
            let section = SectionTask(sectionName: taskRealm.sectionName, tasks: taskRealmConverter.convert(taskRealm.sectionTasks))
            userSession.tasks.append(section)
        }
        userSession.tasks = userSession.tasks.sorted()
    }
    
    func updateTask(task: Task) throws {
        let realm = try Realm()
        
        let objectRealm = TaskRealm()
        objectRealm.id = task.id
        objectRealm.name = task.name
        objectRealm.backgroundColor = task.backgroundColor?.toString()
        objectRealm.taskDescription = task.taskDescription
        objectRealm.creationDate = task.creationDate
        objectRealm.notificationDate = task.notificationDate
        objectRealm.markSelectedCount = task.markSelectedCount
        for checkMark in task.checkList {
            objectRealm.checkList.append(taskRealmConverter.convert(checkMark))
        }
        
        
        
        let notificationDate: Double = dateFormatter.date(from: task.notificationDate ?? "")?.timeIntervalSince1970 ?? 0
        let interval = notificationDate - Date().timeIntervalSince1970
        if interval <= 1 {
            objectRealm.notificationID = task.notificationID
        } else {
            if task.notificationDate != "" {
                objectRealm.notificationID = notificationService.updateNotificationRequest(task: task, notificationIdentifier: task.notificationID!)
            }
        }
        try realm.write {
            realm.add(objectRealm, update: .modified)
        }
    }
    
    func getSectionsFromRealm() throws -> [String] {
        let realm = try Realm()
        var sections: [String] = []
        let sectionsTaskRealm = realm.objects(SectionTaskRealm.self).sorted(byKeyPath: "sectionName", ascending: true)
        for section in sectionsTaskRealm {
            sections.append(section.sectionName)
        }
        return sections
    }
    
//    func deleteTask(indexPathSectionTask: Int, indexPathRowTask: Int) throws {
//        let realm = try! Realm()
//        let task = userSession.tasks[indexPathSectionTask].sectionTasks[indexPathRowTask]
//        let deleteTask = realm.objects(TaskRealm.self).filter("id = \(task.id)").first
//        try realm.write {
//            if let delTask = deleteTask {
//                realm.delete(delTask)
//            }
//        }
//
//        if task.notificationID != "" {
//            let notificationService = NotificationService()
//            notificationService.deleteNotificationRequest(notificationIdentifier: task.notificationID!)
//        }
//
//        self.userSession.tasks[indexPathSectionTask].sectionTasks.remove(at: indexPathRowTask)
//    }
    
    func deleteTask(task: Task) throws {
        let realm = try Realm()
        guard let delTask = realm.objects(TaskRealm.self).filter("id = \(task.id)").first else { return }
        
        try realm.write{
            realm.delete(delTask)
        }
        
    }

    // на входе String с именем удалаяемой категории
    func deleteSection(delSectionName: String) throws {

        // TODO: сделать каскадное удаление в Realm (в официале не реализовано, есть рабочий кусок по ссылке)
        // https://gist.github.com/verebes1/02950e46fff91456f2ad359b3f3ec3d9
        let realm = try Realm()
        let delSection = realm.objects(SectionTaskRealm.self).filter("sectionName = '\(delSectionName)'").first
        print("delSection_______=\(String(describing: delSection))")
        try realm.write{
            if let realmDelSection = delSection {
                realm.delete(realmDelSection)
            }
        }
        for sectionIndex in 0..<self.userSession.tasks.count {
            if userSession.tasks[sectionIndex].sectionName.contains(delSectionName) {
                self.userSession.tasks.remove(at: sectionIndex)
                break
            }
        }
        
    }
    
    func deleteAllData() throws {
        let realm = try Realm()
        try realm.write{
            realm.deleteAll()
        }
    }
}
