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
             
        try? Main.instance.updateTasksFromRealm()
        try! Main.instance.addSection(sectionName: "") // чтобы pickerView изначально загружался с пустой категорией и текстом placeholder'а
        try! Main.instance.addSection(sectionName: "Базовая секция № 1")
        
        self.realmTokenTasks = realm.objects(TaskRealm.self).observe({ (result) in
            switch result {
            case .update(_, deletions: _, insertions: _, modifications: _):
                try? Main.instance.updateTasksFromRealm()
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
    
    //MARK: - TABLE
 

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
            view.backgroundColor = UIColor.hexStringToUIColor(hex: "#fcdab7")
            return view
        }()
        cell.tasksNameLabel.text = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].name
        cell.tasksIconImageView.image = UIImage(systemName: "pencil.circle.fill")
         

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/14
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try? Main.instance.deleteTask(indexPathSectionTask: indexPath.section, indexPathRowTask: indexPath.row)
            
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
    
    //MARK: - ACTIONS
    
    @IBAction func newTaskBarButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "NewTaskStoryboard", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "NewTaskViewController") as! NewTaskViewController
        router?.present(vc: destinationVC)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationViewController = TaskDetailViewController()
        let object = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
        destinationViewController.task = object
        router?.present(vc: destinationViewController)
    }
}
