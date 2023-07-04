//
//  DawnTransition+Interactive.swift
//  Lento
//
//  Created by zhang on 2023/6/9.
//

import UIKit

extension DawnTransition {
    
    public func driven(presenting viewController: UIViewController, configuration: DawnAnimationConfiguration? = nil) {
        driven(viewController, configuration: configuration, presenting: true)
    }
    
    public func driven(dismissing viewController: UIViewController, configuration: DawnAnimationConfiguration? = nil) {
        driven(viewController, configuration: configuration, presenting: false)
    }
    
    public func update(_ percentageComplete: CGFloat) {
        percentDriven.update(percentageComplete)
    }
    
    public func finish(animate: Bool = true) {
        percentDriven.completionSpeed =  1 - percentDriven.percentComplete
        percentDriven.finish()
        drivenComplete()
    }

    public func cancel(animate: Bool = true) {
        percentDriven.completionSpeed = percentDriven.percentComplete
        percentDriven.cancel()
        drivenComplete()
    }
}

extension DawnTransition {
    
    fileprivate func driven(_ inViewController: UIViewController, configuration: DawnAnimationConfiguration? = nil, presenting: Bool) {
        if let deputy = inViewController.dawn.transitionCapable as? DawnCustomTransitionDeputy, configuration == nil {
            let sendBack = presenting ?
            deputy.presentingConfiguration.sendToViewToBack :
            deputy.dismissingConfiguration.sendToViewToBack
            Dawn.shared.drivenConfiguration = DawnAnimationConfiguration(curve: .linear, sendToViewToBack: sendBack)
        } else {
            Dawn.shared.drivenConfiguration = configuration
        }
        Dawn.shared.interactiveDriven = inViewController.dawn.interactiveDriver
    }
    
    fileprivate func drivenComplete() {
        Dawn.shared.interactiveDriven = nil
        Dawn.shared.drivenConfiguration = nil
    }
    
    fileprivate var percentDriven: UIPercentDrivenInteractiveTransition {
        return interactiveDriven as! UIPercentDrivenInteractiveTransition
    }
}
