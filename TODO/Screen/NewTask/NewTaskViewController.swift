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

class NewTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var newSectionTextField: UITextField! {
        didSet{
            newSectionTextField.inputView = categoryPicker
            newSectionTextField.inputAccessoryView = makeToolBarCategories()
        }
    }
    @IBOutlet weak var notificationTF: UITextField! {didSet {
        notificationTF.inputAccessoryView = makeToolBarNotifications()
        notificationTF.inputView = notificationPicker
        if #available(iOS 13.4, *) {notificationPicker.preferredDatePickerStyle = .wheels}
    }}
    @IBOutlet weak var newTaskNameTextField: UITextField!
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var checkListButton: UIButton!
    @IBOutlet weak var coverButton: UIButton!
    
    var sections: [String]?
    var router: BaseRouter?
    let categoryPicker = UIPickerView()
    let notificationPicker = UIDatePicker()
    let dateFormatter111 = DateFormatter()
    var calendar = Calendar.current
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
        categoryPicker.selectedRow(inComponent: 0)
        dateFormatter111.timeZone = .autoupdatingCurrent
//        dateFormatter111.dateFormat = "dd, MMMM yyyy HH:mm"
        dateFormatter111.dateFormat = "dd.MM.yyyy, HH:mm"
        calendar.timeZone = .autoupdatingCurrent
        router = BaseRouter(viewController: self)
        membersButton.layer.cornerRadius = 5
        checkListButton.layer.cornerRadius = 5
        coverButton.layer.cornerRadius = 5
        sections = Main.instance.getCategoriesFromRealm()
        newSectionTextField.textAlignment = .center
        print(sections ?? "секции отсутствуют")
        newSectionTextField.text = sections?[0]
    }

    // MARK: - ACTIONS
    
    @IBAction func createNewTaskButton(_ sender: UIButton) {
        
        let sectionName: String? = newSectionTextField.text
        let taskName: String? = newTaskNameTextField.text
        
        if (sectionName != "") && (taskName != "") {
            Main.instance.addTask(section: sectionName!, name: taskName!)
            router?.dismiss(animated: true, completion: nil)

        } else {
            let alert = UIAlertController(title: "Empty fields", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        sendNotificationRequest(
            content: self.makeNotificationContent(),
            trigger: self.makeIntervalNotificationTrigger()
        )
    }
    
    @objc func deleteCategoryAction() {
        Main.instance.deleteSection(delSectionName: newSectionTextField.text ?? "")
        print("Нажата кнопка удалить категорию")
        view.endEditing(true)
    }
    
    @objc func chooseCategoryAction() {
        print("Нажата кнопка 'Готово' выбора категории")
        view.endEditing(true)
    }
    
    @objc func chooseNotificationAction() {
        notificationTF.text = dateFormatter111.string(from: notificationPicker.date)
        Main.instance.notificationDate = dateFormatter111.date(from: notificationTF.text!)?.localString()
        print("Нажата кнопка 'Готово' выбора даты уведомления")
        print(Main.instance.notificationDate ?? "синглтон с датой тип строка", "🍏" )
        print(dateFormatter111.date(from: Main.instance.notificationDate!)!.timeIntervalSince1970, "🍏🍏🍏")
        view.endEditing(true)
    }
    
    func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = newTaskNameTextField.text ?? ""
        content.badge = 1
        return content
    }
    
    func makeIntervalNotificationTrigger() -> UNNotificationTrigger {
        let ttt = dateFormatter111.date(from: Main.instance.notificationDate!)!.timeIntervalSince1970 // выбранное время
        let ggg = Date().timeIntervalSince1970 // текущее время
        let rrr = ttt - ggg // интервал в секундах между выбранным и текущим
        return UNTimeIntervalNotificationTrigger(
            timeInterval: rrr,
            repeats: false
        )
    }
    
    func sendNotificationRequest(
        content: UNNotificationContent,
        trigger: UNNotificationTrigger) {
        
        let request = UNNotificationRequest(
            identifier: "notification",
            content: content,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - TABLE
    
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
        newSectionTextField.text = sections?[row]
        print(categoryPicker.selectedRow(inComponent: 0))
//        Main.instance.deleteSection(delSectionName: row)
    }

}
