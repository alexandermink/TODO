//
//  TaskProtocol.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit

protocol TaskProtocol {
    func addSection(section: String)
    func addTask(section: String, id: Int, name: String, date: Date)
    func getTasksFromRealm()
    func deleteTask(indexPathTask: Int)
}
