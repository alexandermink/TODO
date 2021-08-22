//
//  UserSession.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import Foundation

class UserSession{
    
    var tasks: [SectionTask] = []
    
    init() { }
    
    init(tasksRealm: [SectionTask]) {
        self.tasks = tasksRealm
    }
}
