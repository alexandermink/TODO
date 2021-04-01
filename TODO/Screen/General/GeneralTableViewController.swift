//
//  GeneralTableViewController.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "GeneralCell"

class GeneralTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var realmTokenTasks: NotificationToken? = nil
    var router: BaseRouter?

    override func viewDidLoad() {
        super.viewDidLoad()
        router = BaseRouter(viewController: self)
                
        Main.instance.getTasksFromRealm()
        Main.instance.addSection(section: "") // чтобы pickerView изначально загружался с пустой категорией и текстом placeholder'а
        Main.instance.addSection(section: "Базовая секция № 1")
        
        self.realmTokenTasks = realm.objects(TaskRealm.self).observe({ (result) in
            switch result {
            case .update(_, deletions: _, insertions: _, modifications: _):
                self.tableView.reloadData()
            case .initial(_): break
            case .error(_): break
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Main.instance.userSession.tasks[section].sectionTasks.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Main.instance.userSession.tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GeneralTableViewCell
        
        
        
        cell.selectedBackgroundView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
            view.backgroundColor = hexStringToUIColor(hex: "#fcdab7")
            return view
        }()
        cell.tasksNameLabel.text = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].name
        cell.tasksIconImageView.image = UIImage(systemName: "pencil.circle.fill")
         

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Main.instance.deleteTask(indexPathSectionTask: indexPath.section, indexPathRowTask: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            if Main.instance.userSession.tasks[indexPath.section].sectionTasks.isEmpty {
                Main.instance.userSession.tasks.remove(at: indexPath.section)
            }
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if Main.instance.userSession.tasks[section].sectionTasks.count != 0 {
            return Main.instance.userSession.tasks[section].sectionName
        } else {
            return ""
        }
    }
    
    
    
    
    @IBAction func newTaskBarButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "NewTaskViewController") as! NewTaskViewController
        router?.present(vc: destinationVC)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationVC = TaskDetailViewController()
        let object = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
        destinationVC.taskName = object.name
        destinationVC.taskDate = object.date
        router?.present(vc: destinationVC)
        
    }
    
    
    
    //Функция для преобразования hex кода в UIColor
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
