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

class GeneralTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backLayer: Rounding!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var newTaskButton: UIBarButtonItem!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var mapWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!

    
    let realm = try! Realm()
    var realmTokenSections: NotificationToken?
    var router: BaseRouter?
    let main = Main.instance
    var task = Task()
    var defaults = UserDefaults.standard
//    let mapShape = AnimationMap()
//    let layerAnimation = LayerAnimation()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewScreen()
        paralaxEffect(view: mapImageView, magnitude: 50)
        try? main.updateTasksFromRealm()
//        try! main.addSection(sectionName: "") // чтобы pickerView изначально загружался с пустой категорией и текстом placeholder'а
        try! main.addSection(sectionName: "Базовая секция № 1")
        
        self.realmTokenSections = realm.objects(SectionTaskRealm.self).observe({ (result) in
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
//        self.mapImageView.frame = .init(x: -view.frame.width*2.4, y: 0, width: view.frame.width*2, height: view.frame.width)
//        UIView.animate(withDuration: 240, delay: 0, options: [.curveLinear, .autoreverse, .repeat], animations: {
//            self.mapImageView.frame = .init(x: 0, y: 0, width: self.view.frame.width*2, height: self.view.frame.width)
//        }, completion: nil)
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
//        cell.tasksIconImageView.image = UIImage(systemName: "pencil.circle.fill")
        cell.taskNameLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].name
        cell.descriptionLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].taskDescription
        cell.notificationLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].notificationDate
        cell.backgroundColor = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor
        // Настроить передачу цвета, разные типы UIColor
//            main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor
//        self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor
        cell.notificationLabel.textColor = .systemYellow
        cell.descriptionLabel.textColor = .backgroundColor
        return cell
    }
    
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
        } else { return "" }
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
    
    //MARK: - ВЫБОР ЦВЕТА СВАЙП ЯЧЕЙКИ
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
//        main.colo = viewController.selectedColor
        defaults.setColor(color: viewController.selectedColor, forKey: "myColr")
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pickColorButton = pickColorAction(at: indexPath)
        let okButton = okAction(at: indexPath)
        pickColorButton.backgroundColor = .systemYellow
        okButton.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [pickColorButton, okButton])
        configuration.performsFirstActionWithFullSwipe = false
            return configuration
    }
    
    func pickColorAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Выбрать цвет") { [self] (action, view, completion) in
            let colorPickerVC = UIColorPickerViewController()
            colorPickerVC.delegate = self
            self.present(colorPickerVC, animated: true)
            self.main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor = defaults.colorForKey(key: "myColr")
        }
        return action
    }
    
    func okAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "ОК") { [self] (action, view, completion) in
            self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = defaults.colorForKey(key: "myColr")
        }
        print(self.main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor as Any)
        return action
    }
    
    //MARK: - ACTIONS
    
    @IBAction func newTaskBarButton(_ sender: Any) {
        print("нажата")
        try! Main.instance.addSection(sectionName: "Базовая секция № 1")
        let storyboard = UIStoryboard(name: "NewTaskStoryboard", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "NewTaskViewController") as! NewTaskViewController
        router?.present(vc: destinationVC, animated: true)
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
