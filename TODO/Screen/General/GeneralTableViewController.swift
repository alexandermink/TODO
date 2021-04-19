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

protocol GeneralTableViewControllerDelegat: AnyObject {
    func didTapMenuButton()
}

class GeneralTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIColorPickerViewControllerDelegate {
    
    enum MenuState {
        case opened
        case closed
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backLayer: Rounding!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var newTaskButton: UIBarButtonItem!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var boatImageView: UIImageView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var mapWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var boatWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var boatHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cloudsImageView: UIImageView!
    @IBOutlet weak var cloudsWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cloudsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingsStackLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingsStack: UIStackView!
    @IBOutlet weak var trashView: UIImageView!
    @IBOutlet weak var navSeparatorView: UIView!
    
    
    let realm = try! Realm()
    var realmTokenSections: NotificationToken?
    var router: BaseRouter?
    let main = Main.instance
    weak var delegat: GeneralTableViewControllerDelegat?
    private var menuState: MenuState = .closed
    
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addPanGesture(view: tableView)
//        fileViewOrigin = tableView.bounds
//        view.bringSubviewToFront(tableView)
//
//        addPanGesture(view: backLayer)
//        fileViewOrigin = backLayer.bounds
//        view.bringSubviewToFront(backLayer)
//
//        addPanGesture(view: blurView)
//        fileViewOrigin = blurView.bounds
//        view.bringSubviewToFront(blurView)
        
        setViewScreen()
        cloudsImageView.isHidden = true
        ParalaxEffect.paralaxEffect(view: mapImageView, magnitude: 50)
        ParalaxEffect.paralaxEffect(view: boatImageView, magnitude: 50)
        try? main.updateTasksFromRealm()
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
        UIView.animate(withDuration: 180, delay: 0, options: [.curveLinear, .autoreverse, .repeat], animations: {
            self.cloudsImageView.frame = .init(x: 0, y: 0, width: self.view.frame.width*2, height: self.view.frame.width)
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
//        cell.tasksIconImageView.image = UIImage(systemName: "pencil.circle.fill")
        cell.taskNameLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].name
        cell.descriptionLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].taskDescription
        cell.notificationLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].notificationDate
        cell.backgroundColor = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor
        // Настроить передачу цвета, разные типы UIColor
//            main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor
//        self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor
        cell.notificationLabel.textColor = .systemYellow
        cell.descriptionLabel.textColor = .vitBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor = .clear
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
        view.backgroundColor = UIColor.alexeyBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 3, height: 13)
        let lbl = UILabel(frame: CGRect(x: 15, y: 5, width: view.frame.width - 10, height: 20))
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textColor = .vitBackground
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
        main.rowBGCcolor = viewController.selectedColor
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
            self.main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor = main.rowBGCcolor
        }
        return action
    }
    
    func okAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "ОК") { [self] (action, view, completion) in
            self.tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = main.rowBGCcolor
        }
        main.rowBGCcolor = .clear
        return action
    }
    
    //MARK: - ACTIONS
    @objc func didTapMenuButton() {
        delegat?.didTapMenuButton()
        print("did tap menu")
        switch menuState {
        case .closed:
            self.cloudsImageView.isHidden = false
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.view.frame.origin.x = self.view.frame.size.width - 80
                self.blurView.backgroundColor = .black
                self.backLayer.backgroundColor = .vitBackground
                self.blurView.alpha = 0.5
                self.navigationItem.leftBarButtonItem?.title = "Скрыть"
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            self.cloudsImageView.isHidden = true
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.view.frame.origin.x = 0
                self.blurView.backgroundColor = .clear
                self.backLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
                self.blurView.alpha = 0.8
                self.navigationItem.leftBarButtonItem?.title = "Настройки"
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                }
            }
        }
    }
    
    @IBAction func newTaskBarButton(_ sender: Any) {
        print("нажата")
        try! Main.instance.addSection(sectionName: "Базовая секция № 1")
        let storyboard = UIStoryboard(name: "NewTaskStoryboard", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "NewTaskViewController") as! NewTaskViewController
        router?.present(vc: destinationVC, animated: true)
    }
    
    //MARK: - SET VIEW SCREEN
    func setViewScreen() {
//        view.applyGradient(colours: [.vitDarkBrown, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        view.applyGradient(colours: [.alexeyFog, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        backLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        blurView.layer.cornerRadius = 24
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.darkGray.cgColor
        
//        navigationController?.navigationBar.barTintColor = .vitDarkBrown
        navigationController?.navigationBar.barTintColor = .alexeyFog
        newTaskButton.title = "Новая задача"
        newTaskButton.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: UIColor.alexeyBackground], for: .normal)
        newTaskButton.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: UIColor.alexeyBackground], for: .highlighted)
        mapWidthConstraint.constant = view.frame.width*3.2
        mapHeightConstraint.constant = view.frame.width*1.8
        
        boatWidthConstraint.constant = view.frame.width*1.8
        boatHeightConstraint.constant = view.frame.width*1.8
        
        settingsStackLeadingConstraint.constant = -view.frame.width/2
        self.cloudsImageView.frame = .init(x: -view.frame.width*4, y: 0, width: view.frame.width*2, height: view.frame.width)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Настройки", style: .done, target: self, action: #selector(didTapMenuButton))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: UIColor.alexeyBackground], for: .normal)
        cloudsWidthConstraint.constant = view.frame.width*5.2
        cloudsHeightConstraint.constant = view.frame.width*2
        navSeparatorView.backgroundColor = .alexeyBackground
//        navSeparatorView.backgroundColor = .systemYellow
    }
    
    
    
    
    
    
//    var fileViewOrigin: CGRect!
//
//    func addPanGesture(view: UIView) {
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(GeneralTableViewController.handlePan(sender:)))
//        view.addGestureRecognizer(pan)
//    }
//
//    @objc func handlePan(sender: UIPanGestureRecognizer) {
//        let fileView = sender.view!
//        switch sender.state {
//        case .began, .changed:
//            moveViewWithPan(view: fileView, sender: sender)
//        case .ended:
//            if fileView.frame.intersects(trashView.frame) {
//                deleteView(view: fileView)
//            } else { returnViewToOrigin(view: fileView) }
//        default: break
//        }
//    }
//
//    func moveViewWithPan(view: UIView, sender: UIPanGestureRecognizer) {
//        let translation = sender.translation(in: view)
//        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
//        sender.setTranslation(CGPoint.zero, in: view)
//    }
//
//    func returnViewToOrigin(view: UIView) {
//        UIView.animate(withDuration: 0.3, animations: {
//            view.bounds = self.fileViewOrigin
//        })
//    }
//
//    func deleteView(view: UIView) {
//        UIView.animate(withDuration: 0.3, animations: {
//            view.alpha = 0.0
//        })
//    }
}
