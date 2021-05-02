//
//  TaskDetailViewController.swift
//  TODO
//
//  Created by Алексей Мальков on 29.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, UITableViewDelegate{
    
    //MARK: - VARIABLES
    var doneButton = UIButton(type: .system)
    var taskNameTitleLabel = UILabel()
    var taskNameTextView = UITextView()
    var taskCreationDateTitleLabel = UILabel()
    var taskCreationDateLabel = UILabel()
    var taskDateTitleLabel = UILabel()
    var taskDateTextField = UITextField()
    var taskDescriptionTitleLabel = UILabel()
    var taskDescriptionTextView = UITextView()
    var checkBlurView: UIVisualEffectView!
    var toolBarView: UIView!
    var toolBarStackView: UIStackView!
    var addCheckButton = UIButton(type: .system)
    var cancelCheckButton = UIButton(type: .system)
    let checkListTableView = UITableView()
    
    var task: Task? = Task()
    let dateFormatter = DateFormatter()
    var notificationPicker = UIDatePicker()
    var router: BaseRouter?
    let notificationService = NotificationService()
    private var currentTheme : String?

    var testDataForTableView = ["uno", "dos", "tres", "quatro", "cinco", "sies"]
    
    //MARK: - LABEL FACTORY
    func labelFactory(lab: UILabel, text: String, color: UIColor) -> UILabel {
        var label = lab
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.textColor = color
        view.addSubview(label)
        return label
    }
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        router = BaseRouter(viewController: self)
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        uiSetUp()
        
        constrainsInit()
        
        view.addTapGestureToHideKeyboard()
        
        changeState(state: Main.instance.state ?? "1")
        
    }
    
    //MARK: - UI SET UP
    func uiSetUp(){
        
        doneButton.setTitle("Готово", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.tintColor = .systemYellow
        doneButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(doneButton)
        doneButton.addTarget(self,
                             action: #selector(handleDoneTouchUpInside),
                             for: .touchUpInside)
        
        taskNameTitleLabel = labelFactory(lab: self.taskNameTitleLabel, text: "Задача", color: .systemGray)
        
        taskNameTextView.translatesAutoresizingMaskIntoConstraints = false
        taskNameTextView.text = (task?.name != "" ? task?.name : "Напишите название задачи")
        taskNameTextView.backgroundColor = UIColor.clear
        taskNameTextView.isEditable = true
        taskNameTextView.isScrollEnabled = true
        taskNameTextView.textColor = .systemYellow
        taskNameTextView.contentInsetAdjustmentBehavior = .automatic
        taskNameTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskNameTextView)
        
        taskCreationDateTitleLabel = labelFactory(lab: self.taskCreationDateTitleLabel, text: "Дата регестрации задачи:", color: .systemGray)
        
        taskCreationDateLabel = labelFactory(lab: self.taskCreationDateLabel, text: dateFormatter.string(from: task?.creationDate ?? Date()), color: .systemYellow)
        
        taskDateTitleLabel = labelFactory(lab: self.taskDateTitleLabel, text: "Дата уведомления задачи:", color: .systemGray)
        
        taskDateTextField.translatesAutoresizingMaskIntoConstraints = false
        taskDateTextField.text = task?.notificationDate
        taskDateTextField.textColor = .systemYellow
        taskDateTextField.font = UIFont(name: "HelveticaNeue", size: 17)
        taskDateTextField.inputView = notificationPicker
        taskDateTextField.inputAccessoryView = makeToolBarNotificationsDetail()
        taskDateTextField.clearsOnBeginEditing = true
        if #available(iOS 13.4, *) {notificationPicker.preferredDatePickerStyle = .wheels}
        taskDateTextField.keyboardAppearance = .dark
        view.addSubview(taskDateTextField)
        if taskDateTextField.text == "" { taskDateTextField.text = "Дата уведомления не назначена" }
        
        taskDescriptionTitleLabel = labelFactory(lab: self.taskDescriptionTitleLabel, text: "Описание задачи:", color: .systemGray)
        
        taskDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        taskDescriptionTextView.backgroundColor = UIColor.clear
        taskDescriptionTextView.contentInsetAdjustmentBehavior = .automatic
        taskDescriptionTextView.isEditable = true
        taskDescriptionTextView.isScrollEnabled = true
        taskDescriptionTextView.text = (task?.taskDescription != "" ? task?.taskDescription : "Напишите описание задачи")
        taskDescriptionTextView.textAlignment = .left
        taskDescriptionTextView.textColor = .systemYellow
        taskDescriptionTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskDescriptionTextView)
        
        checkBlurView = UIVisualEffectView()
        checkBlurView.translatesAutoresizingMaskIntoConstraints = false
        checkBlurView.backgroundColor = .clear
        checkBlurView.effect = UIBlurEffect(style: .systemThinMaterial)
        view.addSubview(checkBlurView)
        
        toolBarView = UIView()
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        checkBlurView.contentView.addSubview(toolBarView)
        
        toolBarStackView = UIStackView()
        toolBarStackView.translatesAutoresizingMaskIntoConstraints = false
        toolBarStackView.axis = .horizontal
        toolBarStackView.alignment = .fill
        toolBarStackView.distribution = .fillEqually
        toolBarView.addSubview(toolBarStackView)
        
        addCheckButton.translatesAutoresizingMaskIntoConstraints = false
        addCheckButton.setTitle("+", for: .normal)
        addCheckButton.tintColor = .black
        addCheckButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        toolBarStackView.addArrangedSubview(addCheckButton)
        
        cancelCheckButton.translatesAutoresizingMaskIntoConstraints = false
        cancelCheckButton.setTitle("Отменить", for: .normal)
        cancelCheckButton.tintColor = .black
        cancelCheckButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        toolBarStackView.addArrangedSubview(cancelCheckButton)

        checkListTableView.backgroundColor = .clear
        checkListTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkListTableView)
        checkListTableView.register(CheckTableViewCell.self, forCellReuseIdentifier: "cell")
        checkListTableView.rowHeight = 48
        checkListTableView.dataSource = self
        checkListTableView.delegate = self
    }
    
    //MARK: - ACTIONS
    @objc func handleDoneTouchUpInside(){
        task?.name = taskNameTextView.text
        task?.taskDescription = (taskDescriptionTextView.text == "Напишите описание задачи" ? "" : taskDescriptionTextView.text)
        task?.notificationDate = (taskDateTextField.text == "Дата уведомления не назначена" ? "" : taskDateTextField.text)
        guard let task = task else { return }
        try? Main.instance.updateTask(task: task)
        router?.dismiss(animated: true, completion: nil)
    }
    
    @objc func chooseNotificationAction() {
        taskDateTextField.text = dateFormatter.string(from: notificationPicker.date)
        Main.instance.notificationDate = dateFormatter.date(from: taskDateTextField.text ?? "")?.localString()
        print(Main.instance.notificationDate ?? "синглтон с датой тип строка", "🍏" )
//        notificationService.sendNotificationRequest(
//            content: notificationService.makeNotificationContent(str: taskNameTextView.text ?? ""),
//            trigger: notificationService.makeIntervalNotificationTrigger(double: dateFormatter.date(from: taskDateTextField.text ?? "")?.timeIntervalSince1970 ?? Date().timeIntervalSince1970+1000 )
//        )
        view.endEditing(true)
    }
    
    //MARK: - CONSTRIAINTS
    func constrainsInit(){
        NSLayoutConstraint.activate([
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            
            taskNameTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            taskNameTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskNameTextView.topAnchor.constraint(equalTo: taskNameTitleLabel.topAnchor, constant: 24),
            taskNameTextView.bottomAnchor.constraint(equalTo: taskCreationDateTitleLabel.topAnchor, constant: 2),
            taskNameTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            taskNameTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            
            taskCreationDateTitleLabel.topAnchor.constraint(equalTo: taskNameTextView.topAnchor, constant: 48),
            taskCreationDateTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskCreationDateLabel.topAnchor.constraint(equalTo: taskCreationDateTitleLabel.topAnchor, constant: 28),
            taskCreationDateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDateTitleLabel.topAnchor.constraint(equalTo: taskCreationDateLabel.topAnchor, constant: 36),
            taskDateTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDateTextField.topAnchor.constraint(equalTo: taskDateTitleLabel.topAnchor, constant: 28),
            taskDateTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDescriptionTitleLabel.topAnchor.constraint(equalTo: taskDateTextField.topAnchor, constant: 36),
            taskDescriptionTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            taskDescriptionTextView.topAnchor.constraint(equalTo: taskDescriptionTitleLabel.topAnchor, constant: 24),
            taskDescriptionTextView.bottomAnchor.constraint(equalTo: checkBlurView.topAnchor, constant: -4),
            taskDescriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            taskDescriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            
            checkBlurView.topAnchor.constraint(equalTo: taskDescriptionTextView.topAnchor, constant: 76),
            checkBlurView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28),
            checkBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            checkBlurView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28),
            
            toolBarView.topAnchor.constraint(equalTo: checkBlurView.topAnchor, constant: 0),
            toolBarView.leftAnchor.constraint(equalTo: checkBlurView.leftAnchor, constant: 0),
            toolBarView.rightAnchor.constraint(equalTo: checkBlurView.rightAnchor, constant: 0),
            toolBarView.heightAnchor.constraint(equalToConstant: 36),
            
            toolBarStackView.topAnchor.constraint(equalTo: toolBarView.topAnchor, constant: 0),
            toolBarStackView.leftAnchor.constraint(equalTo: toolBarView.leftAnchor, constant: 0),
            toolBarStackView.rightAnchor.constraint(equalTo: toolBarView.rightAnchor, constant: 0),
            toolBarStackView.bottomAnchor.constraint(equalTo: toolBarView.bottomAnchor, constant: 0),
            
            checkListTableView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor, constant: 0),
            checkListTableView.leftAnchor.constraint(equalTo: checkBlurView.contentView.leftAnchor, constant: 0),
            checkListTableView.bottomAnchor.constraint(equalTo: checkBlurView.contentView.bottomAnchor, constant: 0),
            checkListTableView.rightAnchor.constraint(equalTo: checkBlurView.contentView.rightAnchor, constant: 0),
            
        ])
    }
    
    //MARK: - CHANGE STATE SETTINGS
    func changeState(state: String) {
        self.currentTheme = state
        switch Main.instance.state {
        case "1":
            doneButton.tintColor = .systemYellow
            taskNameTextView.textColor = .systemYellow
            taskCreationDateLabel.textColor = .systemYellow
            taskDateTextField.textColor = .systemYellow
            taskDescriptionTextView.textColor = .systemYellow
            toolBarView.backgroundColor = .systemYellow
            view.backgroundColor = .systemYellow
            view.applyGradient(colours: [.vitDarkBrown, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        case "2":
            doneButton.tintColor = .alexeyBackground
            taskNameTextView.textColor = .alexeyBackground
            taskCreationDateLabel.textColor = .alexeyBackground
            taskDateTextField.textColor = .alexeyBackground
            taskDescriptionTextView.textColor = .alexeyBackground
            toolBarView.backgroundColor = .alexeyBackground
            view.backgroundColor = .alexeyBackground
            view.applyGradient(colours: [.alexeyFog, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        case "3":
            doneButton.tintColor = .alexDarkRed
            taskNameTextView.textColor = .alexDarkRed
            taskCreationDateLabel.textColor = .alexDarkRed
            taskDateTextField.textColor = .alexDarkRed
            taskDescriptionTextView.textColor = .alexDarkRed
            toolBarView.backgroundColor = .alexDarkRed
            view.backgroundColor = .alexLightGray
            view.applyGradient(colours: [.alexDarkRed, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        default:
            break
        }
    }
    
}

    //MARK: - TEBLEVIEW EXTENSION
extension TaskDetailViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testDataForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CheckTableViewCell
        cell?.checkListItemTextField.text = cell?.rowText
        return cell!
    }
    
}
