//
//  NewTaskViewController.swift
//  TODO
//
//  Created by Александр Минк on 07.01.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class NewTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIColorPickerViewControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var newSectionTextField: UITextField! {didSet{
        newSectionTextField.inputView = categoryPicker
        newSectionTextField.inputAccessoryView = makeToolBarCategories()}}
    @IBOutlet weak var notificationTextField: UITextField! {didSet{
        notificationTextField.inputAccessoryView = makeToolBarNotifications()
        notificationTextField.inputView = notificationPicker
        notificationPicker.minimumDate = minDate
        if #available(iOS 13.4, *) {notificationPicker.preferredDatePickerStyle = .wheels}}}
    @IBOutlet weak var newTaskNameTextField: UITextField! {didSet{
        newTaskNameTextField.delegate = self}}
    @IBOutlet weak var checkListButton: UIButton!
    @IBOutlet weak var coverButton: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var backLayer: Rounding!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var boatImageView: UIImageView!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var fakeKB: UITextField! {
        didSet{
            fakeKB.inputAccessoryView = makeToolBarCategoryKB()
        }
    }
    @IBOutlet weak var cloudsImageView: UIImageView!
    @IBOutlet weak var cloudsWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cloudsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var boatWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var boatHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backLayerBottomConstraint: NSLayoutConstraint!
    
    
    var sections: [String]?
    var router: BaseRouter?
    let categoryPicker = UIPickerView()
    let notificationPicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var calendar = Calendar.current
    let notificationService = NotificationService()
    var selectedBackgroundColor: UIColor? = UIColor.clear
    let minDate = Calendar.current.date(byAdding: .minute, value: 2, to: Date())
    var isKeyboard = false
    private var currentTheme : String?
    
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        try? Main.instance.deleteSection(delSectionName: "")
        boatImageView.isHidden = true
        setViewScreen()
        changeState(state: Main.instance.state ?? "1")
        ParalaxEffect.paralaxEffect(view: mapImageView, magnitude: 50)
        ParalaxEffect.paralaxEffect(view: boatImageView, magnitude: 50)
        categoryPicker.delegate = self
        categoryPicker.selectedRow(inComponent: 0)
//        categoryPicker.selectRow(2, inComponent: 0, animated: true)
//        categoryPicker.selectRow(0, inComponent: 0, animated: true)
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        calendar.timeZone = .autoupdatingCurrent
        router = BaseRouter(viewController: self)
        sections = try? Main.instance.getSectionsFromRealm()
        newSectionTextField?.textAlignment = .center
        newSectionTextField?.text = sections?.count != 0 ? sections?[0] : ""
        view.addTapGestureToHideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 180, delay: 0, options: [.curveLinear, .autoreverse, .repeat], animations: {
            self.cloudsImageView.frame = .init(x: 0, y: 0, width: self.view.frame.width*2, height: self.view.frame.width)
        }, completion: nil)
    }

    
    // MARK: - ACTIONS
    
    @IBAction func createNewTaskButton(_ sender: UIButton) {
        
        func tempAddTask(sectionName: String) {
            try? Main.instance.addTask(sectionName: sectionName, name: newTaskNameTextField.text!, backgroundColor: selectedBackgroundColor, taskDescription: descriptionTextField.text, notificationDate: notificationTextField.text)
            
            guard let sectionsCount = sections?.count else { return }
            if sectionsCount > 0 {
                try? Main.instance.deleteSection(delSectionName: "")
            }
            router?.dismiss(animated: true, completion: nil)
        }
        
        // Проверка на выбранное время: выбрано время, которое истекло
        guard Main.instance.notificationDateInterval != 1.0 else {
            return showAlert(title: "Ошибка", message: "Выбрано прошедшее время")
        }
        
        // Проверка на пустые поля ввода: fakeKB, newSectionTextField, newTaskNameTextField
        if newTaskNameTextField.text == "" {
            showAlert(title: "Ошибка", message: "Не заполнено поле: Название")
        } else if fakeKB.text != ""{
            tempAddTask(sectionName: fakeKB.text ?? "")
        } else if newSectionTextField.text != "" {
            tempAddTask(sectionName: newSectionTextField.text ?? "")
        } else {
            showAlert(title: "Ошибка", message: "Не заполнено поле: Секция")
        }
    }
    
    @IBAction func pickColorButtonTapped(_ sender: UIButton) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedBackgroundColor = viewController.selectedColor
        coverButton.backgroundColor = viewController.selectedColor
        coverButton.alpha = 0.7
    }
    
    @objc func deleteCategoryAction() {
        
        try? Main.instance.deleteSection(delSectionName: newSectionTextField.text ?? "")
        
//        try? Main.instance.addSection(sectionName: "Базовая секция № 1")
        if sections?.count == 0 {
            try? Main.instance.addSection(sectionName: "")
        } else {
            try? Main.instance.deleteSection(delSectionName: "")
        }
        sections = try? Main.instance.getSectionsFromRealm()
        newSectionTextField?.text = sections?.count != 0 ? sections?[0] : ""
        categoryPicker.reloadAllComponents()
        print("Нажата кнопка удалить категорию")
        self.dismissKeyboard()
    }
    
    @objc func chooseCategoryAction() {
        print("Нажата кнопка 'Готово' выбора категории пикера")
        try? Main.instance.addSection(sectionName: newSectionTextField.text ?? "")
        if sections?.count == 0 {
            try? Main.instance.addSection(sectionName: "")
        }
        sections = try? Main.instance.getSectionsFromRealm()
        categoryPicker.reloadAllComponents()
        self.dismissKeyboard()
    }
    
    @objc func changePickerAndKeyboard() {
        print("Нажата кнопка Клавиатура")
        self.dismissKeyboard()
        if !isKeyboard {
            newSectionTextField.resignFirstResponder()
            newSectionTextField.isHidden = true
            newSectionTextField.text = ""
            fakeKB.text = ""
            fakeKB.isHidden = false
            fakeKB.becomeFirstResponder()
            isKeyboard = true
//            newSectionTextField.text = fakeKB.text
        } else {
            if sections?.count != 0 {
                try? Main.instance.deleteSection(delSectionName: "")
            }
            fakeKB.resignFirstResponder()
            fakeKB.isHidden = true
            newSectionTextField.isHidden = false
            newSectionTextField.becomeFirstResponder()
            isKeyboard = false
            categoryPicker.selectedRow(inComponent: 0)
            newSectionTextField.text = fakeKB.text
            fakeKB.text = ""
            try? Main.instance.addSection(sectionName: newSectionTextField.text ?? "")
            sections = try? Main.instance.getSectionsFromRealm()
            newSectionTextField.text = sections?.count != 0 ? sections?[0] : ""
        }
//
        categoryPicker.reloadAllComponents()
    }
    
    @objc func chooseNotificationAction() {
        notificationTextField?.text = dateFormatter.string(from: notificationPicker.date)
        Main.instance.notificationDate = dateFormatter.date(from: notificationTextField?.text ?? "")?.localString()
        print(Main.instance.notificationDate ?? "синглтон с датой тип строка", "🍏" )
        notificationService.sendNotificationRequest(
            content: notificationService.makeNotificationContent(str: newTaskNameTextField.text ?? ""),
            trigger: notificationService.makeIntervalNotificationTrigger(doub: dateFormatter.date(from: notificationTextField.text ?? "")?.timeIntervalSince1970 ?? Date().timeIntervalSince1970+1000 )
        )
        self.dismissKeyboard()
    }
    
    // MARK: - PICKER
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newSectionTextField?.text = sections?.count != 0 ? sections?[row] : ""
        print(categoryPicker.selectedRow(inComponent: 0))
    }
    
    //MARK: - CHANGE STATE SETTINGS
    func changeState(state: String) {
        self.currentTheme = state
        switch Main.instance.state {
        case "1":
            mapImageView.isHidden = false
            boatImageView.isHidden = true
            newSectionTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Выберите или создайте секцию", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.systemYellow]))
            newSectionTextField.textColor = .systemYellow
            fakeKB.textColor = .yellow
            newTaskNameTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Название", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.systemYellow]))
            newTaskNameTextField.textColor = .systemYellow
            descriptionTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Описание", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.systemYellow]))
            descriptionTextField.textColor = .systemYellow
            notificationTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Напоминание", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.systemYellow]))
            notificationTextField.textColor = .systemYellow
            coverButton.setTitleColor(.systemYellow, for: .normal)
            coverButton.setTitleColor(.systemYellow, for: .highlighted)
            checkListButton.setTitleColor(.systemYellow, for: .normal)
            checkListButton.setTitleColor(.systemYellow, for: .highlighted)
            createButton.setTitleColor(.systemYellow, for: .normal)
            createButton.setTitleColor(.systemYellow, for: .highlighted)  
        case "2":
            mapImageView.isHidden = true
            boatImageView.isHidden = false
            newSectionTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Выберите или создайте секцию", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.alexeyBackground]))
            newSectionTextField.textColor = .alexeyBackground
            fakeKB.textColor = .alexeyBackground
            newTaskNameTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Название", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.alexeyBackground]))
            newTaskNameTextField.textColor = .alexeyBackground
            descriptionTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Описание", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.alexeyBackground]))
            descriptionTextField.textColor = .alexeyBackground
            notificationTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Напоминание", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.alexeyBackground]))
            notificationTextField.textColor = .alexeyBackground
            coverButton.setTitleColor(.alexeyBackground, for: .normal)
            coverButton.setTitleColor(.alexeyBackground, for: .highlighted)
            checkListButton.setTitleColor(.alexeyBackground, for: .normal)
            checkListButton.setTitleColor(.alexeyBackground, for: .highlighted)
            createButton.setTitleColor(.alexeyBackground, for: .normal)
            createButton.setTitleColor(.alexeyBackground, for: .highlighted)
            cloudsImageView.isHidden = true
        case "3":
            boatImageView.isHidden = true
            mapImageView.isHidden = true
            newSectionTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Выберите или создайте секцию", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.cyan]))
            newSectionTextField.textColor = .cyan
            fakeKB.textColor = .cyan
            newTaskNameTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Название", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.cyan]))
            newTaskNameTextField.textColor = .cyan
            descriptionTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Описание", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.cyan]))
            descriptionTextField.textColor = .cyan
            notificationTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Напоминание", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.cyan]))
            notificationTextField.textColor = .cyan
            coverButton.setTitleColor(.cyan, for: .normal)
            coverButton.setTitleColor(.cyan, for: .highlighted)
            checkListButton.setTitleColor(.cyan, for: .normal)
            checkListButton.setTitleColor(.cyan, for: .highlighted)
            createButton.setTitleColor(.cyan, for: .normal)
            createButton.setTitleColor(.cyan, for: .highlighted)
        case "4":
            break
        default:
            break
        }
    }
    
    // MARK: - SET VIEW SCREEN
    func setViewScreen() {
        view.applyGradient(colours: [.vitDarkBrown, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        backLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        blurView.layer.cornerRadius = 24
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.darkGray.cgColor
        
        navigationController?.navigationBar.barTintColor = .vitDarkBrown
        createButton.setTitle("Создать", for: .normal)
        mapWidthConstraint.constant = view.frame.width*3.2
        mapHeightConstraint.constant = view.frame.width*1.6
        self.cloudsImageView.frame = .init(x: -view.frame.width*4, y: 40, width: view.frame.width*2, height: view.frame.width)
        cloudsWidthConstraint.constant = view.frame.width*5.0
        cloudsHeightConstraint.constant = view.frame.width*1.6
        boatWidthConstraint.constant = view.frame.width*1.8
        boatHeightConstraint.constant = view.frame.width*1.8
        stackBottomConstraint.constant = view.frame.height/4
        backLayerBottomConstraint.constant = view.frame.height/4 - 8
        
        // separators in stackView
        let borderWidth: CGFloat = 1
        let borderColor = UIColor.systemGray.cgColor
        
        newTaskNameTextField.layer.borderWidth = borderWidth
        newTaskNameTextField.layer.borderColor = borderColor
        
        descriptionTextField.layer.borderWidth = borderWidth
        descriptionTextField.layer.borderColor = borderColor
        
        checkListButton.layer.borderWidth = borderWidth
        checkListButton.layer.borderColor = borderColor
    }
    //MARK: - CHARACTER LIMIT
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text, newText: string, limit: 200)
    }
            
    private func textLimit(existingText: String?, newText: String, limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
}
