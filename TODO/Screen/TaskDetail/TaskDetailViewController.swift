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
    var addCheckElementTextField = UITextField()
    let checkListTableView = UITableView()
    
    var task: Task = Task()
    let dateFormatter = DateFormatter()
    var notificationPicker = UIDatePicker()
    var router: BaseRouter?
    let notificationService = NotificationService()
    private var currentTheme : String?
    
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
        view.applyGradient(colours: [.vitDarkBrown, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
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
        taskNameTextView.text = (task.name != "" ? task.name : "Напишите название задачи")
        taskNameTextView.backgroundColor = UIColor.clear
        taskNameTextView.isEditable = true
        taskNameTextView.isScrollEnabled = true
        taskNameTextView.textColor = .systemYellow
        taskNameTextView.contentInsetAdjustmentBehavior = .automatic
        taskNameTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        view.addSubview(taskNameTextView)
        
        taskCreationDateTitleLabel = labelFactory(lab: self.taskCreationDateTitleLabel, text: "Дата регестрации задачи:", color: .systemGray)
        
        taskCreationDateLabel = labelFactory(lab: self.taskCreationDateLabel, text: dateFormatter.string(from: task.creationDate), color: .systemYellow)
        
        taskDateTitleLabel = labelFactory(lab: self.taskDateTitleLabel, text: "Дата уведомления задачи:", color: .systemGray)
        
        taskDateTextField.translatesAutoresizingMaskIntoConstraints = false
        taskDateTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Дата уведомления не назначена", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.systemYellow]))
        taskDateTextField.text = task.notificationDate
        taskDateTextField.textColor = .systemYellow
        taskDateTextField.font = UIFont(name: "HelveticaNeue", size: 17)
        taskDateTextField.inputView = notificationPicker
        taskDateTextField.inputAccessoryView = makeToolBarNotificationsDetail()
        taskDateTextField.clearsOnBeginEditing = true
        if #available(iOS 13.4, *) {notificationPicker.preferredDatePickerStyle = .wheels}
        taskDateTextField.keyboardAppearance = .dark
        view.addSubview(taskDateTextField)
        
        taskDescriptionTitleLabel = labelFactory(lab: self.taskDescriptionTitleLabel, text: "Описание задачи:", color: .systemGray)
        
        taskDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        taskDescriptionTextView.backgroundColor = UIColor.clear
        taskDescriptionTextView.contentInsetAdjustmentBehavior = .automatic
        taskDescriptionTextView.isEditable = true
        taskDescriptionTextView.isScrollEnabled = true
        taskDescriptionTextView.text = (task.taskDescription != "" ? task.taskDescription : "Напишите описание задачи")
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
        toolBarStackView.distribution = .fill
        toolBarView.addSubview(toolBarStackView)
        
        addCheckElementTextField.translatesAutoresizingMaskIntoConstraints = false
        addCheckElementTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Добавить элемент", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.systemYellow]))
        addCheckElementTextField.text = ""
        addCheckElementTextField.textColor = .black
        addCheckElementTextField.font = UIFont(name: "HelveticaNeue", size: 17)
        addCheckElementTextField.clearsOnBeginEditing = true
        addCheckElementTextField.backgroundColor = .lightGray
        addCheckElementTextField.borderStyle = .roundedRect
        toolBarStackView.addArrangedSubview(addCheckElementTextField)
        
        addCheckButton.translatesAutoresizingMaskIntoConstraints = false
        addCheckButton.setTitle("+", for: .normal)
        addCheckButton.tintColor = .black
        addCheckButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        addCheckButton.addTarget(self,
                             action: #selector(checkTablePlusAction),
                             for: .touchUpInside)
        toolBarStackView.addArrangedSubview(addCheckButton)

        checkListTableView.backgroundColor = .vitBackground
        checkListTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkListTableView)
        checkListTableView.register(CheckTableViewCell.self, forCellReuseIdentifier: "cell")
        checkListTableView.rowHeight = 48
        checkListTableView.dataSource = self
        checkListTableView.delegate = self
    }
    
    //MARK: - ACTIONS
    @objc func handleDoneTouchUpInside(){
        task.name = (taskNameTextView.text == "Напишите название задачи" ? "" : taskNameTextView.text)
        task.taskDescription = (taskDescriptionTextView.text == "Напишите описание задачи" ? "" : taskDescriptionTextView.text)
        if taskDateTextField.text != task.notificationDate {
            if taskDateTextField.text == "" {
                print("delete")
                notificationService.deleteNotificationRequest(notificationIdentifier: (task.notificationID)!)
                task.notificationID = ""
                taskDateTextField.text = ""
            } else {
                print("update")
                task.notificationID = notificationService.updateNotificationRequest(task: task, notificationIdentifier: task.notificationID!)
            }
        }
        task.notificationDate = taskDateTextField.text
        
        try? Main.instance.updateTask(task: task)
        router?.dismiss(animated: true, completion: nil)
    }
    
    @objc func chooseNotificationAction() {
        taskDateTextField.text = dateFormatter.string(from: notificationPicker.date)
        Main.instance.notificationDate = dateFormatter.date(from: taskDateTextField.text ?? "")?.localString()
        print(Main.instance.notificationDate ?? "синглтон с датой тип строка", "🍏" )
        view.endEditing(true)
    }
    
    @objc func checkTablePlusAction(){
        let id = (task.checkList.max()?.id ?? 0) + 1
        print("plus id: ", id)
        let checkMark = CheckMark(id: id, title: addCheckElementTextField.text ?? "", isMarkSelected: false)
        task.checkList.append(checkMark)
        addCheckElementTextField.text = ""
        addCheckElementTextField.becomeFirstResponder()
        checkListTableView.reloadData()
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
            taskNameTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
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
            taskDescriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            taskDescriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            
            checkBlurView.topAnchor.constraint(equalTo: taskDescriptionTextView.topAnchor, constant: 76),
            checkBlurView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            checkBlurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            checkBlurView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            
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
            
            addCheckButton.widthAnchor.constraint(equalToConstant: 46)
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
//            addCheckElementTextField.textColor = .systemYellow
            toolBarView.backgroundColor = .systemYellow
            view.backgroundColor = .systemYellow
            view.applyGradient(colours: [.vitDarkBrown, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        case "2":
            doneButton.tintColor = .alexeyBackground
            taskNameTextView.textColor = .alexeyBackground
            taskCreationDateLabel.textColor = .alexeyBackground
            taskDateTextField.textColor = .alexeyBackground
            taskDescriptionTextView.textColor = .alexeyBackground
//            addCheckElementTextField.textColor = .alexeyBackground
            toolBarView.backgroundColor = .alexeyBackground
            view.backgroundColor = .alexeyBackground
            view.applyGradient(colours: [.alexeyFog, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        case "3":
            doneButton.tintColor = .alexDarkRed
            taskNameTextView.textColor = .alexDarkRed
            taskCreationDateLabel.textColor = .alexDarkRed
            taskDateTextField.textColor = .alexDarkRed
            taskDescriptionTextView.textColor = .alexDarkRed
//            addCheckElementTextField.textColor = .red
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
        return task.checkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CheckTableViewCell else { return UITableViewCell() }
        
        let checkMark = task.checkList[indexPath.row]
        
        cell.checkListItemTextField.text = checkMark.title
        
        checkMark.isMarkSelected ? cell.checkMarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) : cell.checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        
        let strikedText = NSMutableAttributedString(string: checkMark.title)
        strikedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 3, range: NSMakeRange(0, strikedText.length))
        let normalText = NSMutableAttributedString(string: checkMark.title)
        normalText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, normalText.length))
        cell.checkListItemTextField.text = checkMark.title
        cell.checkListItemTextField.attributedText = checkMark.isMarkSelected ?  strikedText : normalText
        cell.checkListItemTextField.tag = indexPath.row
        cell.checkListItemTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cell.checkMarkButton.addTarget(self, action: #selector(self.toggleSelected(button:)), for: .touchUpInside)
        cell.checkMarkButton.tag = indexPath.row
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            task.checkList.remove(at: indexPath.row)
            checkListTableView.deleteRows(at: [indexPath], with: .fade)
        }
        checkListTableView.reloadData()
    }
    
    @objc func toggleSelected(button: UIButton) {
        if task.checkList[button.tag].isMarkSelected {
            task.markSelectedCount -= 1
        } else {
            task.markSelectedCount += 1
        }
        task.checkList[button.tag].isMarkSelected.toggle()
        checkListTableView.reloadData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        task.checkList[textField.tag].title = textField.text ?? ""

    }
    
}
