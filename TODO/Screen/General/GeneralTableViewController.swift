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
    @IBOutlet weak var mainBGImageView: UIImageView!
    @IBOutlet weak var mapWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navSeparatorView: UIView!
    @IBOutlet weak var minorBGImageView: UIImageView!
    @IBOutlet weak var alexLayer2widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var alexLayer2HeightConstraint: NSLayoutConstraint!
    
    
    private var currentTheme : String? {didSet {tableView.reloadData()}}
    let realm = try! Realm()
    var realmTokenSections: NotificationToken?
    var router: BaseRouter?
    let dataSource = GeneralCellDataSource()
    
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        router = BaseRouter(viewController: self)
        setViewScreen()
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "someHeaderViewIdentifier")
        ParalaxEffect.paralaxEffect(view: mainBGImageView, magnitude: 50)
        ParalaxEffect.paralaxEffect(view: minorBGImageView, magnitude: -50)
        try? Main.instance.getTasksFromRealm()
        self.realmTokenSections = realm.objects(SectionTaskRealm.self).observe({ (result) in
            switch result {
            case .update(_, deletions: _, insertions: _, modifications: _):
                try? Main.instance.getTasksFromRealm()
                self.tableView.reloadData()
            case .initial(_): break
            case .error(_): break
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.bounds.size.height = view.bounds.size.height
        changeTheme()
        self.tableView.reloadData()
        TableRowsAnimation.animateTable(table: tableView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.dismissKeyboard()
    }
    
    //MARK: - TABLE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Main.instance.userSession.tasks[section].sectionTasks.count + 1
    }
    func numberOfSections(in tableView: UITableView) -> Int { Main.instance.userSession.tasks.count }
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
        Main.instance.userSession.tasks[section].sectionName
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.dataSource.viewHeaderSection(tableView, viewForHeaderInSection: section, currentTheme: currentTheme ?? "1")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.view.window?.rootViewController
//        self.dataSource.selectRow(tableView, didSelectRowAt: indexPath, router: router!)
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == Main.instance.userSession.tasks[indexPath.section].sectionTasks.count {
            print("ячейка с кнопкой 'Добавить' нажата")
        } else {
            
            // Get the presented navigationController and the editViewController it contains.
            
            let navigationController = self.view.window?.rootViewController?.navigationController
            let destinationViewController = TaskDetailViewController()
            navigationController?.viewControllers.append(destinationViewController)
            
            
            // Set the editViewController to be the delegate of the presentationController for this presentation.
            // editViewController can then respond to attempted dismissals.
            
            navigationController?.presentationController?.delegate = destinationViewController
            
            
//            let destinationViewController = TaskDetailViewController()
            let object = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
            
            
            
            destinationViewController.task = object
            router?.present(vc: destinationViewController)
            navigationController?.presentationController?.delegate = destinationViewController
            print("ячейка нажата")
        }
    }
    
    //MARK: - ВЫБОР ЦВЕТА СВАЙП ЯЧЕЙКИ
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        Main.instance.rowBGColor = viewController.selectedColor
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
            Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor = Main.instance.rowBGColor
        }
        return action
    }

    func okAction(at indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .normal, title: "ОК") { [self] (action, view, completion) in
            var task = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
            task.backgroundColor = Main.instance.rowBGColor
            Main.instance.rowBGColor = .clear
            try? Main.instance.updateTask(task: task)
            tableView.reloadData()
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func newTaskBarButton(_ sender: Any) {
        print("нажата")
        let storyboard = UIStoryboard(name: "NewTaskStoryboard", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "NewTaskViewController") as! NewTaskViewController
        Main.instance.transitionSide = "right"
        router?.push(vc: destinationVC, animated: true)
    }
    
    //MARK: - CHANGE STATE SETTINGS
    
    func changeTheme() {
        let theme = Main.instance.themeService.getTheme()
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        navigationController?.navigationBar.tintColor = theme.interfaceColor
        newTaskButton.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: theme.interfaceColor], for: .normal)
        newTaskButton.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: theme.interfaceColor], for: .highlighted)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18),
             NSAttributedString.Key.foregroundColor: theme.interfaceColor], for: .normal)
        navSeparatorView.backgroundColor = theme.interfaceColor
        mainBGImageView.image = UIImage(imageLiteralResourceName: theme.mainBackgroundImageName)
        minorBGImageView.image = UIImage(imageLiteralResourceName: theme.minorBackgroundImageName)
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
        alexLayer2widthConstraint.constant = view.frame.width*3.2
        alexLayer2HeightConstraint.constant = view.frame.width*1.8
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(checkMenu))
        view.backgroundColor = nil
    }
    
    @objc func checkMenu() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "Menu") as! MenuViewController
        Main.instance.transitionSide = "left"
        router?.push(vc: destinationVC, animated: true)
    }
}
