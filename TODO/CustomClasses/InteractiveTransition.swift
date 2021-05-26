//
//  InteractiveTransition.swift
//  TODO
//
//  Created by Vit K on 23.05.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgeGesture(_:)))
            if Main.instance.transitionSide == "left" {
                recognizer.edges = [.right]
            } else {
                recognizer.edges = [.left]
            }
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false

    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            
            // TODO: оптимизировать
            let translation = recognizer.translation(in: recognizer.view)
            if Main.instance.transitionSide == "left" {
                let relativeTranslation = -translation.x / (recognizer.view?.bounds.width ?? 1)
                let progress = max(0, min(1, relativeTranslation))
                self.shouldFinish = progress > 0.33
                self.update(progress)
            } else {
                let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
                let progress = max(0, min(1, relativeTranslation))
                self.shouldFinish = progress > 0.33
                self.update(progress)
            }
            
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default: return
        }
    }
}
