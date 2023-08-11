//
//  DawnTransition+UIViewControllerTransitioningDelegate.swift
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

extension DawnTransition: UIViewControllerTransitioningDelegate {
 
    internal var interactiveTransitioning: UIViewControllerInteractiveTransitioning? {
        return driveninViewController?.dawn.interactiveDriver
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard !isTransitioning else { return nil }
        self.state = .starting
        self.isPresenting = true
        self.fromViewController = fromViewController ?? presenting
        self.toViewController = toViewController ?? presented
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard !isTransitioning else { return nil }
        self.state = .starting
        self.isPresenting = false
        self.fromViewController = fromViewController ?? dismissed
        return self
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransitioning
    }
}

extension DawnTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.375
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        fromViewController = fromViewController ?? transitionContext.viewController(forKey: .from)
        toViewController = toViewController ?? transitionContext.viewController(forKey: .to)
        containerView = transitionContext.containerView
        start()
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        self.state = .possible
    }
}

extension DawnTransition: UIViewControllerInteractiveTransitioning {
    
    public var wantsInteractiveStart: Bool {
        return true
    }
    
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        animateTransition(using: transitionContext)
    }
}
