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
    func addTask(section: String, name: String)
    func getTasksFromRealm()
    func getCategoriesFromRealm() -> [String]
    func deleteTask(indexPathSectionTask: Int, indexPathRowTask: Int)
    func deleteSection(delSectionName: String)
}
