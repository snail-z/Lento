//
//  UIViewController+Dawn.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/9.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2022 snail-z <haozhang0770@163.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
        }
    }
    
    /// 设置模态转场动画类型
    public var modalAnimationType: DawnAnimationType {
        get {
            if let value = objc_getAssociatedObject(base, &DawnModalAnimationTypeViewControllerAssociatedKey) as? DawnAnimationType {
                return value
            }
            return .none
        }
        set {
            base.modalPresentationStyle = .fullScreen
            transitionCapable = newValue.toTransitionDeputy()
            objc_setAssociatedObject(base, &DawnModalAnimationTypeViewControllerAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
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
fileprivate var DawnModalAnimationTypeViewControllerAssociatedKey: Void?
