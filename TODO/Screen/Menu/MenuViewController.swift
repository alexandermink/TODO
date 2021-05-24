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

    
    var router: BaseRouter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = BaseRouter(viewController: self)
        view.backgroundColor = nil
        settingsBackLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        
        blurView.layer.cornerRadius = 24
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .vitDarkBrown
    }
    
    @IBAction func deleteAllData(_ sender: Any) {
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
    
    @IBAction func theme1action(_ sender: Any) {
        Main.instance.state = "1"
        UserDefaults.standard.set(Main.instance.state, forKey: "k")
    }
    
    @IBAction func theme2action(_ sender: Any) {
        Main.instance.state = "2"
        UserDefaults.standard.set(Main.instance.state, forKey: "k")
    }
    
    @IBAction func theme3action(_ sender: Any) {
        Main.instance.state = "3"
        UserDefaults.standard.set(Main.instance.state, forKey: "k")
    }
    
    @IBAction func hideCloudsAction(_ sender: Any) {
        if Main.instance.isCloudsHidden! {
            Main.instance.isCloudsHidden = false
            UserDefaults.standard.set(Main.instance.isCloudsHidden, forKey: "clouds")
//            cloudsImageView.isHidden = false
        } else {
            Main.instance.isCloudsHidden = true
            UserDefaults.standard.set(Main.instance.isCloudsHidden, forKey: "clouds")
//            cloudsImageView.isHidden = true
        }
    }
}
