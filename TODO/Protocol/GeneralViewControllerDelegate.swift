//
//  GeneralViewControllerDelegate.swift
//  TODO
//
//  Created by Vit K on 18.05.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

protocol GeneralViewControllerDelegate: AnyObject {
    func menuAction()
    func closeMenu()
}

protocol MenuViewControllerDelegate: AnyObject {
    func changeSta(state: String)
}

