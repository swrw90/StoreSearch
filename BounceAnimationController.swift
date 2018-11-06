//
//  BounceAnimationController.swift
//  StoreSearch
//
//  Created by Seth Watson on 11/2/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import Foundation
import UIKit

// Handles BounceAnimation for when popUpView is presented, animates the screen while it’s being presented or dismissed
class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // Determines how long the animation is
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    // Performs the animation
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Gives a reference to a new view controller and how big it should be
        if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
            
            let containerView = transitionContext.containerView
            toView.frame = transitionContext.finalFrame(for: toViewController)
            containerView.addSubview(toView)
            toView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            // Animation starts
            UIView.animateKeyframes(withDuration: transitionDuration(
                using: transitionContext), delay: 0, options: .calculationModeCubic, animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.334, animations: {
                                        toView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.333, animations: {
                                        toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    })
                    UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333, animations: {
                                        toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    })
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
}
