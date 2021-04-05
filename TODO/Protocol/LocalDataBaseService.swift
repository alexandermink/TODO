//
//  TaskProtocol.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit

protocol LocalDataBaseService {
    func addSection(sectionName: String) throws
    func addTask(sectionName: String, name: String, backgroundColor: UIColor?, taskDescription: String?, notificationDate: String?) throws
    func updateTasksFromRealm() throws
    func getSectionsFromRealm() throws -> [String]
    func deleteTask(indexPathSectionTask: Int, indexPathRowTask: Int) throws
    func deleteSection(delSectionName: String) throws
}
