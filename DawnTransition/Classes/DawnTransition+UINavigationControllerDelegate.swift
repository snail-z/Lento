//
//  DawnTransition+UINavigationControllerDelegate.swift
//  Lento
//
//  Created by zhang on 2022/7/10.
//

import UIKit

extension DawnTransition: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let delegate = navigationController.dawnPrevNavigationDelegate {
            delegate.navigationController?(navigationController, willShow: viewController, animated: animated)
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let delegate = navigationController.dawnPrevNavigationDelegate {
            delegate.navigationController?(navigationController, didShow: viewController, animated: animated)
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard !isTransitioning else { return nil }
        self.state = .starting
        self.isPresenting = operation == .push
        self.fromViewController = fromViewController ?? fromVC
        self.toViewController = toViewController ?? toVC
        self.inNavigationController = true
        return self
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
}

extension DawnExtension where Base: UIViewController {
    
    /// 启用导航转场动画
    public var isNavigationEnabled: Bool {
        get {
            return objc_getAssociatedObject(base, &DawnIsNavEnabledUIViewControllerAssociatedKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(base, &DawnIsNavEnabledUIViewControllerAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 设置导航转场动画类型
    public var navigationAnimationType: DawnAnimationType {
        get {
            return objc_getAssociatedObject(base, &DawnAnimationTypeNavigationControllerAssociatedKey) as? DawnAnimationType ?? .none
        }
        set {
            // swizzling
            Dawn.swizzlePushViewController()
            transitionCapable = newValue.toTransitionDeputy()
            objc_setAssociatedObject(base, &DawnAnimationTypeNavigationControllerAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

fileprivate var DawnIsNavEnabledUIViewControllerAssociatedKey: Void?
fileprivate var DawnAnimationTypeNavigationControllerAssociatedKey: Void?
