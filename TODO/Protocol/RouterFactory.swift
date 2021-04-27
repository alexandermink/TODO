//
//  RouterFactory.swift
//  TODO
//
//  Created by Алексей Мальков on 01.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

protocol RouterFactory {
    func push(vc: UIViewController, animated : Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func present(vc: UIViewController, animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool)
}
