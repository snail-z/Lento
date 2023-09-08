//
//  DawnAnimationProducer.swift
//  DawnTransition
//
//  Created by zhang on 2022/7/25.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
//

import UIKit

open class DawnAnimationProducer {
        
    /// 控制器显示时转场状态描述
    public var presentingModifierStage = DawnModifierStage()
    
    /// 控制器消失时转场状态描述
    public var dismissingModifierStage = DawnModifierStage()

    /// 控制器显示时转场参数配置
    public var presentingAdjustable = DawnTransitionAdjustable(subviewsHierarchy: [.from, .to])
    
    /// 控制器消失时转场参数配置
    public var dismissingAdjustable = DawnTransitionAdjustable(subviewsHierarchy: [.to, .from])
}

extension DawnAnimationProducer {
    
    /// 扩展示例，已实现DawnTransitionCapable，可直接设置动画类型及配置参数
    public static func using(
        type: DawnAnimationType,
        duration: TimeInterval = 0.295,
        curve: DawnAnimationCurve = .easeInOut
    ) ->  DawnAnimationProducer {
        let producer = type.toTransitionProducer()
        producer.presentingAdjustable.duration = duration
        producer.presentingAdjustable.curve = curve
        producer.dismissingAdjustable.duration = duration
        producer.dismissingAdjustable.curve = curve
        return producer
    }
}

extension DawnAnimationProducer: DawnAnimationCapable {
    
    public func dawnAnimationPresenting(_ dawn: DawnTransition) {
        let config = dawn.drivenAdjustable ?? presentingAdjustable
        let fromModifiers = dawn.preprocessFromModifiers(presentingModifierStage, config)
        let toModifiers = dawn.preprocessToModifiers(presentingModifierStage, config)
        Dawn.animate(parameters: config) {
            fromModifiers?.animWork()
            toModifiers?.animWork()
        } completion: { finished in
            fromModifiers?.endedWork()
            toModifiers?.endedWork()
            dawn.complete(finished: finished)
        }
    }
    
    public func dawnAnimationDismissing(_ dawn: DawnTransition) {
        let config = dawn.drivenAdjustable ?? dismissingAdjustable
        let fromModifiers = dawn.preprocessFromModifiers(dismissingModifierStage, config)
        let toModifiers = dawn.preprocessToModifiers(dismissingModifierStage, config)
        Dawn.animate(parameters: config) {
            fromModifiers?.animWork()
            toModifiers?.animWork()
        } completion: { finished in
            fromModifiers?.endedWork()
            toModifiers?.endedWork()
            dawn.complete(finished: finished)
        }
    }
}

fileprivate extension DawnTransition {
    
    typealias AnimatedWork = () -> Void
    typealias FinishedWork = () -> Void
    typealias Work = (animWork: AnimatedWork, endedWork: FinishedWork)

    func preprocessFromModifiers(_ stage: DawnModifierStage, _ config: DawnTransitionAdjustable) -> Work? {
        guard let fromView = fromViewController?.view, let containerView = containerView else { return nil }
        
        let willSnoptView: UIView?
        if config.snapshotType == .slowSnapshot {
            willSnoptView = fromView.dawn.snapshotView(inNavigationController)
        } else {
            willSnoptView = fromViewController?.view
        }
        guard let snoptView = willSnoptView else { return nil }
        snoptView.frame = containerView.bounds
        containerView.addSubview(snoptView)
        
        if let begin = stage.fromViewBeginModifiers {
            snoptView.dawn.render(DawnTargetState.final(begin))
        }
        
        let animWork: AnimatedWork = {
            if let end = stage.fromViewEndModifiers {
                snoptView.dawn.render(DawnTargetState.final(end))
            }
        }
        
        fromView.isHidden = (config.snapshotType == .slowSnapshot)
        let endedWork: FinishedWork = {
            fromView.isHidden = false
            snoptView.dawn.render(.reinstate())
            snoptView.dawn.nilOverlay()
            snoptView.removeFromSuperview()
        }
        return (animWork, endedWork)
    }

    func preprocessToModifiers(_ stage: DawnModifierStage, _ config: DawnTransitionAdjustable) -> Work? {
        guard let toView = toViewController?.view, let containerView = containerView else { return nil }
        
        let willSnoptView: UIView?
        if config.snapshotType == .slowSnapshot {
            willSnoptView = toView.dawn.snapshotView(inNavigationController)
        } else {
            willSnoptView = toViewController?.view
        }
        guard let snoptView = willSnoptView else { return nil }
        snoptView.frame = containerView.bounds
        containerView.addSubview(snoptView)
        containerView.backgroundColor = config.containerBackgroundColor
        
        if let element = config.subviewsHierarchy.first, element == .to {
            containerView.sendSubviewToBack(snoptView)
        } else {
            containerView.bringSubviewToFront(snoptView)
        }
        
        if let begin = stage.toViewBeginModifiers {
            snoptView.dawn.render(DawnTargetState.final(begin))
        }
        
        let animWork: AnimatedWork = {
            if let end = stage.toViewEndModifiers {
                snoptView.dawn.render(DawnTargetState.final(end))
            }
        }
        
        let endedWork: FinishedWork = {
            snoptView.dawn.render(.reinstate())
            snoptView.dawn.nilOverlay()
            snoptView.removeFromSuperview()
        }
        return (animWork, endedWork)
    }
}
