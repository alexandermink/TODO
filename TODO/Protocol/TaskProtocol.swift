//
//  TaskProtocol.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit

protocol TaskProtocol {
    func addTask(id: Int, name: String, date: Date)
    func getTasksFromRealm()
    func deleteTask(indexPathTask: Int)
}
