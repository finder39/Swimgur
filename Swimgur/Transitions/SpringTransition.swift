//
//  SpringTransition.swift
//  Swimgur
//
//  Created by Joseph Neuman on 8/9/14.
//  Copyright (c) 2014 Joseph Neuman. All rights reserved.
//

import Foundation
import UIKit

class SpringTransition: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
    return 0.5
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
    // 1. obtain state from the context
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewKey)
    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewKey)
    
    let finalFrame = transitionContext.finalFrameForViewController(toViewController)
    
    // 2. obtain the container view
    let containerView = transitionContext.containerView()
    
    // 3. set initial state
    let screenBounds = UIScreen.mainScreen().bounds
    toViewController.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height)
    
    // 4. add the view
    containerView.addSubview(toViewController.view)
    
    let duration = self.transitionDuration(transitionContext)
    UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
      fromViewController.view.alpha = 0.5
      toViewController.view.frame = finalFrame
    }) { (finished) -> Void in
      // 6. inform the context of completion
      fromViewController.view.alpha = 1.0
      transitionContext.completeTransition(true)
    }
  }
}