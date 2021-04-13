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
    var colo: UIColor?
//    {
//        get {
//            return UserDefaults.standard.set(UIColor.white, forKey: "white")
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: "co")
//        }
//    }

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
    
    func getSectionsFromRealm() throws -> [String] {
        let realm = try Realm()
        var sections: [String] = []
        let sectionsTaskRealm = realm.objects(SectionTaskRealm.self)
        for section in sectionsTaskRealm {
            sections.append(section.value(forKey: "sectionName") as! String)
        }
        return sections
    }
    
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
