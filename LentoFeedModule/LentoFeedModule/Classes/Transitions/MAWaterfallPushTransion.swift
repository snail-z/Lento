//
//  MAWaterfallPushTransion.swift
//  Lento
//
//  Created by zhang on 2022/10/25.
//

import UIKit

/**
 UIViewControllerAnimatedTransitioning - 转场动画控制协议
 UIViewControllerInteractiveTransitioning - 交互控制协议
 
 UIViewControllerContextTransitioning - 转场环境
 */


/**
 MagicMoveTransion
 */

protocol MAWaterfallTransitionable {
    
    var triggerButton: UIButton { get }
  
    var contentTextView: UITextView { get }
  
    var mainView: UIView { get }
}


class MAWaterfallPushTransion: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        /**
         通过viewForKey:获取的视图是viewControllerForKey:返回的控制器的根视图，或者 nil。viewForKey:方法返回 nil 只有一种情况： UIModalPresentationCustom 模式下的 Modal 转场 ，通过此方法获取 presentingView 时得到的将是 nil
         
         iOS 8 为UIViewControllerContextTransitioning协议添加了viewForKey:方法以方便获取 fromView 和 toView，但是在 Modal 转场里要注意，从上面可以知道，Custom 模式下，presentingView 并不受 containerView 管理，这时通过viewForKey:方法来获取 presentingView 得到的是 nil，必须通过viewControllerForKey:得到 presentingVC 后来获取。因此在 Modal 转场中，较稳妥的方法是从 fromVC 和 toVC 中获取 fromView 和 toView。
         */
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MAWaterfallLayoutViewController,
              let toVC = transitionContext.viewController(forKey: .to) as? MAWaterfallDetailViewController else {
            transitionContext.completeTransition(false)
            return
        }
        
        let container = transitionContext.containerView
    
        guard let currentImgView = fromVC.currentImageView else {
            transitionContext.completeTransition(false)
            return
        }
                
        guard let snapshot = fromVC.currentImageView?.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        
        toVC.imageView.superview?.layoutIfNeeded()
        
        snapshot.frame = container.convert(currentImgView.frame, from: currentImgView.superview)
        currentImgView.isHidden = true

        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        toVC.imageView.alpha = 0
        
        container.addSubview(toVC.view)
        container.addSubview(snapshot)
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            snapshot.frame = toVC.imageView.frame
            
            toVC.view.alpha = 1
        } completion: { finshed in
            toVC.imageView.alpha = 1
            currentImgView.isHidden = false
            snapshot.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}


class MAWaterfallInteractiveTransion: NSObject, UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    
}
