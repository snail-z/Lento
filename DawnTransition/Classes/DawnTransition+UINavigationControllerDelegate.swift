//
//  DawnTransition+UINavigationControllerDelegate.swift
//  DawnTransition
//
//  Created by zhang on 2022/7/10.
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
