//
//  DawnTransition+Complete.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/9.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
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
        
        if transitionCancelled {
            addSubview(fromViewController!.view)
            removeSubview(toViewController!.view)
        } else {
            addSubview(toViewController!.view)
            removeSubview(fromViewController!.view)
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
        guard aView.superview != containerView else { return }
        aView.removeFromSuperview()
        aView.frame = containerView!.bounds
        containerView!.addSubview(aView)
    }
    
    fileprivate func removeSubview(_ aView: UIView) {
        guard aView.superview == containerView else { return }
        aView.removeFromSuperview()
    }
}
