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
    
    private var rootController: UIViewController?
    
    private var currentTheme: Theme = Theme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.selectedSegmentIndex = Main.instance.themeService.getState().rawValue
        
        updatePresentationController()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let rootView = rootController?.view else { return }
        rootView.frame = containerView.bounds
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
        let navigationController = UINavigationController()
        let presentationGeneralViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GeneralTableViewController") as! GeneralTableViewController
        navigationController.viewControllers = [ presentationGeneralViewController ]
        
        addChild(navigationController)
        containerView.addSubview(navigationController.view)
        
        navigationController.view.isUserInteractionEnabled = false
        navigationController.view.clipsToBounds = true
        navigationController.didMove(toParent: self)
        
        self.rootController = navigationController
    }
}
