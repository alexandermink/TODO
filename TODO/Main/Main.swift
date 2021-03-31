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
    
    private init() { }
    
}

extension Main: TaskProtocol {
    
    func addSection(section: String) {
        for item in self.userSession.tasks {
            if item.sectionName == section {
                return
            }
        }
        self.userSession.tasks.append(TasksStruct(section: section, tasks: []))
        let realm = try! Realm()
        let taskArray = TasksStructRealm()
        taskArray.sectionName = section
        try! realm.write {
            realm.add(taskArray, update: .modified)
        }
    }
    
    func addTask(section: String, name: String) {
        let realm = try! Realm()
        
        let id = (realm.objects(TaskRealm.self).sorted(byKeyPath: "id", ascending: false).first?.value(forKey: "id") as? Int ?? 0) + 1
        let date = Date()
        if realm.objects(TasksStructRealm.self).filter("sectionName = '\(section)'").isEmpty {
            self.addSection(section: section)
        }
        if !self.userSession.tasks.isEmpty {
            for i in 0..<self.userSession.tasks.count {
                if self.userSession.tasks[i].sectionName == section {
                    self.userSession.tasks[i].sectionTasks.append(Task(id: id, name: name, date: date))
                }
            }
        } else {
            self.userSession.tasks.append(TasksStruct(section: section, tasks: [Task(id: id, name: name, date: date)]))
        }
        let taskRealm = TaskRealm()
        taskRealm.id = id
        taskRealm.name = name
        taskRealm.date = date
        try! realm.write {
            let tTaskSection = realm.objects(TasksStructRealm.self).filter("sectionName = '\(section)'").first
            tTaskSection?.sectionTasks.append(taskRealm)
        }
        self.getTasksFromRealm()
    }
    
    func getTasksFromRealm() {
        self.userSession.tasks = []
        let realm = try! Realm()
        let tasksArrayRealm = realm.objects(TasksStructRealm.self)
        if !tasksArrayRealm.isEmpty {
            for i in 0..<tasksArrayRealm.count {
                if !tasksArrayRealm[i].sectionTasks.isEmpty {
                    var tTaskArray = TasksStruct()
                    tTaskArray.sectionName = tasksArrayRealm[i].value(forKey: "sectionName") as! String
                    if !tasksArrayRealm[i].sectionTasks.isEmpty {
                        for j in 0..<tasksArrayRealm[i].sectionTasks.count {
                            var tTask = Task()
                            tTask.id = tasksArrayRealm[i].sectionTasks[j].value(forKey: "id") as! Int
                            tTask.name = tasksArrayRealm[i].sectionTasks[j].value(forKey: "name") as! String
                            tTask.date = tasksArrayRealm[i].sectionTasks[j].value(forKey: "date") as! Date
                            tTaskArray.sectionTasks.append(tTask)
                        }
                    }
                    self.userSession.tasks.append(tTaskArray)
                }
            }
        }
        self.userSession.tasks = self.userSession.tasks.sorted()
    }
    
    func getCategoriesFromRealm() -> [String] {
        let realm = try! Realm()
        let objects = realm.objects(TasksStructRealm.self).sorted(byKeyPath: "sectionName", ascending: true)
        var categories: [String] = []
        for item in objects{
            categories.append(item.value(forKey: "sectionName") as! String)
        }
        return categories
    }
    
    func deleteTask(indexPathSectionTask: Int, indexPathRowTask: Int) {
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
    func deleteSection(delSectionName: String) {
        
        // TODO: сделать каскадное удаление в Realm (в официале не реализовано, есть рабочий кусок по ссылке)
        // https://gist.github.com/verebes1/02950e46fff91456f2ad359b3f3ec3d9
        let realm = try! Realm()
        let delSection = realm.objects(TasksStructRealm.self).filter("sectionName = '\(delSectionName)'").first
        print("delSection_______=\(String(describing: delSection))")
        try! realm.write{
            if let realmDelSection = delSection {
                realm.delete(realmDelSection)
            }
        }
        var delIndex: Int = -1
        for section in self.userSession.tasks {
            if section.sectionName == delSectionName {
                delIndex = self.userSession.tasks.firstIndex(of: section)!
                break
            }
        }
        self.userSession.tasks.remove(at: delIndex)
    }
}
