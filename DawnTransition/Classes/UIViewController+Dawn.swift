//
//  UIViewController+Dawn.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/9.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
//

import UIKit

extension UIViewController: DawnCompatible {}
extension DawnExtension where Base: UIViewController {
 
    /// 启用模态转场动画
    public var isModalEnabled: Bool {
        get {
            return base.transitioningDelegate is DawnTransition
        }
        set {
            guard newValue != isModalEnabled else { return }
            if newValue {
                base.transitioningDelegate = Dawn.shared
            } else {
                base.transitioningDelegate = nil
            }
            base.modalPresentationStyle = .fullScreen
        }
    }
    
    /// 设置模态转场动画类型
    public var transitionAnimationType: DawnAnimationType {
        get {
            return objc_getAssociatedObject(base, &DawnTransitionAnimationTypeViewControllerAssociatedKey) as? DawnAnimationType ?? .none
        }
        set {
            transitionCapable = newValue.toTransitionUsing()
            objc_setAssociatedObject(base, &DawnTransitionAnimationTypeViewControllerAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 自定义转场动画
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
    
    internal func invalidateInteractiveDriver() {
        if let _ = objc_getAssociatedObject(base, &DawnInteractiveDriverViewControllerAssociatedKey) as? UIPercentDrivenInteractiveTransition {
            objc_setAssociatedObject(base, &DawnInteractiveDriverViewControllerAssociatedKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

fileprivate var DawnInteractiveDriverViewControllerAssociatedKey: Void?
fileprivate var DawnTransitionCapableViewControllerAssociatedKey: Void?
fileprivate var DawnTransitionAnimationTypeViewControllerAssociatedKey: Void?
