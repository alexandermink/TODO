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
        
        switch Main.instance.state {
        case "1":
            segment.selectedSegmentIndex = 0
        case "2":
            segment.selectedSegmentIndex = 1
        case "3":
            segment.selectedSegmentIndex = 2
        default:
            break
        }
    }
    
    @IBAction func themesSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Main.instance.state = "1"
            UserDefaults.standard.set(Main.instance.state, forKey: "k")
            UIApplication.shared.windows.first!.applyGradient(colours: [.vitDarkBrown, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        case 1:
            Main.instance.state = "2"
            UserDefaults.standard.set(Main.instance.state, forKey: "k")
            UIApplication.shared.windows.first!.applyGradient(colours: [.alexeyFog, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        case 2:
            Main.instance.state = "3"
            UserDefaults.standard.set(Main.instance.state, forKey: "k")
            UIApplication.shared.windows.first!.applyGradient(colours: [.alexDarkRed, .vitBackground], startX: 0.5, startY: -1.2, endX: 0.5, endY: 0.7)
        default:
            break
        }
    }
}
