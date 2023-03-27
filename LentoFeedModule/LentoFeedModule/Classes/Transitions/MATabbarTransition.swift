//
//  MATabbarTransition.swift
//  Lento
//
//  Created by zhang on 2023/1/6.
//

import UIKit

public class MATabbarTransition: NSObject {

}

extension MATabbarTransition: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print("thereree"   )
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let container = transitionContext.containerView
    
        guard let currentImgView = fromVC.view else {
            transitionContext.completeTransition(false)
            return
        }
         
        var hahView = UIApplication.keyWindow()?.rootViewController?.view
    
        guard let snapshot = hahView?.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        snapshot.layer.masksToBounds = true
        
        
        container.addSubview(toVC.view!)
        container.addSubview(snapshot)
        
        let duration = transitionDuration(using: transitionContext)
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        toView?.frame = container.bounds
        toView?.center = CGPointMake(-container.bounds.width/2, container.center.y);
        
        let padding: CGFloat = 60
        UIView.animate(withDuration: duration) {
            toView?.center = CGPointMake(container.bounds.width/2-padding, container.center.y);
            snapshot.center = CGPoint(x: UIScreen.main.bounds.width + container.bounds.width/2-padding, y: snapshot.center.y)
            
        } completion: { finshed in
//            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
