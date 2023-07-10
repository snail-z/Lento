//
//  DawnTransition+UINavigationControllerDelegate.swift
//  Lento
//
//  Created by zhang on 2023/7/10.
//

import UIKit

extension DawnTransition: UINavigationControllerDelegate {
    
    private var interactiveTransitioning: UIViewControllerInteractiveTransitioning? {
        return driveninViewController?.dawn.interactiveDriver
    }
    
  public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if let previousNavigationDelegate = navigationController.previousNavigationDelegate {
      previousNavigationDelegate.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
  }

  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    if let previousNavigationDelegate = navigationController.previousNavigationDelegate {
      previousNavigationDelegate.navigationController?(navigationController, didShow: viewController, animated: animated)
    }
  }

  public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    guard !isTransitioning else { return nil }
      self.state = .starting
    self.isPresenting = operation == .push
//    self.fromViewController = fromViewController ?? fromVC
//    self.toViewController = toViewController ?? toVC
//      containerView = transitionContext.containerView
//    self.inNavigationController = true/
//      animate()
    return self
  }
    

  public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
      return interactiveTransitioning
  }
}


extension DawnTransition {
    
    
    public func animate22() {
        guard state == .starting else { return }
        state = .animating
        
        guard let fromVC = fromViewController, let toVC = toViewController else {
            complete(finished: false)
            return
        }
        
        
        Dawn.animate(duration: 0.5, delay: 0, options: .curveEaseInOut, springStiffness: nil) {
            
        } completion: { find in
            
            
        }

    }
}
