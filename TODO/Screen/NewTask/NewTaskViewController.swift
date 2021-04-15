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
    @IBOutlet weak var newTaskNameTextField: UITextField!
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var checkListButton: UIButton!
    @IBOutlet weak var coverButton: UIButton!
    @IBOutlet weak var stackWiew: UIStackView!
    @IBOutlet weak var stackWidthConstr: NSLayoutConstraint!
    @IBOutlet weak var stackRowsHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var backLayer: Rounding!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapWidthConstraint: NSLayoutConstraint!
    
    
    var sections: [String]?
    var router: BaseRouter?
    let categoryPicker = UIPickerView()
    let notificationPicker = UIDatePicker()
    let dateFormatter111 = DateFormatter()
    var calendar = Calendar.current
    let notificationService = NotificationService()
    var selectedBackgroundColor: UIColor? = UIColor.clear
    let minDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
    var intervalTime = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewScreen()
        paralaxEffect(view: mapImageView, magnitude: 50)
        categoryPicker.delegate = self
        categoryPicker.selectedRow(inComponent: 0)
        dateFormatter111.timeZone = .autoupdatingCurrent
        //        dateFormatter111.dateFormat = "dd, MMMM yyyy HH:mm"
        dateFormatter111.dateFormat = "dd.MM.yyyy, HH:mm"
        calendar.timeZone = .autoupdatingCurrent
        router = BaseRouter(viewController: self)
        sections = try? Main.instance.getSectionsFromRealm()
        newSectionTextField?.textAlignment = .center
        newSectionTextField?.text = sections?[0]
//        stackWidthConstr.constant = view.frame.width/1.6
//        stackRowsHeight.constant = view.frame.height/24
//        stackWiew.spacing = view.frame.height/40
        // Скрытие клавиатуры по нажатию на свободное место
        view.addTapGestureToHideKeyboard()
    }

    
    // MARK: - ACTIONS
    
    @IBAction func createNewTaskButton(_ sender: UIButton) {
        
//        let sectionName: String = newSectionTextField?.text ?? ""
//        let taskName: String = newTaskNameTextField.text ?? ""
//
//        if !sectionName.isEmpty && !taskName.isEmpty {
//            //            Main.instance.addTask(section: sectionName!, name: taskName!)
//            try? Main.instance.addTask(sectionName: sectionName, name: taskName, backgroundColor: nil, taskDescription: nil, notificationDate: nil)
//        /*let sectionName: String? = newSectionTextField.text
//        let taskName: String? = newTaskNameTextField.text
//        let description: String? = descriptionTextField.text
//
//        if (sectionName != "") && (taskName != "") && (description != ""){
//            Main.instance.addTask(section: sectionName!, name: taskName!, descriptionDetail: description!)
//          */
//            router?.dismiss(animated: true, completion: nil)
//        } else { showAlert(title: "Ошибка", message: "Заполните поля") }
//
        
        // TODO: сделать правильную проверку
        if newSectionTextField.text != "" && newTaskNameTextField.text != "" {
            try? Main.instance.addTask(sectionName: newSectionTextField.text!, name: newTaskNameTextField.text!, backgroundColor: selectedBackgroundColor, taskDescription: descriptionTextField.text, notificationDate: notificationTextField.text)
            router?.dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Ошибка", message: "Заполните поля")
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
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text, newText: string, limit: 50)
    }
            
    private func textLimit(existingText: String?, newText: String, limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
    @objc func deleteCategoryAction() {
        try? Main.instance.deleteSection(delSectionName: newSectionTextField?.text ?? "")
        print("Нажата кнопка удалить категорию")
        view.endEditing(true)
    }
    
    @objc func chooseCategoryAction() {
        print("Нажата кнопка 'Готово' выбора категории")
        view.endEditing(true)
    }
    
    @objc func chooseNotificationAction() {
        notificationTextField?.text = dateFormatter111.string(from: notificationPicker.date)
        Main.instance.notificationDate = dateFormatter111.date(from: notificationTextField?.text ?? "")?.localString()
        print(Main.instance.notificationDate ?? "синглтон с датой тип строка", "🍏" )
//        guard !intervalTime else {return showAlert(title: "Ошибка", message: "Выберите время больше текущего")}
        notificationService.sendNotificationRequest(
            content: notificationService.makeNotificationContent(str: newTaskNameTextField.text ?? ""),
            trigger: notificationService.makeIntervalNotificationTrigger(doub: dateFormatter111.date(from: Main.instance.notificationDate ?? "")?.timeIntervalSince1970 ?? Date().timeIntervalSince1970+1000 )
        )
        view.endEditing(true)
    }
    
    // MARK: - PICKER
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newSectionTextField?.text = sections?[row]
        print(categoryPicker.selectedRow(inComponent: 0))
    }
    
    func setViewScreen() {
        view.applyGradient(colours: [.darkBrown, .backgroundColor], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        backLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        blurView.layer.cornerRadius = 24
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.darkGray.cgColor
        
        navigationController?.navigationBar.barTintColor = .darkBrown
        createButton.setTitle("Создать", for: .normal)
        mapWidthConstraint.constant = view.frame.width*3.2
        mapHeightConstraint.constant = view.frame.width*1.6
    }
    
    func paralaxEffect(view: UIView, magnitude: Double) {
        let xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xAxis.minimumRelativeValue = -magnitude
        xAxis.maximumRelativeValue = magnitude
        
        let yAxis = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yAxis.minimumRelativeValue = -magnitude
        yAxis.maximumRelativeValue = magnitude
        
        let effectGroup = UIMotionEffectGroup()
        effectGroup.motionEffects = [xAxis, yAxis]
        
        view.addMotionEffect(effectGroup)
    }
}
