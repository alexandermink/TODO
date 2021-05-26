//
//  TransitionAnimator.swift
//  TODO
//
//  Created by Vit K on 23.05.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

let duration = 0.8

final class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {duration}
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let source = transitionContext.viewController(forKey: .from)!
        let destination = transitionContext.viewController(forKey: .to)!
        transitionContext.containerView.addSubview(source.view)
        transitionContext.containerView.addSubview(destination.view)
        
        if Main.instance.transitionSide == "left" {
            destination.view.frame.origin.x = -destination.view.frame.size.width
            UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                source.view.frame.origin.x = source.view.frame.size.width*1.2
//                source.view.frame.origin.x = 260
                destination.view.frame.origin.x = 0
//                destination.view.bounds.size.width = 260
                source.view.alpha = 0
            }){ finished in
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            }
        } else {
            destination.view.frame.origin.x = destination.view.frame.size.width
            UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                source.view.frame.origin.x = -source.view.frame.size.width*1.2
                destination.view.frame.origin.x = 0
                source.view.alpha = 0
            }){ finished in
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            }
        }
    }
}


final class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {duration}
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let source = transitionContext.viewController(forKey: .from)!
        let destination = transitionContext.viewController(forKey: .to)!
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        if Main.instance.transitionSide == "left" {
            destination.view.frame.origin.x = source.view.frame.size.width*2
            UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                destination.view.frame.origin.x = 0
                source.view.frame.origin.x = -source.view.frame.size.width
                destination.view.alpha = 1
            }) { finished in
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            }
        } else {
            destination.view.frame.origin.x = -source.view.frame.size.width*2
            UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                destination.view.frame.origin.x = 0
                source.view.frame.origin.x = source.view.frame.size.width
                destination.view.alpha = 1
            }) { finished in
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            }
        }
    }
}
