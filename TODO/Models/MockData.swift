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
        SectionTask(sectionName: "fghjk", tasks: [
            Task(id: 1, name: "First task", backgroundColor: .clear, taskDescription: "fghjkjhgfghjioiuy tyutghj  hgfghjiutyu", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0),
            Task(id: 1, name: "Second task", backgroundColor: .clear, taskDescription: "djwjdjwdj hgfghjiutyu", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0)
        ]),
        SectionTask(sectionName: "ertyuio", tasks: [
            Task(id: 2, name: "dfghjkoeir", backgroundColor: .red, taskDescription: "hdwidowjdkow", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0)
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
