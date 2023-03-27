//
//  MAWaterfallPopTransion.swift
//  Lento
//
//  Created by zhang on 2022/10/25.
//

import UIKit

class MAWaterfallPopTransion: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MAWaterfallDetailViewController,
              let toVC = transitionContext.viewController(forKey: .to) as? MAWaterfallLayoutViewController else {
            transitionContext.completeTransition(false)
            return
        }
        
        let container = transitionContext.containerView
    
        guard let currentImgView = fromVC.imageView else {
            transitionContext.completeTransition(false)
            return
        }
                
        guard let snapshot = fromVC.imageView?.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        snapshot.layer.masksToBounds = true
        
        toVC.currentImageView.superview?.layoutIfNeeded()
        
        snapshot.frame = container.convert(currentImgView.frame, from: currentImgView.superview)
        currentImgView.isHidden = true
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        toVC.currentImageView.alpha = 0
        
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        container.addSubview(snapshot)
        
        let _frame = toVC.view.convert(toVC.currentImageView.frame, from: toVC.currentImageView.superview)
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            snapshot.layer.cornerRadius = 6
            snapshot.frame = _frame
            fromVC.view.alpha = 0
            toVC.view.alpha = 1
        } completion: { finshed in
            toVC.currentImageView.alpha = 1
            currentImgView.isHidden = false
            snapshot.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
