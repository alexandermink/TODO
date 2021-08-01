//
//  GeneralTableViewController.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift

class GeneralTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backLayer: Rounding!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var newTaskButton: UIBarButtonItem!
    @IBOutlet weak var mainBGImageView: UIImageView!
    @IBOutlet weak var mainBGWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainBGHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navSeparatorView: UIView!
    @IBOutlet weak var minorBGImageView: UIImageView!
    @IBOutlet weak var minorBGWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var minorBGHeightConstraint: NSLayoutConstraint!
    
    
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
        self.dataSource.getCell(at: tableView, indexPath: indexPath)
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
        self.dataSource.viewHeaderSection(tableView, viewForHeaderInSection: section)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSource.selectRow(tableView, didSelectRowAt: indexPath, router: router!)
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
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
    }
    
    //MARK: - SET VIEW SCREEN
    func setViewScreen() {
        backLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        blurView.layer.cornerRadius = 24
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.darkGray.cgColor
        newTaskButton.title = "Новая задача"
        mainBGWidthConstraint.constant = view.frame.width*3.2
        mainBGHeightConstraint.constant = view.frame.width*1.8
        minorBGWidthConstraint.constant = view.frame.width*3.2
        minorBGHeightConstraint.constant = view.frame.width*1.8
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
