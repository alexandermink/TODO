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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.selectedSegmentIndex = Main.instance.themeService.getState().rawValue
    }
    
    @IBAction func themesSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Main.instance.themeService.changeState(state: .Vitaliy)
        case 1:
            Main.instance.themeService.changeState(state: .Alexey)
        case 2:
            Main.instance.themeService.changeState(state: .Alexander)
        default:
            break
        }
    }
}
