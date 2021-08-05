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
    let isFirstStart = UserDefaults.standard.bool(forKey: "isFirstStart")
    var isAnimation: Bool = true
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        
        startAnimation()
        anView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width/2, height: view.frame.size.height/2)
        blurEffectView.frame = view.bounds
        anView.center = view.center
        anView.backgroundColor = .clear
        blurEffectView.alpha = 0.8
        view.addSubview(blurEffectView)
        view.addSubview(anView)
        if isAnimation {
            startAnimation()
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
        
        if !isFirstStart {
            MockDataFactory.makeMockData(sections: MockDataFactory.mockDataSet)
            UserDefaults.standard.set(true, forKey: "isFirstStart")
        }
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
//            self.blurEffectView.removeFromSuperview()
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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController in
            let navigationController = UINavigationController()
            let destinationViewController = TaskDetailViewController()
            navigationController.viewControllers.append(destinationViewController)
            
            return navigationController
        }) { actions -> UIMenu? in
            let first = UIAction(title: "Пункт № 1", image: UIImage(systemName: "book.circle.fill"), discoverabilityTitle: "подзаголовок", attributes: .disabled, state: .on) { action in
                //
            }
            let second = UIAction(title: "Какое-то действие", image: nil, attributes: .disabled, state: .mixed) { action in
                //
            }
            let third = UIAction(title: "Сделать что-то", image: UIImage(systemName: "person.3"), discoverabilityTitle: "неизвестно что...", attributes: .destructive, state: .off) { action in
                //
            }
            return UIMenu(title: "Menu", image: nil, identifier: nil, options: .displayInline, children: [first, second, third])
        }
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            let navigationController = UINavigationController()
            let destinationViewController = TaskDetailViewController()
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
        newTaskButton.title = "Новая задача"
        mainBGWidthConstraint.constant = view.frame.width*3.2
        mainBGHeightConstraint.constant = view.frame.width*1.8
        minorBGWidthConstraint.constant = view.frame.width*3.2
        minorBGHeightConstraint.constant = view.frame.width*1.8
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(checkMenu))
        view.backgroundColor = nil
        
    }
    
    @objc func checkMenu() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "Menu") as! MenuViewController
        Main.instance.transitionSide = "left"
        router?.push(vc: destinationVC, animated: true)
    }
}
