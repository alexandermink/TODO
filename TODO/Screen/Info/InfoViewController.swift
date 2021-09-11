//
//  InfoViewController.swift
//  TODO
//
//  Created by Алексей Мальков on 08.09.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    let infoView = InfoView()
    
    override func loadView() {
        view = infoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = "Настройки"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        infoView.changeTheme()
    }
}
