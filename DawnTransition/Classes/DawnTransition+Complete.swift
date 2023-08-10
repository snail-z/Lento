//
//  DawnTransition+Complete.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/9.
//

import UIKit

extension DawnTransition {

    internal func complete(finished: Bool) {
        guard state == .animating || state == .starting else { return }
        defer {
            inNavigationController = false
            transitionContext = nil
            fromViewController = nil
            toViewController = nil
            containerView = nil
            state = .possible
        }
        state = .completing
        
        let transitionCancelled = transitionContext!.transitionWasCancelled
        
        guard finished else {
            transitionContext!.cancelInteractiveTransition()
            transitionContext!.completeTransition(transitionCancelled)
            return
        }
        
        if !transitionCancelled {
            addSubview(toViewController!.view)
            removeView(fromViewController!.view)
        }
        
        transitionContext!.completeTransition(!transitionCancelled)
        
        guard inNavigationController else { return }
        if isPresenting {
            if toViewController!.dawn.isNavigationEnabled {
                Dawn.unSwizzlePushViewController()
                Dawn.swizzlePopViewController()
            }
        } else {
            if fromViewController!.dawn.isNavigationEnabled, !transitionCancelled {
                Dawn.unSwizzlePopViewController()
            }
        }
    }
}

extension DawnTransition {
    
    fileprivate func addSubview(_ aView: UIView) {
        guard aView.superview == nil else { return }
        aView.frame = containerView!.bounds
        containerView!.addSubview(aView)
    }
    
    fileprivate func removeView(_ aView: UIView) {
        guard aView.superview != nil else { return }
        aView.removeFromSuperview()
    }
}
