//
//  DawnAnimateRoundKnob.swift
//  Lento
//
//  Created by zhang on 2023/7/3.
//

import UIKit

public protocol DawnTransitioningAnimateRoundKnob: NSObjectProtocol {
    
    func dawnAnimatePathwayView() -> UIView?
}

public struct DawnAnimateRoundKnob: DawnCustomTransitionCapable {
    
    public var duration: TimeInterval = 0.275

    public func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool {
        let containerView = context.container
        let fromView = context.fromViewController.view!
        let toView = context.toViewController.view!
//        guard let sourceView = sourceDelegate?.dawnAnimatePathwayView() else { return false }
//        guard let targetView = targetDelegate?.dawnAnimatePathwayView() else { return false }
//        guard let sourceSnapshot = sourceView.dawn.snapshotView() else { return false }
//        guard let targetSnapshot = targetView.dawn.snapshotView() else { return false }
//        targetView.superview?.layoutIfNeeded()
//
//        containerView.addSubview(toView)
//        toView.isHidden = true
//        toView.layoutIfNeeded()
//
//        let sourceFrame = sourceView.superview!.convert(sourceView.frame, to: containerView)
//        let sourceScale = sourceView.width / sourceView.height
//        let targetScale = targetView.width / targetView.height
//
//        let tempView = UIView(frame: sourceFrame)
//        tempView.backgroundColor = .white
//        tempView.clipsToBounds = true
//        tempView.layer.masksToBounds = true
//        tempView.layer.cornerRadius = sourceView.layer.cornerRadius
//        containerView.addSubview(tempView)
//
//        targetSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.width / targetScale)
//        targetSnapshot.center = CGPoint(x: targetSnapshot.center.x, y: tempView.bounds.height/2)
//
//        targetSnapshot.alpha = 0
//        tempView.addSubview(targetSnapshot)
//
//        sourceSnapshot.frame = CGRect(origin: .zero, size: tempView.bounds.size)
//        sourceSnapshot.center = CGPoint(x: sourceSnapshot.center.x, y: tempView.bounds.height/2)
//        sourceSnapshot.alpha = 1
//        tempView.addSubview(sourceSnapshot)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            
        } completion: { finished in
           
            complete(finished)
        }
        return true
    }
    
    public func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool {
        return true
    }
}
