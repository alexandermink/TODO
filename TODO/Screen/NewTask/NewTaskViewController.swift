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
        newTaskNameTextField.inputAccessoryView = makeBaseToolBar()
        newTaskNameTextField.delegate = self}}
    @IBOutlet weak var checkListButton: UIButton!
    @IBOutlet weak var coverButton: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField! {didSet {
            descriptionTextField.inputAccessoryView = makeBaseToolBar()}}
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var backLayer: Rounding!
    
    @IBOutlet weak var mainBGImageView: UIImageView!
    @IBOutlet weak var mainBGHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainBGWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainBGLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var minorBGImageView: UIImageView!
    @IBOutlet weak var minorBGWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var minorBGHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var minorBGLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var substituteCategoryTextField: UITextField! {didSet{
        substituteCategoryTextField.inputAccessoryView = makeToolBarCategory()}}
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backLayerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkTableTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var checkBlurView: UIVisualEffectView!
    
    //Checklist IBOutlet
    @IBOutlet weak var checkToolBarView: UIView!
    
    @IBOutlet weak var checkToolBarTextField: UITextField!
    
    @IBOutlet weak var checklistHideButton: UIButton!
    @IBOutlet weak var checkPlusButton: UIButton!
    @IBOutlet weak var checklistDoneButton: UIButton!
    
    @IBOutlet weak var checkListTableView: UITableView!
    
    @IBOutlet weak var blurBGView: UIView!
    
    
    var sections: [String]?
    var router: BaseRouter?
    let categoryPicker = UIPickerView()
    let notificationPicker = UIDatePicker()
    let dateFormatter = Main.instance.dateFormatter
    var calendar = Calendar.current
    let notificationService = Main.instance.notificationService
    var selectedBackgroundColor: UIColor? = UIColor.clear
    let minDate = Calendar.current.date(byAdding: .minute, value: 2, to: Date())
    var isKeyboard = false
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        view.backgroundColor = nil
        try? Main.instance.deleteSection(delSectionName: "")
        setViewScreen()
        categoryPicker.delegate = self
        categoryPicker.selectedRow(inComponent: 0)
        calendar.timeZone = .autoupdatingCurrent
        router = BaseRouter(viewController: self)
        sections = try? Main.instance.getSectionsFromRealm()
        Main.instance.tempCheckList = []
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(_:)), name: Notification.Name("tempCheckListReloadData"), object: Main.instance.tempCheckList)
        newSectionTextField?.textAlignment = .center
        newSectionTextField?.text = sections?.count != 0 ? sections?[0] : ""
        view.addTapGestureToHideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ParalaxEffect.paralaxEffect(view: mainBGImageView, magnitude: 50)
        ParalaxEffect.paralaxEffect(view: minorBGImageView, magnitude: -50)
        mainBGLeadingConstraint.constant = -(view.frame.size.width * 1.4 + 300)
        minorBGLeadingConstraint.constant = -(view.frame.size.width * 1.4 + 300)
        changeTheme()
        print(view.frame.width, " 🍎🍎🍎🍎🍎")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.dismissKeyboard()
        ParalaxEffect.paralaxEffect(view: mainBGImageView, magnitude: 0)
        ParalaxEffect.paralaxEffect(view: minorBGImageView, magnitude: 0)
    }
    
    // MARK: - ACTIONS
    @objc func createNewTaskButton() {
        func tempAddTask(sectionName: String) {
            var tempMarkSelectedCount = 0
            for mark in Main.instance.tempCheckList {
                if mark.isMarkSelected {
                    tempMarkSelectedCount += 1
                }
            }
            guard var task = try? Main.instance.addTask(sectionName: sectionName, name: newTaskNameTextField.text!, backgroundColor: selectedBackgroundColor, taskDescription: descriptionTextField.text, notificationDate: notificationTextField.text, checkList: Main.instance.tempCheckList, markSelectedCount: tempMarkSelectedCount) else { return }

            if task.notificationDate != "" {
                task.notificationID = notificationService.sendNotificationRequest(task: task)
            }

            guard let sectionsCount = sections?.count else { return }
            if sectionsCount > 0 {
                try? Main.instance.deleteSection(delSectionName: "")
            }
            router?.pop(animated: true)
        }

        if notificationTextField.text != "" {
            let pickedDate: Double = dateFormatter.date(from: notificationTextField.text ?? "")?.timeIntervalSince1970 ?? 0
            let interval = pickedDate - Date().timeIntervalSince1970
            if interval <= 1 {
                return showAlert(title: "Ошибка", message: "Выбрано прошедшее время")
            }
        }
        if newTaskNameTextField.text == "" {
            showAlert(title: "Ошибка", message: "Не заполнено поле: Название")
        } else if substituteCategoryTextField.text != ""{
            tempAddTask(sectionName: substituteCategoryTextField.text ?? "")
        } else if newSectionTextField.text != "" {
            tempAddTask(sectionName: newSectionTextField.text ?? "")
        } else {
            showAlert(title: "Ошибка", message: "Не заполнено поле: Секция")
        }
    }
    
    @IBAction func pickColorButtonTapped(_ sender: UIButton) {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.delegate = self
        present(colorPickerViewController, animated: true)
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
            substituteCategoryTextField.text = ""
            substituteCategoryTextField.isHidden = false
            substituteCategoryTextField.becomeFirstResponder()
            isKeyboard = true
        } else {
            if sections?.count != 0 {
                try? Main.instance.deleteSection(delSectionName: "")
            }
            substituteCategoryTextField.resignFirstResponder()
            substituteCategoryTextField.isHidden = true
            newSectionTextField.isHidden = false
            newSectionTextField.becomeFirstResponder()
            isKeyboard = false
            categoryPicker.selectedRow(inComponent: 0)
            newSectionTextField.text = substituteCategoryTextField.text
            substituteCategoryTextField.text = ""
            try? Main.instance.addSection(sectionName: newSectionTextField.text ?? "")
            sections = try? Main.instance.getSectionsFromRealm()
            newSectionTextField.text = sections?.count != 0 ? sections?[0] : ""
        }
        categoryPicker.reloadAllComponents()
    }
    
    @objc func chooseNotificationAction() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
        }
        notificationTextField?.text = dateFormatter.string(from: notificationPicker.date)
        self.dismissKeyboard()
    }
    
    // MARK: - CHECK LIST ACTIONS
    @IBAction func checkListButtonAction(_ sender: Any) {
        print("Нажата кнопка создания чек-листа")
        checkTableTopConstraints.constant = view.frame.height / 1.5
        checkListTableView.reloadData()
        checkToolBarTextField.becomeFirstResponder()
        
    }
    
    @IBAction func checkTableHideAction(_ sender: Any) {
        print("Нажата кнопка скрыть")
        checkListTableView.reloadData()
        checkTableTopConstraints.constant = 0
    }
    
    @IBAction func checkTableDoneAction(_ sender: Any) {
        print("Нажата кнопка готово")
        checkTablePlusAction(sender)
        dismissKeyboard()
        checkListTableView.reloadData()
        checkTableTopConstraints.constant = 0
    }
    
    @IBAction func checkTablePlusAction(_ sender: Any) {
        
        if checkToolBarTextField.text != "" {
            print("Нажата кнопка плюс (добавление доп строки)")
            let id = (Main.instance.tempCheckList.max()?.id ?? 0) + 1
            print("plus id: ", id)
            let checkMark = CheckMark(id: id, title: checkToolBarTextField.text ?? "", isMarkSelected: false)
            Main.instance.tempCheckList.append(checkMark)
            checkToolBarTextField.text = ""
            checkToolBarTextField.becomeFirstResponder()
            checkListTableView.reloadData()
        }
    }
    
    @objc func methodOfReceivedNotification(_ notification: Notification) {
        
        print("methodWork")
        checkListTableView.reloadData()
        
    }
    
    @objc func toggleSelected(button: UIButton) {
        Main.instance.tempCheckList[button.tag].isMarkSelected.toggle()
        checkListTableView.reloadData()
    }
    
    // MARK: - PICKER
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
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
    
    //MARK: - CHANGE THEME
    func changeTheme() {
        let theme = Main.instance.themeService.getTheme()
        
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        navigationController?.navigationBar.tintColor = theme.interfaceColor
        newSectionTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Секция", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: theme.interfaceColor]))
        newSectionTextField.textColor = theme.interfaceColor
        substituteCategoryTextField.textColor = theme.interfaceColor
        newTaskNameTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Название", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: theme.interfaceColor]))
        newTaskNameTextField.textColor = theme.interfaceColor
        descriptionTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Описание", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: theme.interfaceColor]))
        descriptionTextField.textColor = theme.interfaceColor
        notificationTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Напоминание", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: theme.interfaceColor]))
        notificationTextField.textColor = theme.interfaceColor
        coverButton.setTitleColor(theme.interfaceColor, for: .normal)
        coverButton.setTitleColor(theme.interfaceColor, for: .highlighted)
        checkListButton.setTitleColor(theme.interfaceColor, for: .normal)
        checkListButton.setTitleColor(theme.interfaceColor, for: .highlighted)
        
        mainBGImageView.image = UIImage(imageLiteralResourceName: theme.mainBackgroundImageName)
        minorBGImageView.image = UIImage(imageLiteralResourceName: theme.minorBackgroundImageName)

        checkToolBarView.backgroundColor = theme.backgroundColor
        checkToolBarTextField.textColor = theme.interfaceColor
        checkToolBarTextField.attributedPlaceholder = .init(attributedString: NSAttributedString(string: "Введите текст", attributes: [NSAttributedString.Key.foregroundColor: theme.interfaceColor]))
        checklistHideButton.setTitleColor(theme.interfaceColor, for: .normal)
        checklistHideButton.setTitleColor(theme.interfaceColor, for: .highlighted)
        checkPlusButton.tintColor = theme.interfaceColor
        checklistDoneButton.setTitleColor(theme.interfaceColor, for: .normal)
        checklistDoneButton.setTitleColor(theme.interfaceColor, for: .highlighted)
    }
    
    // MARK: - SET VIEW SCREEN
    func setViewScreen() {
        backLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        blurView.layer.cornerRadius = 24
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.darkGray.cgColor
        
        mainBGWidthConstraint.constant = view.frame.width*3.2
        mainBGHeightConstraint.constant = view.frame.width*1.8
        minorBGWidthConstraint.constant = view.frame.width*3.2
        minorBGHeightConstraint.constant = view.frame.width*1.8

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
        
        checkTableTopConstraints.constant = 0
        checkBlurView.layer.cornerRadius = 24
        checkBlurView.layer.borderWidth = 3
        checkBlurView.layer.borderColor = UIColor.darkGray.cgColor
        
        checkPlusButton.backgroundColor = .mainBackground
        checkPlusButton.layer.cornerRadius = 15
        checkPlusButton.layer.borderWidth = 2
        checkPlusButton.layer.borderColor = UIColor.darkGray.cgColor
        checkToolBarView.backgroundColor = .vitDarkBrown
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Создать", style: .done, target: self, action: #selector(createNewTaskButton))
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

extension NewTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Main.instance.tempCheckList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListCell", for: indexPath) as? CheckListCell else { return UITableViewCell() }
        let checkMark = Main.instance.tempCheckList[indexPath.row]
        checkMark.isMarkSelected ? cell.checkMarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) : cell.checkMarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        
        let strikedText = NSMutableAttributedString(string: checkMark.title)
        strikedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 3, range: NSMakeRange(0, strikedText.length))
        let normalText = NSMutableAttributedString(string: checkMark.title)
        normalText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, normalText.length))
        cell.titleLabel.text = checkMark.title
        cell.titleLabel.attributedText = checkMark.isMarkSelected ? strikedText : normalText
        cell.checkMarkButton.addTarget(self, action: #selector(NewTaskViewController.toggleSelected(button:)), for: .touchUpInside)
        cell.checkMarkButton.tag = indexPath.row
        cell.configure()
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 46
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Main.instance.tempCheckList.remove(at: indexPath.row)
            checkListTableView.deleteRows(at: [indexPath], with: .fade)
        }
        checkListTableView.reloadData()
    }
}
