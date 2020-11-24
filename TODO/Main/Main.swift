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
    
    
    var userSession: UserSession = UserSession()
    
    init() { }
    
}

extension Main: TaskProtocol {
    
    func addTask(id: Int, name: String, date: Date) {
        self.userSession.tasks.append(Task(id: id, name: name, date: date))
        
        let realm = try! Realm()
        let taskRealm = TaskRealm()
        taskRealm.id = id
        taskRealm.name = name
        taskRealm.date = date

        try! realm.write {
            realm.add(taskRealm, update: .all)
        }
    }
    
    func getTasksFromRealm() {

        let realm = try! Realm()
        let tasksRealm = realm.objects(TaskRealm.self)
        if !tasksRealm.isEmpty {
            for i in 0...tasksRealm.count-1 {
                var tTask = Task()
                tTask.id = tasksRealm[i].value(forKey: "id") as! Int
                tTask.name = tasksRealm[i].value(forKey: "name") as! String
                tTask.date = tasksRealm[i].value(forKey: "date") as! Date
                self.userSession.tasks.append(tTask)
            }
        }
    }
    
    func deleteTask(indexPathTask: Int) {
        
        
        let realm = try! Realm()
        let object = realm.objects(TaskRealm.self).filter("id = \(self.userSession.tasks[indexPathTask].id)").first
        try! realm.write {
            if let obj = object {
                realm.delete(obj)
            }
        }
        self.userSession.tasks.remove(at: indexPathTask)
    }
    
}
