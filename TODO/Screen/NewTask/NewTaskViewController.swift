//
//  NewTaskViewController.swift
//  TODO
//
//  Created by Александр Минк on 07.01.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift

class NewTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var newSectionTextField: UITextField! {
        didSet{
            newSectionTextField.inputView = daysPicker
            newSectionTextField.inputAccessoryView = createToolBarCategories()
        }
    }
    @IBOutlet weak var newTaskNameTextField: UITextField!
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var checkListButton: UIButton!
    @IBOutlet weak var coverButton: UIButton!
    
    var sections: [String]?
    var router: BaseRouter?
    let daysPicker = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysPicker.delegate = self
        daysPicker.selectedRow(inComponent: 0)
//        print(daysPicker.selectedRow(inComponent: 0))
        
        router = BaseRouter(viewController: self)
        
        membersButton.layer.cornerRadius = 5
        checkListButton.layer.cornerRadius = 5
        coverButton.layer.cornerRadius = 5
        
        sections = Main.instance.getCategoriesFromRealm()
        newSectionTextField.textAlignment = .center
        print(sections!)
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
    }
    
    @objc func toolBarDeleteAction() {
        Main.instance.deleteSection(delSectionName: newSectionTextField.text ?? "")
        
        print("Нажата кнопка удалить категорию")
        view.endEditing(true)
    }
    
    @objc func toolBarDoneAction() {
        print("Нажата кнопка готово")
        view.endEditing(true)
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
        print(daysPicker.selectedRow(inComponent: 0))
//        Main.instance.deleteSection(delSectionName: row)
//        newSectionTextField.resignFirstResponder() // убрал это, чтобы автоматически не закрывался пикер, при выборе поля
    }

}
