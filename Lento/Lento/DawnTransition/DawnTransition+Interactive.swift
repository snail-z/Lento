//
//  DawnTransition+Interactive.swift
//  Lento
//
//  Created by zhang on 2023/6/9.
//

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
    
    public func finish(animate: Bool = true) {
        func work() {
            drivable.completionSpeed =  1 - drivable.percentComplete
            drivable.finish()
            drivenComplete()
        }
        drivenChanged ? work() : precip(work)
    }

    public func cancel(animate: Bool = true) {
        func work() {
            drivable.completionSpeed = drivable.percentComplete
            drivable.cancel()
            drivenComplete()
        }
        drivenChanged ? work() : precip(work)
    }
    
    /// fix: 手指快速扫动未调用changed状态动画不执行问题
    internal func precip(_ work: @escaping () -> Void) {
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
        driveninViewController?.dawn.nilInteractiveDriver()
        driveninViewController = nil
    }
}

extension DawnTransition {
    
    fileprivate var drivable: UIPercentDrivenInteractiveTransition {
        return driveninViewController!.dawn.interactiveDriver
    }
}
