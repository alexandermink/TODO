//
//  TasksCaretaker.swift
//  TODO
//
//  Created by Александр Минк on 20.11.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import Foundation

//class TasksCaretaker {
//
//    private let encoder = JSONEncoder()
//    private let decoder = JSONDecoder()
//
//    private let key = "tasksCaretakerKey"
//
//    func save(tasks: [Task]) {
//        do {
//            let data = try encoder.encode(tasks)
//            UserDefaults.standard.set(data, forKey: key)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    func load() -> [Task] {
//
//        guard let data = UserDefaults.standard.data(forKey: key) else { print("Не отработал мементо"); return [] }
//
//        do {
//            return try decoder.decode([Task].self, from: data)
//        } catch {
//            print(error.localizedDescription)
//            return []
//        }
//
//    }
//}
