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
    
    var userSession: UserSession = UserSession()
    var notificationDate: String?
    var taskRealmConverter = TaskRealmConverter()
    
    private init() { }
    
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
    
    func addTask(sectionName: String, name: String, backgroundColor: UIColor?, taskDescription: String?, notificationDate: String?) throws {
        
        let realm = try Realm()
        let id = (realm.objects(TaskRealm.self).sorted(byKeyPath: "id", ascending: false).first?.value(forKey: "id") as? Int ?? 0) + 1
        let creationDate = Date()
        let task = Task(id: id, name: name, backgroundColor: backgroundColor, taskDescription: taskDescription, creationDate: creationDate, notificationDate: notificationDate)
        if !userSession.tasks.map(\.sectionName).contains(sectionName) {
            try addSection(sectionName: sectionName)
            try addTask(sectionName: sectionName, name: name, backgroundColor: backgroundColor, taskDescription: taskDescription, notificationDate: notificationDate)
        } else {
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
        }
    }

//    func addTask(sectionName: String, name: String) throws {
//        let realm = try! Realm()
//
//        let id = (realm.objects(TaskRealm.self).map(\.id).max() ?? 0) + 1
//        let date = Date()
//        if realm.objects(SectionTaskRealm.self).filter("sectionName = '\(section)'").isEmpty {
//            try self.addSection(sectionName: section)
//        }
//        if !self.userSession.tasks.isEmpty {
//            for i in 0..<self.userSession.tasks.count {
//                if self.userSession.tasks[i].sectionName == section {
//                    self.userSession.tasks[i].sectionTasks.append(Task(id: <#T##Int#>, name: <#T##String#>, backgroundColor: <#T##UIColor#>, taskDescription: <#T##String#>, creationDate: <#T##Date#>, notificationDate: <#T##String#>, members: <#T##[String]#>))
//                }
//            }
//        } else {
//            self.userSession.tasks.append(SectionTask(section: section, tasks: [Task(id: id, name: name, date: date)]))
//        }
//        let taskRealm = TaskRealm()
//        taskRealm.id = id
//        taskRealm.name = name
//        taskRealm.date = date
//        try! realm.write {
//            let tTaskSection = realm.objects(SectionTaskRealm.self).filter("sectionName = '\(section)'").first
//            tTaskSection?.sectionTasks.append(taskRealm)
//        }
//        self.getTasksFromRealm()
//    }

    func updateTasksFromRealm() throws {
        
        let realm = try Realm()
        userSession.tasks = []
        let tasksRealm = realm.objects(SectionTaskRealm.self)
        for taskRealm in tasksRealm {
            let section = SectionTask(sectionName: taskRealm.value(forKey: "sectionName") as! String, tasks: taskRealmConverter.convert(taskRealm.sectionTasks))
            userSession.tasks.append(section)
        }
        userSession.tasks = userSession.tasks.sorted()
    }
    
//    func getTasksFromRealm() throws {
//        self.userSession.tasks = []
//        let realm = try! Realm()
//        let tasksArrayRealm = realm.objects(SectionTaskRealm.self)
//        if !tasksArrayRealm.isEmpty {
//            for i in 0..<tasksArrayRealm.count {
//                if !tasksArrayRealm[i].sectionTasks.isEmpty {
//                    var tTaskArray = SectionTask()
//                    tTaskArray.sectionName = tasksArrayRealm[i].value(forKey: "sectionName") as! String
//                    if !tasksArrayRealm[i].sectionTasks.isEmpty {
//                        for j in 0..<tasksArrayRealm[i].sectionTasks.count {
//                            var tTask = Task()
//                            tTask.id = tasksArrayRealm[i].sectionTasks[j].value(forKey: "id") as! Int
//                            tTask.name = tasksArrayRealm[i].sectionTasks[j].value(forKey: "name") as! String
//                            tTask.date = tasksArrayRealm[i].sectionTasks[j].value(forKey: "date") as! Date
//                            tTaskArray.sectionTasks.append(tTask)
//                        }
//                    }
//                    self.userSession.tasks.append(tTaskArray)
//                }
//            }
//        }
//        self.userSession.tasks = self.userSession.tasks.sorted()
//    }

    
    func getSectionsFromRealm() throws -> [String] {
//        let realm = try Realm()
//        print(realm.objects(SectionTaskRealm.self).sorted(byKeyPath: "sectionName", ascending: true))
//        print(realm.objects(SectionTaskRealm.self).sorted(byKeyPath: "sectionName", ascending: true).map(\.sectionName))
//        let objects = realm.objects(SectionTaskRealm.self)
//        let obj: [SectionTaskRealm] = objects
//        return taskRealmConverter.convert(realm.objects(SectionTaskRealm.self))
        
        let realm = try Realm()
        var sections: [String] = []
        let sectionsTaskRealm = realm.objects(SectionTaskRealm.self)
        for section in sectionsTaskRealm {
            sections.append(section.value(forKey: "sectionName") as! String)
        }
        return sections
    }
    
//    func getCategoriesFromRealm() throws -> [String] {
//        let realm = try! Realm()
//        let objects = realm.objects(SectionTaskRealm.self).sorted(byKeyPath: "sectionName", ascending: true)
//        var categories: [String] = []
//        for item in objects{
//            categories.append(item.value(forKey: "sectionName") as! String)
//        }
//        return categories
//    }

    func deleteTask(indexPathSectionTask: Int, indexPathRowTask: Int) throws {
        let realm = try! Realm()
        let deleteTask = realm.objects(TaskRealm.self).filter("id = \(self.userSession.tasks[indexPathSectionTask].sectionTasks[indexPathRowTask].id)").first
        try! realm.write {
            if let delTask = deleteTask {
                realm.delete(delTask)
            }
        }
        self.userSession.tasks[indexPathSectionTask].sectionTasks.remove(at: indexPathRowTask)
    }

    // на входе String с именем удалаяемой категории
    func deleteSection(delSectionName: String) throws {

        // TODO: сделать каскадное удаление в Realm (в официале не реализовано, есть рабочий кусок по ссылке)
        // https://gist.github.com/verebes1/02950e46fff91456f2ad359b3f3ec3d9
        let realm = try! Realm()
        let delSection = realm.objects(SectionTaskRealm.self).filter("sectionName = '\(delSectionName)'").first
        print("delSection_______=\(String(describing: delSection))")
        try! realm.write{
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
}
