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
//            Main.instance.state = "1"
            Main.instance.themeService.changeState(state: .Vitaliy)
            segment.selectedSegmentIndex = 0
//            UserDefaults.standard.set(Main.instance.state, forKey: "k")
//            UIApplication.shared.windows.first!.applyGradient(colours: [.vitDarkBrown, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        case 1:
//            Main.instance.state = "2"
            Main.instance.themeService.changeState(state: .Alexey)
//            UserDefaults.standard.set(Main.instance.state, forKey: "k")
//            UIApplication.shared.windows.first!.applyGradient(colours: [.alexeyFog, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        case 2:
//            Main.instance.state = "3"
            Main.instance.themeService.changeState(state: .Alexander)
//            UserDefaults.standard.set(Main.instance.state, forKey: "k")
//            UIApplication.shared.windows.first!.applyGradient(colours: [.alexDarkRed, .mainBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        default:
            break
        }
    }
}
