//
//  BaseRouter.swift
//  TODO
//
//  Created by Алексей Мальков on 26.03.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

final class BaseRouter: RouterFactory{
        
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController){
        self.viewController = viewController
    }
    
    func push(vc: UIViewController, animated: Bool = true) {
        viewController?.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController?.dismiss(animated: animated, completion: completion)
    }
    
    func present(vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController?.present(vc, animated: animated, completion: completion)
    }

    func pop(animated: Bool = true){
        viewController?.navigationController?.popViewController(animated: animated)
    }
}

