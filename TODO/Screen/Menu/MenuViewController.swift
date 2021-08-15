//
//  MenuViewController.swift
//  TODO
//
//  Created by Vit K on 18.05.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var settingsShadowBackLayer: UIView!
    @IBOutlet weak var settingsBackLayer: UIView!
    @IBOutlet weak var menuBackLayerTrailingConstr: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var blurViewTrailingConstr: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var mainBGImageView: UIImageView!
    @IBOutlet weak var mainBGWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainBGHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainBGLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var minorBGImageView: UIImageView!
    @IBOutlet weak var minorBGHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var minorBGWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var minorBGLeadingConstraint: NSLayoutConstraint!
    
    
    var router: BaseRouter?
    let settings = SettingsFactory.makeSetting()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewScreen()
        router = BaseRouter(viewController: self)
        view.backgroundColor = nil
        settingsBackLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        blurView.layer.cornerRadius = 24
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.darkGray.cgColor
        ParalaxEffect.paralaxEffect(view: mainBGImageView, magnitude: 50)
        ParalaxEffect.paralaxEffect(view: minorBGImageView, magnitude: -50)
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainBGLeadingConstraint.constant = -(view.frame.size.width * 1.4 - 500)
        minorBGLeadingConstraint.constant = -(view.frame.size.width * 1.4 - 300)
        changeTheme()
        print(view.frame.width, " 🍎🍎🍎🍎🍎")
    }
    
    func deleteAllData() {
        let firstAlert = UIAlertController(title: "ВНИМАНИЕ!", message: "Все данные будут удалены", preferredStyle: .alert)
        firstAlert.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { action in
            let secondAlert = UIAlertController(title: "ВНИМАНИЕ!!!", message: "Подтвердить удаление?", preferredStyle: .alert)
            secondAlert.addAction(UIAlertAction(title: "Удалить", style: .default, handler: { action in
                try? Main.instance.deleteAllData()
                self.router?.pop()
            }))
            secondAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { action in
                return
            }))
            self.present(secondAlert, animated: true, completion: nil)
        }))
        firstAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { action in
            return
        }))
        self.present(firstAlert, animated: true, completion: nil)
    }
    
    func changeTheme() {
        let theme = Main.instance.themeService.getTheme()
        
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        navigationController?.navigationBar.tintColor = theme.interfaceColor
        
        mainBGImageView.image = UIImage(imageLiteralResourceName: theme.mainBackgroundImageName)
        minorBGImageView.image = UIImage(imageLiteralResourceName: theme.minorBackgroundImageName)
    }
    
    func setViewScreen() {
        
        mainBGWidthConstraint.constant = view.frame.width*3.2
        mainBGHeightConstraint.constant = view.frame.width*1.8
        minorBGWidthConstraint.constant = view.frame.width*3.2
        minorBGHeightConstraint.constant = view.frame.width*1.8
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].settingsFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        let set = settings[indexPath.section].settingsFields[indexPath.row]
        
        cell.textLabel?.text = set.name
        cell.imageView?.image = UIImage(systemName: set.picture ?? "clear")
        cell.accessoryType = set.isDisclosure ? .disclosureIndicator : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settings[section].name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Themes", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: "Themes") as! ThemesViewController
        switch indexPath {
        case [0, 0]:
            router?.push(vc: destinationVC, animated: true)
        case [1, 0]:
            guard let url = URL(string: "https://vk.com/public206096643") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case[1, 1]:
//            let storyboard = UIStoryboard(name: "Developers", bundle: nil)
//            let developerVC = storyboard.instantiateViewController(identifier: "Developers") as! DevelopersMenuVC
            let storyboard = UIStoryboard(name: "Developers", bundle: nil)
            let developerVC = storyboard.instantiateViewController(identifier: "TestVC") as! TestVC
            router?.push(vc: developerVC)
        case [2, 0]:
            print("кнопка очистить данные нажата")
            deleteAllData()
        default:
            break
        }
    }
}

