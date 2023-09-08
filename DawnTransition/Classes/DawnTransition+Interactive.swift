//
//  DawnTransition+Interactive.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/9.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
//

import UIKit

extension DawnTransition {
    
    public func driven(presenting viewController: UIViewController) {
        drivenChanged = false
        driven(viewController, presenting: true)
    }
    
    public func driven(dismissing viewController: UIViewController) {
        drivenChanged = false
        driven(viewController, presenting: false)
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
    
    internal func driven(_ viewController: UIViewController, presenting: Bool) {
        driveninViewController = viewController
        if let producer = viewController.dawn.transitionCapable as? DawnAnimationProducer {
            /// 手势拖动时使用.linear动画，保持与手指同步的效果
            drivenAdjustable = presenting ?
            producer.presentingAdjustable.regenerate() : producer.dismissingAdjustable.regenerate()
        }
    }
    
    internal func drivenComplete() {
        drivenAdjustable = nil
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

extension DawnTransitionAdjustable {
    
    fileprivate func regenerate() -> DawnTransitionAdjustable {
        return DawnTransitionAdjustable(
            delay: self.delay,
            duration: self.duration,
            curve: .linear,
            spring: self.spring,
            snapshotType: self.snapshotType,
            containerBackgroundColor: self.containerBackgroundColor,
            subviewsHierarchy: self.subviewsHierarchy
        )
    }
}
