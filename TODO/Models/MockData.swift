//
//  MockData.swift
//  TODO
//
//  Created by Александр Минк on 04.08.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class MockDataFactory {
    
    static let mockDataSet: [SectionTask] = [
        SectionTask(sectionName: "Список задач", tasks: [
            Task(id: 1, name: "Здравствуйте!", backgroundColor: .clear, taskDescription: "Вы можете редактировать название задачи и ее описание. Свайп влева позволяет поменять цвет Вашей задачи. Так же Вы можете названачать дату уведомления для Вашей задачи.", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [CheckMark(id: 1, title: "Ваша выполненые задача", isMarkSelected: true), CheckMark(id: 2, title: "Задача, которую предстоит выолноить", isMarkSelected: false)], markSelectedCount: 1, isFavorite: false, isDone: false)
        ])
    ]
    
    static func makeMockData(sections: [SectionTask]){
        for section in sections {
            for task in section.sectionTasks {
                try? Main.instance.addTask(sectionName: section.sectionName, name: task.name, backgroundColor: task.backgroundColor, taskDescription: task.taskDescription, notificationDate: task.notificationDate, checkList: task.checkList, markSelectedCount: task.markSelectedCount)
            }
        }
    }
}
