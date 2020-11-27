//
//  UserSession.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import Foundation

class UserSession{
    
//    private let tasksCaretaker = TasksCaretaker()
//
//    var tasks: [Task]{
//        didSet{
//            tasksCaretaker.save(tasks: tasks)
//        }
//    }
//
//    init() {
//        self.tasks = tasksCaretaker.load()
//    }
    
    
    
    var tasks: [TasksStruct] = []
    
    init() { }
    
    init(tasksRealm: [TasksStruct]) {
        
        self.tasks = tasksRealm
    }
    
    
    
}
