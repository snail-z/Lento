//
//  DawnTransition+Interactive.swift
//  Lento
//
//  Created by zhang on 2023/6/9.
//

import UIKit

extension DawnTransition {
    
    func driven(_ inViewController: UIViewController) {
        Dawn.shared.interactiveDriven = inViewController.dawn.interactiveDriver
    }
    
    public func update(_ percentageComplete: CGFloat) {
        percentDriven?.update(percentageComplete)
        print("====x====== update")
    }
    
    public func finish(animate: Bool = true) {
        percentDriven?.finish()
        Dawn.shared.interactiveDriven = nil
        print("====x====== finish")
    }

    public func cancel(animate: Bool = true) {
        percentDriven?.cancel()
        Dawn.shared.interactiveDriven = nil
        print("====x====== cancel")
    }
}

extension DawnTransition {
    
    var percentDriven: UIPercentDrivenInteractiveTransition? {
        return interactiveDriven as? UIPercentDrivenInteractiveTransition
    }
}
