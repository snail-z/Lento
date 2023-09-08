//
//  DawnAnimationSpot.swift
//  DawnTransition
//
//  Created by zhang on 2022/7/25.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
//

import UIKit

open class DawnAnimationSpot: NSObject, DawnAnimationCapable {
    
    /// 动画时长
    public var duration: TimeInterval = 0.325
    
    /// 动画类型
    public var animationType: DawnAnimationType = .push(direction: .left)
    
    public private(set) var holeView: UIView?
    
    public init(holeView: UIView?) {
        self.holeView = holeView
    }
    
    public func dawnAnimationPresentingAnimationType() -> DawnAnimationType {
        return animationType
    }
    
    public func dawnAnimationDismissing(_ dawn: DawnTransition) {
        let containerView = dawn.containerView!
        let fromView = dawn.fromViewController!.view!
        let toView = dawn.toViewController!.view!

        guard let holeView = holeView else { return }
        guard let sourceSnapshot = fromView.dawn.snapshotView() else { return }
        guard let targetSnapshot = toView.dawn.snapshotView() else { return }
        targetSnapshot.frame = containerView.bounds
        containerView.addSubview(targetSnapshot)

        let tempView = UIView(frame: containerView.bounds)
        tempView.backgroundColor = .yellow
        tempView.layer.masksToBounds = true
        tempView.clipsToBounds = true
        tempView.layer.cornerRadius = fromView.layer.cornerRadius
        tempView.layer.masksToBounds = true
        containerView.addSubview(tempView)

        sourceSnapshot.frame = containerView.bounds
        tempView.addSubview(sourceSnapshot)

        let roundView = UIView()
        roundView.frame = tempView.bounds
        roundView.backgroundColor = fromView.backgroundColor
        roundView.alpha = 0
        tempView.addSubview(roundView)

        fromView.isHidden = true
        tempView.layer.cornerRadius = 10
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            let holeFrame = holeView.superview!.convert(holeView.frame, to: containerView)
            tempView.frame = holeFrame
            sourceSnapshot.frame = tempView.bounds
            tempView.layer.cornerRadius = holeFrame.height / 2
        } completion: { finished in
            UIView.animate(withDuration: 0.2) {
                if !dawn.isTransitionCancelled {
                    tempView.alpha = 0
                }
            } completion: { _ in
                targetSnapshot.removeFromSuperview()
                tempView.removeFromSuperview()
                fromView.isHidden = false
                toView.isHidden = false
                dawn.complete(finished: finished)
            }
        }
        UIView.animate(withDuration: duration - 0.15, delay: 0.15, options: .curveEaseOut) {
            roundView.alpha = 1
        }
    }
}
