//
//  ThemesViewController.swift
//  TODO
//
//  Created by Vit K on 28.05.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet var containerView: UIView!
    
    private var rootController: UIViewController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.selectedSegmentIndex = Main.instance.themeService.getState().rawValue
        
        let backItem = UIBarButtonItem()
        backItem.title = "Настройки"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }
    override func viewWillLayoutSubviews() {
        updateTheme(state: Main.instance.themeService.getState())
        
    }
    
    @IBAction func themesSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            updateTheme(state: .Vitaliy)
        case 1:
            updateTheme(state: .Alexey)
        case 2:
            updateTheme(state: .Alexander)
        default:
            break
        }
    }
    
    func updateTheme(state: ThemeState) {
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }
        if self.children.count > 0 {
            self.children.forEach {
                $0.removeFromParent()
            }
        }
        Main.instance.themeService.changeState(state: state)
        
        updatePresentationController()
    }
    
    func updatePresentationController() {
        let theme = Main.instance.themeService.getTheme()
        let navigationController = UINavigationController()
        let presentationGeneralViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GeneralTableViewController") as! GeneralTableViewController
        navigationController.viewControllers = [ presentationGeneralViewController ]
        presentationGeneralViewController.isAnimationFirstStart = false
        addChild(navigationController)
        containerView.addSubview(navigationController.view)
        
        navigationController.view.isUserInteractionEnabled = false
        navigationController.view.clipsToBounds = true
        navigationController.didMove(toParent: self)
        
        self.rootController = navigationController
        
        let rootView = rootController.view
        rootView?.frame = containerView.bounds
        rootView?.layer.cornerRadius = 16
        rootView?.layer.borderWidth = 2
        rootView?.layer.borderColor = theme.interfaceColor.cgColor
        view.applyGradient(colours: [theme.backgroundColor, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        containerView.backgroundColor = .mainBackground
        containerView.layer.cornerRadius = 16
        self.navigationController?.navigationBar.barTintColor = theme.backgroundColor
        self.navigationController?.navigationBar.tintColor = theme.interfaceColor
        segment.backgroundColor = theme.backgroundColor
        segment.tintColor = theme.interfaceColor
        segment.setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),
             NSAttributedString.Key.foregroundColor: theme.interfaceColor], for: .normal)
        segment.selectedSegmentTintColor = .mainBackground
    }
}
