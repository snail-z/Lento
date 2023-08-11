//
//  DawnTransition+Interactive.swift
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

extension DawnTransition {
    
    public func driven(presenting viewController: UIViewController, configuration: DawnAnimationConfiguration? = nil) {
        drivenChanged = false
        driven(viewController, configuration: configuration, presenting: true)
    }
    
    public func driven(dismissing viewController: UIViewController, configuration: DawnAnimationConfiguration? = nil) {
        drivenChanged = false
        driven(viewController, configuration: configuration, presenting: false)
    }
    
    public func update(_ percentageComplete: CGFloat) {
        drivenChanged = true
        drivable.update(percentageComplete)
    }
    
    public func finish() {
        func work() {
            drivable.completionSpeed =  1 - drivable.percentComplete
            drivable.finish()
            drivenComplete()
        }
        drivenChanged ? work() : sudden(work)
    }

    public func cancel() {
        func work() {
            drivable.completionSpeed = drivable.percentComplete
            drivable.cancel()
            drivenComplete()
        }
        drivenChanged ? work() : sudden(work)
    }
    
    /// fix: 手指快速扫动未调用update(percentage:)动画不执行问题
    internal func sudden(_ work: @escaping () -> Void) {
        drivable.update(0.01)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.025, execute: work)
    }
    
    internal func driven(_ viewController: UIViewController, configuration: DawnAnimationConfiguration? = nil, presenting: Bool) {
        driveninViewController = viewController
        if let deputy = viewController.dawn.transitionCapable as? DawnCustomTransitionDeputy, configuration == nil {
            let sendBack = presenting ?
            deputy.presentingConfiguration.sendToViewToBack :
            deputy.dismissingConfiguration.sendToViewToBack
            drivenConfiguration = DawnAnimationConfiguration(curve: .linear, sendToViewToBack: sendBack)
        } else {
            drivenConfiguration = configuration
        }
    }
    
    internal func drivenComplete() {
        drivenConfiguration = nil
        drivenChanged = false
        driveninViewController?.dawn.invalidateInteractiveDriver()
        driveninViewController = nil
    }
}

extension DawnTransition {
    
    fileprivate var drivable: UIPercentDrivenInteractiveTransition {
        return driveninViewController!.dawn.interactiveDriver
    }
}
