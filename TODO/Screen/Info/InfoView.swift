//
//  InfoView.swift
//  TODO
//
//  Created by Алексей Мальков on 08.09.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    let scrollView = UIScrollView()
    let infoContentView = UIView()
    var infoLabel = UILabel()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .mainBackground
        uiSetUp()
        constrainsInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func uiSetUp() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        infoContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(infoContentView)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.text = "1. Добавление данных. \n Для добавления новой задачи необходимо нажать кнопку с иконкой '+' в правом верхнем углу. \nВ конце каждой секции расположена кнопка с иконкой '+' для быстрого добавления новой задачи. В таком случае в появившемся поле необходимо ввести только название новой задачи. \n\n2. Новая задача. \nНажмите на кнопку '+' справа вверху экрана для перехода в раздел. \nВ разделе 'Секция' можно задать новый раздел, который будет группировать Ваши задачи. Просто нажмите на иконку клавиатуры. В дальнейшем, Вы сможете выбирать секции из уже имеющихся, а также удалять их. \nВы можете задать название, описание Вашей задачи, задать цвет фона и настроить дату и время напоминания. \nЧеклист. Здесь можно добавить список, характеризующий этапы выполнения задачи, помечать пункты как выполненные. Прогресс выполнения будет отображаться на главном экране, путём заполнения цветной линии под каждой задачей. \n\n3. Изменение задач. \nВы можете редактировать название и описание задачи, задавать новую дату уведомления, нажав на соответствующие разделы. \nВы можете добавлять элементы чек листа, нажав на 'Добавить элемент'. Нажав на галочку вы меняете статус выполнения подзадачи. \n\n 4. Удаление данных. \nДля удаление ячейки используется смахивание в левую сторону. Потяните ячейку влево и нажмите кнопку 'Удалить'. \nДля удаление всех данных используется меню 'Настройки'. Для перехода в настройки нажмите на кнопку 'Настройки' в левом верхнем углу. Далее выбираем пункт 'Очистить все данные' и подтверждаем свой выбор дважды. \n\n5. Фильтры. \nПри вызове контекстного меню на задаче (долгое нажатие на ячейку) можно выбрать состояние задачи: 'Выполнено', 'Избранное'. Состояния отображаются над названием задачи. \nДля просмотра задач, добавленных в 'Избранное', необходимо нажать кнопку 'Фильтры' в правом верхнем углу и выбрать пункт 'Избранные'. \nДля просмотра задач, добавленных в 'Завершенные', необходимо нажать кнопку 'Фильтры' в правом верхнем углу и выбрать пункт 'Завершенные'."
        infoLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        infoLabel.numberOfLines = 80
        infoLabel.textAlignment = .left
        infoContentView.addSubview(infoLabel)
        
    }
    
    func constrainsInit(){
        NSLayoutConstraint.activate([
            
            scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            infoContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            infoContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            infoContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            infoContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: infoContentView.topAnchor, constant: 24),
            infoLabel.bottomAnchor.constraint(equalTo: infoContentView.bottomAnchor, constant: -60),
            infoLabel.leftAnchor.constraint(equalTo: infoContentView.leftAnchor, constant: 12),
            infoLabel.rightAnchor.constraint(equalTo: infoContentView.rightAnchor, constant: -8),
            
        ])
    }
    
    func changeTheme() {
        let theme = Main.instance.themeService.getTheme()
        infoLabel.textColor = theme.interfaceColor
    }
    
}
