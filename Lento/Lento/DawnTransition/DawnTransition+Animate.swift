//
//  DawnTransition+Animate.swift
//  Lento
//
//  Created by zhang on 2023/6/9.
//

import UIKit

extension DawnTransition {
    
    public func animate() {
        guard state == .starting else { return }
        state = .animating
        
        guard let fromVC = fromViewController, let toVC = toViewController else {
            complete(finished: false)
            return
        }
        
        if isPresenting {
            let ctx = (containerView!, fromVC, toVC)
            let boolean = toVC.dawn.transitionCapable?.dawnTransitionPresenting(context: ctx) { [weak self] finished in
                self?.complete(finished: finished)
            }
            guard boolean == false else { return }
            guard let capable = toVC.dawn.transitionCapable else { return }
            let stage = capable.dawnModifierStagePresenting()
            let config = capable.dawnAnimationConfigurationPresenting()
            let fromModifiers = preprocessFromModifiers(stage)
            let toModifiers = preprocessToModifiers(stage, config)
            performAnimate(duration: config.duration,
                           delay: config.delay,
                           options: config.curve.usable(),
                           springStiffness: config.spring) {
                fromModifiers?.didChange()
                toModifiers?.didChange()
            } completion: { finished in
                let _ = fromModifiers?.endChange()
                let _ = toModifiers?.endChange()
                self.complete(finished: finished)
            }
        } else { // dismissing
            let ctx = (containerView!, fromVC, toVC)
            let boolean = fromVC.dawn.transitionCapable?.dawnTransitionDismissing(context: ctx) { [weak self] finished in
                self?.complete(finished: finished)
            }
            guard boolean == false else { return }
            guard let capable = fromVC.dawn.transitionCapable else { return }
            let config = capable.dawnAnimationConfigurationDismissing()
            let stage = capable.dawnModifierStageDismissing()
            let fromModifiers = preprocessFromModifiers(stage)
            let toModifiers = preprocessToModifiers(stage, config)
            performAnimate(duration: config.duration,
                           delay: config.delay,
                           options: config.curve.usable(),
                           springStiffness: config.spring) {
                fromModifiers?.didChange()
                toModifiers?.didChange()
            } completion: { finished in
                let _ = fromModifiers?.endChange()
                let _ = toModifiers?.endChange()
                self.complete(finished: finished)
            }
        }
    }
}

internal extension DawnTransition {
    
    typealias AnimatedBlock = () -> Void
    typealias FinishedBlock = () -> Bool
    typealias Changed = (didChange: AnimatedBlock, endChange: FinishedBlock)
    
    func preprocessFromModifiers(_ stage: DawnModifierStage) -> Changed? {
        guard let fromView = fromViewController?.view, let containerView = containerView else { return nil }
        guard let snoptView = fromView.dawn.snapshotView() else { return nil }
        snoptView.frame = containerView.bounds
        containerView.addSubview(snoptView)
        
        if let begin = stage.fromViewBeginModifiers {
            snoptView.dawnRender(DawnTargetState.final(begin))
        }
        
        let didChange: AnimatedBlock = {
            if let end = stage.fromViewEndModifiers {
                snoptView.dawnRender(DawnTargetState.final(end))
            }
        }
        
        fromView.isHidden = true
        let endChange: FinishedBlock = {
            fromView.isHidden = false
            snoptView.dawnOverlayNil()
            snoptView.removeFromSuperview()
            return true
        }
        return (didChange, endChange)
    }

    func preprocessToModifiers(_ stage: DawnModifierStage, _ config: DawnAnimationConfiguration) -> Changed? {
        guard let toView = toViewController?.view, let containerView = containerView else { return nil }
        containerView.backgroundColor = config.containerBackgroundColor
        guard let snoptView = toView.dawn.snapshotView() else { return nil }
        snoptView.frame = containerView.bounds
        containerView.addSubview(snoptView)
        if config.sendToViewToBack {
            containerView.sendSubviewToBack(snoptView)
        } else {
            containerView.bringSubviewToFront(snoptView)
        }
        
        if let begin = stage.toViewBeginModifiers {
            snoptView.dawnRender(DawnTargetState.final(begin))
        }
        
        let didChange: AnimatedBlock = {
            if let end = stage.toViewEndModifiers {
                snoptView.dawnRender(DawnTargetState.final(end))
            }
        }
        
        let endChange: FinishedBlock = {
            snoptView.dawnOverlayNil()
            snoptView.removeFromSuperview()
            return true
        }
        return (didChange, endChange)
    }
}

internal extension DawnTransition {
    
    func performAnimate(duration: TimeInterval,
                        delay: TimeInterval,
                        options: UIView.AnimationOptions,
                        springStiffness: (damping: CGFloat, velocity: CGFloat)?,
                        animations: @escaping () -> Void,
                        completion: ((Bool) -> Void)?) {
        if let stiffness = springStiffness {
            UIView.animate(withDuration: duration,
                           delay: delay,
                           usingSpringWithDamping: stiffness.damping,
                           initialSpringVelocity: stiffness.velocity,
                           options: options,
                           animations: animations, completion: completion)
        } else {
            UIView.animate(withDuration: duration,
                           delay: delay,
                           options: options,
                           animations: animations, completion: completion)
        }
    }
}
