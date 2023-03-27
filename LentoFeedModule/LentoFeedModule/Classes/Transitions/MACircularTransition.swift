//
//  MACircularTransition.swift
//  Lento
//
//  Created by zhang on 2022/10/26.
//

import UIKit

protocol MACircleTransitionable {
    
    var triggerButton: UIButton { get }
  
    var contentTextView: UITextView { get }
  
    var mainView: UIView { get }
}

class MACircularTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? MACircleTransitionable,
            let toVC = transitionContext.viewController(forKey: .to) as? MACircleTransitionable,
                let snapshot = fromVC.mainView.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
//        let backgroundView = UIView()
//        backgroundView.frame = toVC.mainView.frame
//        backgroundView.backgroundColor = .random(.cooler)
//        containerView.addSubview(backgroundView)
//        
//        containerView.addSubview(snapshot)
//        fromVC.mainView.removeFromSuperview()
        
        
        
        toVC.mainView.frame = transitionContext.finalFrame(for: toVC as! UIViewController)
        toVC.mainView.alpha = 0
        
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}
