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

class GeneralTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backLayer: Roundinng!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var newTaskButton: UIBarButtonItem!
    @IBOutlet weak var angleRingView: UIView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!

    
    let realm = try! Realm()
    var realmTokenTasks: NotificationToken? = nil
    var router: BaseRouter?
    let main = Main.instance
    var task = Task()


    override func viewDidLoad() {
        super.viewDidLoad()
        setViewScreen()
        
        router = BaseRouter(viewController: self)
             
        try? main.updateTasksFromRealm()
//        try! main.addSection(sectionName: "") // чтобы pickerView изначально загружался с пустой категорией и текстом placeholder'а
        try! main.addSection(sectionName: "Базовая секция № 1")
        
        self.realmTokenTasks = realm.objects(TaskRealm.self).observe({ (result) in
            switch result {
            case .update(_, deletions: _, insertions: _, modifications: _):
                try? self.main.updateTasksFromRealm()
                self.tableView.reloadData()
            case .initial(_): break
            case .error(_): break
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapImageView.frame = .init(x: -view.frame.width*2.4, y: 0, width: view.frame.width*2, height: view.frame.width)
        UIView.animate(withDuration: 240, delay: 0, options: [.curveLinear, .autoreverse, .repeat], animations: {
            self.mapImageView.frame = .init(x: 0, y: 0, width: self.view.frame.width*2, height: self.view.frame.width)
        }, completion: nil)
        
        self.tableView.reloadData()
    }
    
    //MARK: - TABLE
 

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return main.userSession.tasks[section].sectionTasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return main.userSession.tasks.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GeneralTableViewCell
        cell.selectedBackgroundView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
            view.backgroundColor = UIColor.hexStringToUIColor(hex: "#fcdab7")
            return view
        }()
//        cell.tasksNameLabel.text = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].name
//        cell.tasksIconImageView.image = UIImage(systemName: "pencil.circle.fill")
        cell.taskNameLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].name
        cell.descriptionLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].taskDescription
        cell.notificationLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].notificationDate
        
        cell.notificationLabel.textColor = .systemYellow
        cell.descriptionLabel.textColor = .backgroundColor
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return view.frame.height/14
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try? main.deleteTask(indexPathSectionTask: indexPath.section, indexPathRowTask: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            if main.userSession.tasks[indexPath.section].sectionTasks.isEmpty {
                main.userSession.tasks.remove(at: indexPath.section)
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if main.userSession.tasks[section].sectionTasks.count != 0 {
            return main.userSession.tasks[section].sectionName
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { // хедеры
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        view.backgroundColor = UIColor.systemYellow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 3, height: 13)
        let lbl = UILabel(frame: CGRect(x: 15, y: 5, width: view.frame.width - 10, height: 20))
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textColor = .backgroundColor
        lbl.text = main.userSession.tasks[section].sectionName
        view.addSubview(lbl)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationViewController = TaskDetailViewController()
        let object = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
        destinationViewController.task = object
        router?.present(vc: destinationViewController)
    }
    
    //MARK: - ACTIONS
    
    @IBAction func newTaskBarButton(_ sender: Any) {
        print("нажата")
        let storyboard = UIStoryboard(name: "NewTaskStoryboard", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "NewTaskViewController") as! NewTaskViewController
        router?.present(vc: destinationVC)
    }
    
    //MARK: - SET VIEW SCREEN
    
    func setViewScreen() {
        view.applyGradient(colours: [.darkBrown, .backgroundColor], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        backLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        blurView.layer.cornerRadius = 24
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.darkGray.cgColor
        
        navigationController?.navigationBar.barTintColor = .darkBrown
        newTaskButton.title = "Новая задача"
        newTaskButton.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: UIColor.systemYellow], for: .normal)
        newTaskButton.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: UIColor.systemYellow], for: .highlighted)
        mapWidthConstraint.constant = view.frame.width*3.2
        mapHeightConstraint.constant = view.frame.width*1.6
    }
}
