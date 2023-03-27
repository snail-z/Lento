//
//  MAPopupAnimation.swift
//  Lento
//
//  Created by zhang on 2022/12/30.
//

import UIKit

public enum POAnimaType {
    case none
    case capted
}

public class MAPopupAnimation: NSObject {
    
    public var type: POAnimaType = .none
    
    public init(type: POAnimaType) {
        self.type = type
    }
}

extension MAPopupAnimation: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
     
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        
        switch type {
        case .none:
            if toVC.isBeingPresented {
                let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
                toView?.frame = containerView.bounds
                toView?.center = CGPointMake(containerView.center.x, containerView.center.y);
                
                let half = CGSize(width: containerView.bounds.width / 2, height: containerView.bounds.height / 2)
                toView?.centerY = containerView.bounds.height + half.height
                
//                toView?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                containerView.addSubview(toView!)
                
                UIView.animate(withDuration: duration, delay: 0) {
                    toView?.center = containerView.center
                } completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
            
            if fromVC.isBeingDismissed {
                let froView = transitionContext.view(forKey: UITransitionContextViewKey.from)
                let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
                froView?.frame = containerView.bounds
                froView?.center = CGPointMake(containerView.center.x, containerView.center.y);
                let half = CGSize(width: containerView.bounds.width / 2, height: containerView.bounds.height / 2)
                
                let stView = froView?.subviews.first
                
                UIView.animate(withDuration: duration, delay: 0) {
                    froView?.layer.cornerRadius = 20
                    froView?.layer.masksToBounds = true
                    froView?.centerY = containerView.bounds.height + half.height
                    //                froView?.backgroundColor = .clear
                    //                stView?.centerY = containerView.bounds.height + half.height
                } completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    
                }
            }
        
            
        default:
            guard let snapshot = fromVC.view?.snapshotView(afterScreenUpdates: false) else {
                transitionContext.completeTransition(false)
                return
            }
            
            print("snapshot is: ===> \(snapshot)")
        
            snapshot.backgroundColor = .orange
            containerView.addSubview(snapshot)
            
            
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            toView?.frame = containerView.bounds
            toView?.center = CGPointMake(containerView.center.x, containerView.center.y);
            
            let half = CGSize(width: containerView.bounds.width / 2, height: containerView.bounds.height / 2)
            toView?.centerY = containerView.bounds.height + half.height
            
//            toView?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            containerView.addSubview(toView!)
            
            UIView.animate(withDuration: duration, delay: 0) {
                snapshot.center = CGPoint(x: containerView.center.x, y: -containerView.bounds.height / 2)
                toView?.center = containerView.center
            } completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        }
            
            
        
        
    }
    
}
