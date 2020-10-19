//
//  Main.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit

class Main {
    
    private let userSessionCaretaker = UserSessionCaretaker()
    
    var userSession: UserSession? {
        didSet{
            userSessionCaretaker.save(session: userSession!)
        }
    }
    
    init() {
        self.userSession = userSessionCaretaker.load()
    }
    
    
    
}

extension Main: TaskProtocol {
    func addTask(id: Int, name: String, date: Date) {
        userSession?.tasks.append(Task(id: id, name: name, date: date))
    }
    
    
}
