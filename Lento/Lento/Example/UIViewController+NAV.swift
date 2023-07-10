//
//  UIViewController+NAV.swift
//  Lento
//
//  Created by zhang on 2023/7/10.
//

import UIKit

extension DawnExtension where Base: UIViewController {
    
    public var isNavTransitioningEnabled: Bool {
        get {
            return false
        }
        set {
            guard newValue != isTransitioningEnabled else { return }
            if newValue {
                base.transitioningDelegate = Dawn.shared
                if let navi = base as? UINavigationController {
                    base.previousNavigationDelegate = navi.delegate
                    //                    base.previousNavigationDelegate = navi.delegate
                    navi.delegate = Dawn.shared
                }
            } else {
                base.transitioningDelegate = nil
                if let navi = base as? UINavigationController, navi.delegate is DawnTransition {
                    navi.delegate = base.previousNavigationDelegate
                }
            }
        }
    }
}

fileprivate var DawnPreviousNavigationDelegateAssociatedKey: Void?

public extension UIViewController {
    
    public var previousNavigationDelegate: UINavigationControllerDelegate? {
        get {
            return objc_getAssociatedObject(self, &DawnPreviousNavigationDelegateAssociatedKey) as? UINavigationControllerDelegate
        }
        set {
            objc_setAssociatedObject(self, &DawnPreviousNavigationDelegateAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
