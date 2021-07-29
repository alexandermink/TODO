//
//  TaskDetailView.swift
//  TODO
//
//  Created by Алексей Мальков on 08.06.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

protocol TaskDetailDelegate {
    func taskDetailDismiss()
}

class TaskDetailView: UIView, UITableViewDelegate {
        
    //MARK: - VARIABLES
    let scrollView = UIScrollView()
    let detailContentView = UIView()
    var taskNameTitleLabel = UILabel()
    let taskNameTextView = UITextView()
    var taskCreationDateTitleLabel = UILabel()
    var taskCreationDateLabel = UILabel()
    var taskDateTitleLabel = UILabel()
    let taskDateTextField = UITextField()
    var taskDescriptionTitleLabel = UILabel()
    let taskDescriptionTextView = UITextView()
    var checkBlurView: UIVisualEffectView!
    var toolBarView: UIView!
    var toolBarStackView: UIStackView!
    let addCheckButton = UIButton(type: .system)
    let addCheckElementTextField = UITextField()
    let checkListTableView = UITableView()
    
    var notificationPicker = UIDatePicker()
    let notificationService = Main.instance.notificationService

    let minDate = Calendar.current.date(byAdding: .minute, value: 2, to: Date())
    var delegate: TaskDetailDelegate?
    
    //MARK: - LABEL FACTORY
    func labelFactory(lab: UILabel, text: String, color: UIColor) -> UILabel {
        var label = lab
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.textColor = color
        detailContentView.addSubview(label)
        return label
    }
    
    //MARK: - LIFE CYCLE
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .mainBackground
        let theme = Main.instance.themeService.getTheme()
        self.applyGradient(colours: [theme.backgroundColor, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        notificationPicker.minimumDate = minDate
        uiSetUp()
        constrainsInit()
        self.addTapGestureToHideKeyboard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - UI SET UP
    func uiSetUp(){
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        detailContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(detailContentView)
        
        taskNameTitleLabel = labelFactory(lab: self.taskNameTitleLabel, text: "Задача", color: .systemGray)
        
        taskNameTextView.translatesAutoresizingMaskIntoConstraints = false
        taskNameTextView.backgroundColor = UIColor.clear
        taskNameTextView.isEditable = true
        taskNameTextView.isScrollEnabled = true
        taskNameTextView.textColor = .systemYellow
        taskNameTextView.contentInsetAdjustmentBehavior = .automatic
        taskNameTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        taskNameTextView.keyboardAppearance = .dark
        detailContentView.addSubview(taskNameTextView)
        
        taskCreationDateTitleLabel = labelFactory(lab: self.taskCreationDateTitleLabel, text: "Дата регестрации задачи:", color: .systemGray)
        
        taskCreationDateLabel = labelFactory(lab: self.taskCreationDateLabel, text: "", color: .systemYellow)
        
        taskDateTitleLabel = labelFactory(lab: self.taskDateTitleLabel, text: "Дата уведомления задачи:", color: .systemGray)
        
        taskDateTextField.translatesAutoresizingMaskIntoConstraints = false
        taskDateTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Дата уведомления не назначена", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.systemYellow]))
        taskDateTextField.textColor = .systemYellow
        taskDateTextField.font = UIFont(name: "HelveticaNeue", size: 17)
        taskDateTextField.inputView = notificationPicker
        taskDateTextField.clearsOnBeginEditing = true
        if #available(iOS 13.4, *) {notificationPicker.preferredDatePickerStyle = .wheels}
        taskDateTextField.keyboardAppearance = .dark
        detailContentView.addSubview(taskDateTextField)
        
        taskDescriptionTitleLabel = labelFactory(lab: self.taskDescriptionTitleLabel, text: "Описание задачи:", color: .systemGray)
        
        taskDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        taskDescriptionTextView.backgroundColor = UIColor.clear
        taskDescriptionTextView.contentInsetAdjustmentBehavior = .automatic
        taskDescriptionTextView.isEditable = true
        taskDescriptionTextView.isScrollEnabled = true
        taskDescriptionTextView.textAlignment = .left
        taskDescriptionTextView.textColor = .systemYellow
        taskDescriptionTextView.font = UIFont(name: "HelveticaNeue", size: 17)
        taskDescriptionTextView.keyboardAppearance = .dark
        detailContentView.addSubview(taskDescriptionTextView)
        
        checkBlurView = UIVisualEffectView()
        checkBlurView.translatesAutoresizingMaskIntoConstraints = false
        checkBlurView.backgroundColor = .clear
        checkBlurView.effect = UIBlurEffect(style: .systemThinMaterial)
        detailContentView.addSubview(checkBlurView)
        
        toolBarView = UIView()
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        toolBarView.backgroundColor = .systemYellow
        checkBlurView.contentView.addSubview(toolBarView)
        
        toolBarStackView = UIStackView()
        toolBarStackView.translatesAutoresizingMaskIntoConstraints = false
        toolBarStackView.axis = .horizontal
        toolBarStackView.alignment = .fill
        toolBarStackView.distribution = .fill
        toolBarView.addSubview(toolBarStackView)
        
        addCheckElementTextField.translatesAutoresizingMaskIntoConstraints = false
        addCheckElementTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Добавить элемент", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.systemYellow]))
        addCheckElementTextField.text = ""
        addCheckElementTextField.textColor = .systemYellow
        addCheckElementTextField.font = UIFont(name: "HelveticaNeue", size: 15)
        addCheckElementTextField.clearsOnBeginEditing = true
        addCheckElementTextField.backgroundColor = .mainBackground
        addCheckElementTextField.borderStyle = .roundedRect
        addCheckElementTextField.keyboardAppearance = .dark
        toolBarStackView.addArrangedSubview(addCheckElementTextField)
        
        addCheckButton.translatesAutoresizingMaskIntoConstraints = false
        addCheckButton.setImage(UIImage(systemName: "plus.app"), for: .normal)
        addCheckButton.tintColor = .mainBackground
        addCheckButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 22)
        toolBarStackView.addArrangedSubview(addCheckButton)

        checkListTableView.backgroundColor = .mainBackground
        checkListTableView.translatesAutoresizingMaskIntoConstraints = false
        detailContentView.addSubview(checkListTableView)
        checkListTableView.register(CheckTableViewCell.self, forCellReuseIdentifier: "cell")
        checkListTableView.rowHeight = 48
        checkListTableView.delegate = self
    }
    
    //MARK: - CONSTRIAINTS
    func constrainsInit(){
        NSLayoutConstraint.activate([
            
            scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            detailContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            detailContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            detailContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            detailContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            taskNameTitleLabel.topAnchor.constraint(equalTo: detailContentView.topAnchor, constant: 20),
            taskNameTitleLabel.leftAnchor.constraint(equalTo: detailContentView.leftAnchor, constant: 12),
            
            taskNameTextView.topAnchor.constraint(equalTo: taskNameTitleLabel.topAnchor, constant: 20),
            taskNameTextView.bottomAnchor.constraint(equalTo: taskCreationDateTitleLabel.topAnchor, constant: 2),
            taskNameTextView.leftAnchor.constraint(equalTo: detailContentView.leftAnchor, constant: 8),
            taskNameTextView.rightAnchor.constraint(equalTo: detailContentView.rightAnchor, constant: -12),
            
            taskCreationDateTitleLabel.topAnchor.constraint(equalTo: taskNameTextView.topAnchor, constant: 48),
            taskCreationDateTitleLabel.leftAnchor.constraint(equalTo: detailContentView.leftAnchor, constant: 12),
            
            taskCreationDateLabel.topAnchor.constraint(equalTo: taskCreationDateTitleLabel.topAnchor, constant: 28),
            taskCreationDateLabel.leftAnchor.constraint(equalTo: detailContentView.leftAnchor, constant: 12),
            
            taskDateTitleLabel.topAnchor.constraint(equalTo: taskCreationDateLabel.topAnchor, constant: 36),
            taskDateTitleLabel.leftAnchor.constraint(equalTo: detailContentView.leftAnchor, constant: 12),
            
            taskDateTextField.topAnchor.constraint(equalTo: taskDateTitleLabel.topAnchor, constant: 28),
            taskDateTextField.leftAnchor.constraint(equalTo: detailContentView.leftAnchor, constant: 12),
            
            taskDescriptionTitleLabel.topAnchor.constraint(equalTo: taskDateTextField.topAnchor, constant: 36),
            taskDescriptionTitleLabel.leftAnchor.constraint(equalTo: detailContentView.leftAnchor, constant: 12),
            
            taskDescriptionTextView.topAnchor.constraint(equalTo: taskDescriptionTitleLabel.topAnchor, constant: 20),
            taskDescriptionTextView.bottomAnchor.constraint(equalTo: checkBlurView.topAnchor, constant: -4),
            taskDescriptionTextView.leftAnchor.constraint(equalTo: detailContentView.leftAnchor, constant: 8),
            taskDescriptionTextView.rightAnchor.constraint(equalTo: detailContentView.rightAnchor, constant: -12),
            
            checkBlurView.topAnchor.constraint(equalTo: taskDescriptionTextView.topAnchor, constant: 116),
            checkBlurView.leftAnchor.constraint(equalTo: detailContentView.leftAnchor, constant: 0),
            checkBlurView.bottomAnchor.constraint(equalTo: detailContentView.bottomAnchor, constant: -300),
            checkBlurView.rightAnchor.constraint(equalTo: detailContentView.rightAnchor, constant: 0),
            
            toolBarView.topAnchor.constraint(equalTo: checkBlurView.topAnchor, constant: 0),
            toolBarView.leftAnchor.constraint(equalTo: checkBlurView.leftAnchor, constant: 0),
            toolBarView.rightAnchor.constraint(equalTo: checkBlurView.rightAnchor, constant: 0),
            toolBarView.bottomAnchor.constraint(equalTo: checkBlurView.bottomAnchor, constant: 0),
            toolBarView.heightAnchor.constraint(equalToConstant: 40),
            
            toolBarStackView.topAnchor.constraint(equalTo: toolBarView.topAnchor, constant: 6),
            toolBarStackView.leftAnchor.constraint(equalTo: toolBarView.leftAnchor, constant: 6),
            toolBarStackView.rightAnchor.constraint(equalTo: toolBarView.rightAnchor, constant: 6),
            toolBarStackView.bottomAnchor.constraint(equalTo: toolBarView.bottomAnchor, constant: -6),
            
            checkListTableView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor, constant: 0),
            checkListTableView.leftAnchor.constraint(equalTo: checkBlurView.contentView.leftAnchor, constant: 0),
            checkListTableView.bottomAnchor.constraint(equalTo: detailContentView.bottomAnchor, constant: 0),
            checkListTableView.rightAnchor.constraint(equalTo: checkBlurView.contentView.rightAnchor, constant: 0),
            
            addCheckButton.widthAnchor.constraint(equalToConstant: 54)
        ])
    }

    //MARK: - CHANGE THEME
    func changeTheme() {
        let theme = Main.instance.themeService.getTheme()
        taskNameTextView.textColor = theme.interfaceColor
        taskCreationDateLabel.textColor = theme.interfaceColor
        taskDateTextField.textColor = theme.interfaceColor
        taskDescriptionTextView.textColor = theme.interfaceColor
        addCheckElementTextField.textColor = theme.interfaceColor
        toolBarView.backgroundColor = theme.interfaceColor
        self.backgroundColor = theme.interfaceColor
        self.applyGradient(colours: [theme.backgroundColor, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        addCheckElementTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Добавить элемент", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: theme.interfaceColor]))
        taskDateTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Дата уведомления не назначена", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: theme.interfaceColor]))
    }
    
}
