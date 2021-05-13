//
//  LocalDataBaseService.swift
//  TODO
//
//  Created by Александр Минк on 06.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

protocol LocalDataBaseService {
    func addSection(sectionName: String) throws
    func addTask(sectionName: String, name: String, backgroundColor: UIColor?, taskDescription: String?, notificationDate: String?, checkList: [CheckMark], markSelectedCount: Int) throws -> Task
    func updateTasksFromRealm() throws
    func updateTask(task: Task) throws
    func getSectionsFromRealm() throws -> [String]
//    func deleteTask(indexPathSectionTask: Int, indexPathRowTask: Int) throws
    func deleteTask(task: Task) throws
    func deleteSection(delSectionName: String) throws
    func deleteAllData() throws
}
