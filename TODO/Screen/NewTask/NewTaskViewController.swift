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
    
    
    
    @IBOutlet weak var newSectionTextField: UITextField!
    @IBOutlet weak var newTaskNameTextField: UITextField!
    
    let pickerView = UIPickerView()
    
    var sections: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = Main.instance.getCategoriesFromRealm()
       
        pickerView.dataSource = self
        pickerView.delegate = self
        
        newSectionTextField.inputView = pickerView
        newSectionTextField.textAlignment = .center
        newSectionTextField.placeholder = "Select categories"
        print(sections!)
        newSectionTextField.text = sections?[0]
    }

    
    @IBAction func createNewTaskButton(_ sender: UIButton) {
        
        let sectionName: String? = newSectionTextField.text
        let taskName: String? = newTaskNameTextField.text
        
        if (sectionName != "") && (taskName != "") {
            Main.instance.addTask(section: sectionName!, name: taskName!)
            self.dismiss(animated: true, completion: nil)
        } else if (sectionName != "") && (taskName == "") {
            Main.instance.addSection(section: sectionName!)
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Empty fields", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
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
        newSectionTextField.resignFirstResponder()
    }

}
