//
//  GeneralTableViewController.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift

class GeneralTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backLayer: Rounding!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var newTaskButton: UIBarButtonItem!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var boatImageView: UIImageView!
    @IBOutlet weak var mapWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var boatWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var boatHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navSeparatorView: UIView!
    @IBOutlet weak var alexLayer1: UIImageView!
    @IBOutlet weak var alexLayer2: UIImageView!
    @IBOutlet weak var alexLayer1widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var alexLayer1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var alexLayer2widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var alexLayer2HeightConstraint: NSLayoutConstraint!
    
    
    private var currentTheme : String? {didSet {tableView.reloadData()}}
    let realm = try! Realm()
    var realmTokenSections: NotificationToken?
    var router: BaseRouter?
    let main = Main.instance
    let dataSource = GeneralCellDataSource()
    
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewScreen()
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "someHeaderViewIdentifier")
        ParalaxEffect.paralaxEffect(view: mapImageView, magnitude: 50)
        ParalaxEffect.paralaxEffect(view: boatImageView, magnitude: 50)
        ParalaxEffect.paralaxEffect(view: alexLayer1, magnitude: 50)
        ParalaxEffect.paralaxEffect(view: alexLayer2, magnitude: -50)
        try? main.updateTasksFromRealm()
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
        changeState(state: main.state ?? "1")
        tableView.bounds.size.height = view.bounds.size.height
        self.tableView.reloadData()
        TableRowsAnimation.animateTable(table: tableView)
    }
    
    //MARK: - TABLE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        main.userSession.tasks[section].sectionTasks.count + 1
    }
    func numberOfSections(in tableView: UITableView) -> Int { main.userSession.tasks.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.dataSource.getCell(at: tableView, indexPath: indexPath, currentTheme: currentTheme ?? "1")
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        self.dataSource.isEditRow(tableView, canEditRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.dataSource.editingStyle(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        main.userSession.tasks[section].sectionName
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.dataSource.viewHeaderSection(tableView, viewForHeaderInSection: section, currentTheme: currentTheme ?? "1")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSource.selectRow(tableView, didSelectRowAt: indexPath, router: router!)
    }
    
    //MARK: - ВЫБОР ЦВЕТА СВАЙП ЯЧЕЙКИ
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        main.rowBGCcolor = viewController.selectedColor
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pickColorButton = pickColorAction(at: indexPath)
        let okButton = okAction(at: indexPath)
        pickColorButton.backgroundColor = .darkGray
        okButton.backgroundColor = .darkGray
        let configuration = UISwipeActionsConfiguration(actions: [pickColorButton, okButton])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    //
    func pickColorAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Выбрать цвет") { (action, view, completion) in
            let colorPickerVC = UIColorPickerViewController()
            colorPickerVC.delegate = self
            self.present(colorPickerVC, animated: true)
            self.main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor = self.main.rowBGCcolor
        }
        return action
    }

    func okAction(at indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: "ОК") { [self] (action, view, completion) in
            var task = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
            task.backgroundColor = main.rowBGCcolor
            main.rowBGCcolor = .clear
            try? Main.instance.updateTask(task: task)
            tableView.reloadData()
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func newTaskBarButton(_ sender: Any) {
        print("нажата")
        let storyboard = UIStoryboard(name: "NewTaskStoryboard", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "NewTaskViewController") as! NewTaskViewController
        main.transitionSide = "right"
        router?.push(vc: destinationVC, animated: true)
    }
    
    //MARK: - CHANGE STATE SETTINGS
    func changeState(state: String) {
        self.currentTheme = state
        switch state {
        case "1":
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
            mapImageView.isHidden = false
            boatImageView.isHidden = true
            alexLayer1.isHidden = true
            alexLayer2.isHidden = true
            navigationController?.navigationBar.barTintColor = .vitDarkBrown
            newTaskButton.setTitleTextAttributes(
                [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor: UIColor.systemYellow], for: .normal)
            newTaskButton.setTitleTextAttributes(
                [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor: UIColor.systemYellow], for: .highlighted)
            navigationItem.leftBarButtonItem?.setTitleTextAttributes(
                [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor: UIColor.systemYellow], for: .normal)
            navSeparatorView.backgroundColor = .systemYellow
            navigationItem.leftBarButtonItem?.tintColor = .systemYellow
        case "2":
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
            mapImageView.isHidden = true
            boatImageView.isHidden = false
            alexLayer1.isHidden = true
            alexLayer2.isHidden = true
            navigationController?.navigationBar.barTintColor = .alexeyFog
            newTaskButton.setTitleTextAttributes(
                [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor: UIColor.alexeyBackground], for: .normal)
            newTaskButton.setTitleTextAttributes(
                [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor: UIColor.alexeyBackground], for: .highlighted)
            navigationItem.leftBarButtonItem?.setTitleTextAttributes(
                [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor: UIColor.alexeyBackground], for: .normal)
            navSeparatorView.backgroundColor = .alexeyBackground
            navigationItem.leftBarButtonItem?.tintColor = .alexeyBackground
        case "3":
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
            boatImageView.isHidden = true
            mapImageView.isHidden = true
            alexLayer1.isHidden = false
            alexLayer2.isHidden = false
            navigationController?.navigationBar.barTintColor = .alexDark
            newTaskButton.setTitleTextAttributes(
                [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
            newTaskButton.setTitleTextAttributes(
                [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor: UIColor.red], for: .highlighted)
            navigationItem.leftBarButtonItem?.setTitleTextAttributes(
                [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
                 NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
            navSeparatorView.backgroundColor = .red
            navigationItem.leftBarButtonItem?.tintColor = .red
        default:
            break
        }
    }
    
    //MARK: - SET VIEW SCREEN
    func setViewScreen() {
        backLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        blurView.layer.cornerRadius = 24
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.darkGray.cgColor
        newTaskButton.title = "Новая задача"
        mapWidthConstraint.constant = view.frame.width*3.2
        mapHeightConstraint.constant = view.frame.width*1.8
        boatWidthConstraint.constant = view.frame.width*1.8
        boatHeightConstraint.constant = view.frame.width*1.8
        alexLayer1widthConstraint.constant = view.frame.width*3.6
        alexLayer1HeightConstraint.constant = view.frame.width*2.4
        alexLayer2widthConstraint.constant = view.frame.width*3.2
        alexLayer2HeightConstraint.constant = view.frame.width*1.8
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(checkMenu))
        view.backgroundColor = nil
    }
    
    @objc func checkMenu() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "Menu") as! MenuViewController
        main.transitionSide = "left"
        router?.push(vc: destinationVC, animated: true)
    }
}
