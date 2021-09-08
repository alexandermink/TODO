//
//  GeneralTableViewController.swift
//  TODO
//
//  Created by Александр Минк on 19.10.2020.
//  Copyright © 2020 Alexander Mink. All rights reserved.
//

import UIKit
import RealmSwift
import Lottie
//import Drops

class GeneralTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backLayer: Rounding!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var newTaskButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
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
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.contentView.addSubview(vibrancyView)
        
        return blurEffectView
    }()
    let anView = AnimationView()
    var isAnimation: Bool = true
    var index: IndexPath = [0,0]
    
    var filteredSection: SectionTask = SectionTask()
    var isFilteredFavorite: Bool = false
    var isFilteredDone: Bool = false
    let theme = Main.instance.themeService.getTheme()
    let dropsData = DropsData()
    
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        if isAnimation {
            startAnimation()
            dropsData.makeGreatingDrop()
        }
                
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
        
//        if !dropsData.isFirstStart777 {
//            MockDataFactory.makeMockData(sections: MockDataFactory.mockDataSet)
//            UserDefaults.standard.set(true, forKey: "isFirstStart")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.bounds.size.height = view.bounds.size.height
        changeTheme()
        self.tableView.reloadData()
        if isAnimation {
            TableRowsAnimation.animateTable(table: tableView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.dismissKeyboard()
    }
    
    private func startAnimation() {
        let animation = Animation.named("anim")
        anView.frame = view.bounds
        anView.backgroundColor = .white
        anView.animation = animation
        anView.contentMode = .scaleAspectFit
        anView.loopMode = .loop
        anView.play()
        
        anView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width/2, height: view.frame.size.height/2)
        blurEffectView.frame = view.bounds
        anView.center = view.center
        anView.backgroundColor = .clear
        blurEffectView.alpha = 0.8
        view.addSubview(blurEffectView)
        view.addSubview(anView)
        
        navigationItem.leftBarButtonItem?.isEnabled = false
        newTaskButton.isEnabled = false
        
        anView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width/2, height: view.frame.size.height/2)
        blurEffectView.frame = view.bounds
        anView.center = view.center
        anView.backgroundColor = .clear
        blurEffectView.alpha = 0.8
        view.addSubview(blurEffectView)
        view.addSubview(anView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            
            self.anView.removeFromSuperview()
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.newTaskButton.isEnabled = true
            UIView.animate(withDuration: 0.5) {
                self.blurEffectView.alpha = 0
            } completion: { finish in
                if finish {
                    self.blurEffectView.removeFromSuperview()
                }
            }
        }
    }
    
    //MARK: - TABLE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFilteredDone || self.isFilteredFavorite {
            return filteredSection.sectionTasks.count
        } else {
            return Main.instance.userSession.tasks[section].sectionTasks.count + 1
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isFilteredDone || self.isFilteredFavorite {
            return 1
        } else {
            return Main.instance.userSession.tasks.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.dataSource.isFilteredFavorite = self.isFilteredFavorite
        self.dataSource.isFilteredDone = self.isFilteredDone
        self.dataSource.filteredSection = self.filteredSection
        return self.dataSource.getCell(at: tableView, indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        self.dataSource.isEditRow(tableView, canEditRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.dataSource.editingStyle(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.isFilteredDone || self.isFilteredFavorite {
            return filteredSection.sectionName
        } else {
            return Main.instance.userSession.tasks[section].sectionName
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.dataSource.viewHeaderSection(tableView, viewForHeaderInSection: section)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSource.selectRow(tableView, didSelectRowAt: indexPath, router: router!)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        var task = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
        
        let imgMark = UIImage(systemName: "checkmark")
        let dropDone = Drop(title: task.isDone ? "Не выполнено" : "Выполнено", subtitle: task.name, icon: task.isDone ? nil : imgMark, position: .top)
        let dropFavorite = Drop(title: task.isFavorite ? "Удалено из избранного" : "Добавлено в избранное", subtitle: task.name, icon: task.isFavorite ? nil : imgMark, position: .top)
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController in
            let navigationController = UINavigationController()
            let destinationViewController = TaskDetailViewController()
            navigationController.viewControllers.append(destinationViewController)
            
            self.index = indexPath
            
            let object = Main.instance.userSession.tasks[self.index.section].sectionTasks[self.index.row]
            destinationViewController.task = object
            
            return navigationController
        }) { actions -> UIMenu? in
            
            let first = UIAction(title: "Выполнено", image: nil, state: task.isDone ? .on : .off) { action in
                task.isDone.toggle()
                try? Main.instance.updateTask(task: task)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {Drops.show(dropDone)}
                print("KEy one")
            }
            let second = UIAction(title: "Избранное", image: nil, state: task.isFavorite ? .on : .off) { action in
                task.isFavorite.toggle()
                try? Main.instance.updateTask(task: task)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {Drops.show(dropFavorite)}
                print("KEy two")
            }
            let third = UIAction(title: "Удалить", image: nil, attributes: .destructive) { action in
                print("KEy three")
                let secondAlert = UIAlertController(title: "Внимание", message: "Подтвердить удаление?", preferredStyle: .alert)
                secondAlert.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { action in
                    try? Main.instance.deleteTask(task: task)
                }))
                secondAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { action in
                    return
                }))
                self.present(secondAlert, animated: true, completion: nil)
            }
            
            return UIMenu(title: "Menu", image: nil, identifier: nil, options: .displayInline, children: [first, second, third])
        }
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            let navigationController = UINavigationController()
            let destinationViewController = TaskDetailViewController()
            navigationController.presentationController?.delegate = destinationViewController
            let object = Main.instance.userSession.tasks[self.index.section].sectionTasks[self.index.row]
            destinationViewController.task = object
            navigationController.viewControllers.append(destinationViewController)
            self.router?.present(vc: navigationController)
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
        
        let isFavorite = UIAction(title: "Избранные", image: nil) { action in
            self.filteredSection = SectionTask()
            self.isFilteredFavorite = true
            self.isFilteredDone = false
            self.filteredSection.sectionName = "Избранные"
            try? Main.instance.getTasksFromRealm()
            for section in Main.instance.userSession.tasks {
                for task in section.sectionTasks {
                    if task.isFavorite {
                        self.filteredSection.addTaskInSection(task: task)
                    }
                }
            }
            self.tableView.reloadData()
            print("KEy one")
        }
        let isDone = UIAction(title: "Завершенные", image: nil) { action in
            self.filteredSection = SectionTask()
            self.isFilteredFavorite = false
            self.isFilteredDone = true
            self.filteredSection.sectionName = "Завершенные"
            try? Main.instance.getTasksFromRealm()
            for section in Main.instance.userSession.tasks {
                for task in section.sectionTasks {
                    if task.isDone {
                        self.filteredSection.addTaskInSection(task: task)
                    }
                }
            }
            self.tableView.reloadData()
            print("KEy two")
        }
        let clearFilter = UIAction(title: "Сбросить фильтры", image: nil, attributes: .destructive) { action in
            self.filteredSection = SectionTask()
            self.isFilteredFavorite = false
            self.isFilteredDone = false
            self.filteredSection.sectionName = ""
            self.tableView.reloadData()
            print("KEy three")
        }
        
        filterButton.primaryAction = nil
        filterButton.menu = UIMenu(title: "Фильтры", children: [isFavorite, isDone, clearFilter])
        
        mainBGWidthConstraint.constant = view.frame.width*3.2
        mainBGHeightConstraint.constant = view.frame.width*1.8
        minorBGWidthConstraint.constant = view.frame.width*3.2
        minorBGHeightConstraint.constant = view.frame.width*1.8
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(checkMenu)), UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(info))]
        view.backgroundColor = nil
        
    }
    
    @objc func checkMenu() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "Menu") as! MenuViewController
        Main.instance.transitionSide = "left"
        router?.push(vc: destinationVC, animated: true)
    }
    
    @objc func info() {
        let destinationViewController = InfoViewController()
        router?.present(vc: destinationViewController)
    }
}
