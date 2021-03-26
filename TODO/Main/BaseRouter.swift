//
//  BaseRouter.swift
//  TODO
//
//  Created by Алексей Мальков on 26.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import Foundation
import UIKit

class BaseRouter{
    
    var viewController: UIViewController!
    
    init(viewController: UIViewController){
        self.viewController = viewController
    }
    
    final func push(vc: UIViewController, animated : Bool = true) {
        viewController.navigationController?.pushViewController(vc, animated: animated)
    }
    
    final func dismiss(animated : Bool = true, completion: (() -> Void)? = nil) {
        viewController.dismiss(animated: animated, completion: completion)
    }
}
