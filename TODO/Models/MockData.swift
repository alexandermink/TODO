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
        
        SectionTask(sectionName: "1. Добавление данных", tasks: [
            Task(id: 1, name: "Добавление новой задачи", backgroundColor: .clear, taskDescription: "Для добавления новой задачи необходимо нажать кнопку с иконкой '+' в правом верхнем углу. ", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0, isFavorite: false, isDone: false),
            Task(id: 2, name: "Быстрое добавление задачи", backgroundColor: .clear, taskDescription: "В конце каждой секции расположена кнопка с иконкой '+' для быстрого добавления новой задачи. В таком случае в появившемся поле необходимо ввести только название новой задачи.", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0, isFavorite: false, isDone: false)
        ]),
        
        
        
        SectionTask(sectionName: "2. Новая задача", tasks: [
            Task(id: 3, name: "Создание новой задачи", backgroundColor: .clear, taskDescription: "Нажмите на кнопку '+' справа вверху экрана для перехода в раздел", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0, isFavorite: false, isDone: false),
            Task(id: 4, name: "Работа с секциями", backgroundColor: .clear, taskDescription: "В разделе 'Секция' можно задать новый раздел, который будет группировать Ваши задачи. Просто нажмите на икоку клавиатуры. В дальнейшем, Вы сможете выбирать секции из уже имеющихся, а также удалять их.", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0, isFavorite: false, isDone: false),
            Task(id: 5, name: "Остальное", backgroundColor: .clear, taskDescription: "Вы можете задать название, описание вашей задачи, задать цвет фона и настроить дату и время напоминания", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0, isFavorite: false, isDone: false),
            Task(id: 6, name: "Чеклист", backgroundColor: .clear, taskDescription: "Здесь можно добавить список, характеризующий этапы выполнения задачи, помечать пункы как выполненные. Прогресс выполнения будет отображаться на главном экране, путём заполнения цветной линии под каждой задачей.", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [
                CheckMark(id: 1, title: "Первый элемент", isMarkSelected: true),
                CheckMark(id: 2, title: "Второй элемент", isMarkSelected: true),
                CheckMark(id: 3, title: "Третий элемент", isMarkSelected: false),
                CheckMark(id: 4, title: "Четвертый элемент", isMarkSelected: true),
                CheckMark(id: 5, title: "Пятый элемент", isMarkSelected: false)
            ], markSelectedCount: 3, isFavorite: false, isDone: false)
        ]),
        
        
        
        SectionTask(sectionName: "3. Изменение задач", tasks: [
            Task(id: 7, name: "Изменение данных", backgroundColor: .clear, taskDescription: "Вы можете редактировать название и описание задачи, задавать новую дату уведомления нажав на соответствующие разделы.", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 1, isFavorite: false, isDone: false),
            Task(id: 8, name: "Чек лист", backgroundColor: .clear, taskDescription: "Вы можете добавлять элементы чек листа нажав на 'Добавить элемент'. Нажав на галочку вы меняете статус выполнения подзадачи.", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [CheckMark(id: 1, title: "Ваша выполненная задача", isMarkSelected: true), CheckMark(id: 2, title: "Задача, которую предстоит выполнить", isMarkSelected: false)], markSelectedCount: 1, isFavorite: false, isDone: false)
        ]),
        
        
        
        
        SectionTask(sectionName: "4. Удаление данных", tasks: [
            Task(id: 9, name: "Удаление ячейки", backgroundColor: .clear, taskDescription: "Для удаление ячейки используется смахивание в левую сторону. Потяните ячейку влево и нажмите кнопку 'Удалить'", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0, isFavorite: false, isDone: false),
            Task(id: 10, name: "Удаление всех данных", backgroundColor: .clear, taskDescription: "Для удаление всех данных используется меню 'Настройки'. Для перехода в настройки нажмите на кнопку 'Настройки' в левом верхнем углу. Далее выбираем пункт 'Очистить все данные' и подтверждаем свой выбор дважды.", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0, isFavorite: false, isDone: false)
        ]),
        
        
        SectionTask(sectionName: "5. Фильтры", tasks: [
            Task(id: 11, name: "Иконки состояний", backgroundColor: .clear, taskDescription: "При вызове контекстного меню на задаче можно выбрать состояние задачи: 'Выполнено', 'Избранное'. Состояния отображаются над названием задачи.", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0, isFavorite: true, isDone: true),
            Task(id: 12, name: "Избранное", backgroundColor: .clear, taskDescription: "Для просмотра задач, добавленных в 'Избранное', необходимо нажать кнопку 'Фильтры' в правом верхнем углу и выбрать пункт 'Избранные'.", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0, isFavorite: false, isDone: false),
            Task(id: 13, name: "Завершенные", backgroundColor: .clear, taskDescription: "Для просмотра задач, добавленных в 'Завершенные', необходимо нажать кнопку 'Фильтры' в правом верхнем углу и выбрать пункт 'Завершенные'.", creationDate: Date(), notificationDate: "", notificationID: "", checkList: [], markSelectedCount: 0, isFavorite: false, isDone: false)
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
