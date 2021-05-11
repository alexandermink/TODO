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
    @IBOutlet weak var navSeparatorView: UIView!
    @IBOutlet weak var vitThemeButton: UIButton!
    @IBOutlet weak var panEdgeView: UIView!
    @IBOutlet weak var alexLayer1: UIImageView!
    @IBOutlet weak var alexLayer2: UIImageView!
    @IBOutlet weak var alexLayer1widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var alexLayer1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var alexLayer2widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var alexLayer2HeightConstraint: NSLayoutConstraint!
    @IBOutlet var settingsButtons: [UIButton]!
    
    
    private var currentTheme : String? {didSet {tableView.reloadData()}}
    let realm = try! Realm()
    var realmTokenSections: NotificationToken?
    var router: BaseRouter?
    let main = Main.instance
    private var menuState: MenuState = .closed
    let panGestureRecognizer = UIPanGestureRecognizer()
    
    
    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragInteractionEnabled = true // Enable intra-app drags for iPhone.
        tableView.dragDelegate = self
        panGestureRecognizer.addTarget(self, action: #selector(closeMenu))
        panEdgeView.addGestureRecognizer(panGestureRecognizer)
        setViewScreen()
        UserDefaults.standard.string(forKey: "k")
        changeState(state: main.state ?? "1")
        UserDefaults.standard.bool(forKey: "clouds")
        if main.isCloudsHidden! {
            cloudsImageView.isHidden = true
        } else { cloudsImageView.isHidden = false }
        cloudsImageView.isHidden = true
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
        UIView.animate(withDuration: 180, delay: 0, options: [.curveLinear, .autoreverse, .repeat], animations: {
            self.cloudsImageView.frame = .init(x: 0, y: 0, width: self.view.frame.width*2, height: self.view.frame.width)
        }, completion: nil)
        self.tableView.reloadData()
    }
    
    //MARK: - TABLE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return main.userSession.tasks[section].sectionTasks.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return main.userSession.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == main.userSession.tasks[indexPath.section].sectionTasks.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddButtonCell", for: indexPath) as? AddButtonTableViewCell else { return UITableViewCell() }
            cell.addFastTaskNameTextField.textColor = .systemYellow
            cell.addButton.setTitleColor(.systemYellow, for: .normal)
            
            cell.indexPath = indexPath
            if !cell.styleEditing {
                cell.setEditing(false, animated: false)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralCell", for: indexPath) as? GeneralTableViewCell else { return UITableViewCell() }
            cell.selectedBackgroundView = {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
                view.backgroundColor = UIColor.hexStringToUIColor(hex: "#fcdab7")
                return view
            }()
            cell.taskNameLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].name
            cell.descriptionLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].taskDescription
            cell.notificationLabel.text = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].notificationDate
            cell.backgroundColor = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].backgroundColor
//            cell.notificationLabel.textColor = .systemYellow
            cell.configure(theme: currentTheme ?? "1")
            cell.descriptionLabel.textColor = .vitBackground

            
            let markSelectedCount = Float(main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].markSelectedCount)
            let allMarkCount = Float(main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row].checkList.count)
            
            var progress: Float = 0
            if allMarkCount > 0  {
                progress = markSelectedCount / allMarkCount
            }
            cell.checkProgressBar.setProgress(progress, animated: true)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == main.userSession.tasks[indexPath.section].sectionTasks.count{
            return false
        } else {
            return true
        }
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
        return main.userSession.tasks[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "someHeaderViewIdentifier") as? HeaderView else { return nil }
        headerView.configure(theme: currentTheme ?? "1", sameColorView: nil)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == main.userSession.tasks[indexPath.section].sectionTasks.count {
            print("ячейка с кнопкой 'Добавить' нажата")
        } else {
            let destinationViewController = TaskDetailViewController()
            let object = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
            destinationViewController.task = object
            router?.present(vc: destinationViewController)
            print("ячейка нажата")
        }
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
        return UIContextualAction(style: .normal, title: "ОК") { [self] (action, view, completion) in
            var task = Main.instance.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
            task.backgroundColor = main.rowBGCcolor
            main.rowBGCcolor = .clear
            try? Main.instance.updateTask(task: task)
            tableView.reloadData()
        }
    }
    
    //MARK: - ACTIONS
    func openMenu() {
        if main.isCloudsHidden! {
            cloudsImageView.isHidden = true
        } else {cloudsImageView.isHidden = false }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.backLayer.frame.origin.x += self.view.frame.width/1.2
            self.blurView.frame.origin.x += self.view.frame.width/1.2
            self.navSeparatorView.frame.origin.x += self.view.frame.width/1.2
            self.boatImageView.frame.origin.x += self.view.frame.width/1.2
            self.mapImageView.frame.origin.x += self.view.frame.width/1.2
            self.settingsStack.center = self.view.center
            self.alexLayer1.frame.origin.x += self.view.frame.width/1.2
            self.alexLayer2.frame.origin.x += self.view.frame.width/1.2
            
            self.blurView.backgroundColor = .black
            self.backLayer.backgroundColor = .vitBackground
            self.blurView.alpha = 0.5
            self.navigationItem.leftBarButtonItem?.title = "Скрыть"
            self.newTaskButton.isEnabled = false
            self.newTaskButton.title = ""
            self.panEdgeView.isHidden = false
        } completion: { [weak self] done in
            if done {
                self?.menuState = .opened
                self!.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
    }
    
    @objc func closeMenu() {
        self.cloudsImageView.isHidden = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.backLayer.frame.origin.x = 0
            self.blurView.frame.origin.x = 32
            self.navSeparatorView.frame.origin.x = 0
            self.boatImageView.frame.origin.x = -220
            self.mapImageView.frame.origin.x = -300
            self.settingsStack.center = CGPoint(x: -self.view.frame.width/2, y: self.view.frame.height/2)
            self.alexLayer1.frame.origin.x = -300
            self.alexLayer2.frame.origin.x = -300
            
            self.blurView.backgroundColor = .clear
            self.backLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
            self.blurView.alpha = 0.8
            self.navigationItem.leftBarButtonItem?.title = "Настройки"
            self.newTaskButton.isEnabled = true
            self.newTaskButton.title = "Новая задача"
            self.panEdgeView.isHidden = true 
        } completion: { [weak self] done in
            if done {
                self?.menuState = .closed
                self!.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
    }
    
    @objc func didTapMenuButton() {
        navigationItem.leftBarButtonItem?.isEnabled = false
        switch menuState {
        case .closed:
            openMenu()
        case .opened:
            closeMenu()
        }
    }
    
    @IBAction func newTaskBarButton(_ sender: Any) {
        print("нажата")
        let storyboard = UIStoryboard(name: "NewTaskStoryboard", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "NewTaskViewController") as! NewTaskViewController
        router?.present(vc: destinationVC, animated: true)
    }
    
    //MARK: - CHANGE STATE SETTINGS
    @IBAction func vitThemeTapped(_ sender: Any) {
        changeState(state: "1")
        main.state = "1"
        UserDefaults.standard.set(main.state, forKey: "k")
    }
    @IBAction func alexeyThemeTapped(_ sender: Any) {
        changeState(state: "2")
        main.state = "2"
        UserDefaults.standard.set(main.state, forKey: "k")
    }
    @IBAction func alexandrThemeTapped(_ sender: Any) {
        changeState(state: "3")
        main.state = "3"
        UserDefaults.standard.set(main.state, forKey: "k")
    }
    
    @IBAction func hideCloudsAction(_ sender: Any) {
        if main.isCloudsHidden! {
            main.isCloudsHidden = false
            UserDefaults.standard.set(main.isCloudsHidden, forKey: "clouds")
            cloudsImageView.isHidden = false
        } else {
            main.isCloudsHidden = true
            UserDefaults.standard.set(main.isCloudsHidden, forKey: "clouds")
            cloudsImageView.isHidden = true
        }
    }
    
    
    func changeState(state: String) {
        self.currentTheme = state
        switch state {
        case "1":
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
            view.applyGradient(colours: [.vitDarkBrown, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        case "2":
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
            view.applyGradient(colours: [.alexeyFog, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        case "3":
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
            view.applyGradient(colours: [.alexRed, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        default:
            break
        }
    }
    
    //MARK: - SET VIEW SCREEN
    func setViewScreen() {
        view.applyGradient(colours: [.vitDarkBrown, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
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
        
        settingsStackLeadingConstraint.constant = -view.frame.width/2
        self.cloudsImageView.frame = .init(x: -view.frame.width*4, y: 0, width: view.frame.width*2, height: view.frame.width)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Настройки", style: .done, target: self, action: #selector(didTapMenuButton))
        cloudsWidthConstraint.constant = view.frame.width*5.2
        cloudsHeightConstraint.constant = view.frame.width*2
        
        settingsButtons.forEach { buttons in
            buttons.setTitleColor(.alexeyFog, for: .normal)
        }
    }
}

extension GeneralTableViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = main.userSession.tasks[indexPath.section].sectionTasks[indexPath.row]
        return [ dragItem ]
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("sourceIndexPath :\(sourceIndexPath)")
        print("destinationIndexPath :\(destinationIndexPath)")
        
        let mover = main.userSession.tasks[sourceIndexPath.section].sectionTasks.remove(at: sourceIndexPath.row)
        main.userSession.tasks[destinationIndexPath.section].sectionTasks.insert(mover, at: destinationIndexPath.row)
        
//        try? main.updateTask(task: main.userSession.tasks[sourceIndexPath.section].sectionTasks[sourceIndexPath.row])
    }
}
