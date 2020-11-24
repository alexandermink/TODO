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
    
    init(id: Int, name: String, date: Date) {
        self.id = id
        self.name = name
        self.date = date
    }
    
    init() { }
    
}

class TaskRealm: Object {
    @objc var id: Int = -1
    @objc var name: String = ""
    @objc var date: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
