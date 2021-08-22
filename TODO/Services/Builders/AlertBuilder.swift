//
//  AlertBuilder.swift
//  TODO
//
//  Created by Vit K on 02.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String,
                   message: String,
        handler: ((UIAlertAction) -> Void)? = nil) {
        
        let action = UIAlertAction(
            title: "ОК",
            style: .cancel,
            handler: handler)
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(
        _ message: String,
        handler: ((UIAlertAction) -> Void)? = nil) {
        
        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .cancel,
            handler: handler)
        let okAction = UIAlertAction(
            title: "ОК",
            style: .default,
            handler: handler)
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
