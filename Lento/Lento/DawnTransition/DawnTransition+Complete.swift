//
//  DawnTransition+Complete.swift
//  Lento
//
//  Created by zhang on 2023/6/9.
//

import UIKit

extension DawnTransition {

    public func complete(finished: Bool) {
        guard state == .animating || state == .starting else { return }
        defer {
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
    }
}

extension DawnTransition {
    
    fileprivate func addSubview(_ aView: UIView) {
        guard aView.superview == nil else { return }
        containerView!.addSubview(aView)
    }
    
    fileprivate func removeView(_ aView: UIView) {
        guard aView.superview != nil else { return }
        aView.removeFromSuperview()
    }
}
