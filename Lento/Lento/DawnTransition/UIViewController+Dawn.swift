//
//  UIViewController+Dawn.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/9.
//

import UIKit

extension UIViewController: DawnCompatible {}
extension DawnExtension where Base: UIViewController {
 
    public var isTransitioningEnabled: Bool {
        get {
            return base.transitioningDelegate is DawnTransition
        }
        set {
            guard newValue != isTransitioningEnabled else { return }
            if newValue {
                base.transitioningDelegate = Dawn.shared
            } else {
                base.transitioningDelegate = nil
            }
        }
    }
    
    public var modalAnimationType: DawnAnimationType {
        get {
            if let value = objc_getAssociatedObject(base, &DawnModalAnimationTypeViewControllerAssociatedKey) as? DawnAnimationType {
                return value
            }
            return .none
        }
        set {
            transitionCapable = newValue.toTransitionDeputy()
            objc_setAssociatedObject(base, &DawnModalAnimationTypeViewControllerAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var transitionCapable: DawnCustomTransitionCapable? {
        get {
            return objc_getAssociatedObject(base, &DawnTransitionCapableViewControllerAssociatedKey) as? DawnCustomTransitionCapable
        }
        set {
            objc_setAssociatedObject(base, &DawnTransitionCapableViewControllerAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension DawnExtension where Base: UIViewController {
    
    public func findViewController<T>(_ cls: T.Type) -> T? {
        if let viewController = base as? T {
            return viewController
        } else if let viewController = base as? UITabBarController {
            return viewController.selectedViewController?.dawn.findViewController(cls)
        } else if let viewController = base as? UINavigationController {
            return viewController.topViewController?.dawn.findViewController(cls)
        }
        return nil
    }
}

extension DawnExtension where Base: UIViewController {
    
    internal var interactiveDriver: UIPercentDrivenInteractiveTransition {
        get {
            if let driver = objc_getAssociatedObject(base, &DawnInteractiveDriverViewControllerAssociatedKey) as? UIPercentDrivenInteractiveTransition {
                return driver
            }
            let driver = UIPercentDrivenInteractiveTransition()
            self.interactiveDriver = driver
            return driver
        }
        set {
            objc_setAssociatedObject(base, &DawnInteractiveDriverViewControllerAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func nilInteractiveDriver() {
        if let _ = objc_getAssociatedObject(base, &DawnInteractiveDriverViewControllerAssociatedKey) as? UIPercentDrivenInteractiveTransition {
            objc_setAssociatedObject(base, &DawnInteractiveDriverViewControllerAssociatedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

fileprivate var DawnInteractiveDriverViewControllerAssociatedKey: Void?
fileprivate var DawnTransitionCapableViewControllerAssociatedKey: Void?
fileprivate var DawnModalAnimationTypeViewControllerAssociatedKey: Void?
