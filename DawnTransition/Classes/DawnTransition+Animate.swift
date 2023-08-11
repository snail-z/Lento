//
//  DawnTransition+Animate.swift
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
    
    internal func start() {
        guard state == .starting else { return }
        state = .animating
        // DispatchQueue.main.async {
        //    self.animate()
        // }
        // BUG inNavigationController.
        // Hero solution: https://github.com/HeroTransitions/Hero/blob/develop/Sources/Transition/HeroTransition%2BStart.swift
        // When animating within navigationController, we have to dispatch later into the main queue.
        // otherwise snapshots will be pure white. Possibly a bug with UIKit
        // It solves the snapshots issue, But this solution leads to inaccurate gesture response.
        animate()
    }
    
    // swiftlint:disable function_body_length cyclomatic_complexity
    internal func animate() {
        guard let fromVC = fromViewController, let toVC = toViewController else {
            complete(finished: false)
            return
        }
        
        if isPresenting {
            let ctx = (containerView!, fromVC, toVC)
            let sign = toVC.dawn.transitionCapable?.dawnTransitionPresenting(context: ctx, complete: { [weak self] finished in
                self?.complete(finished: finished)
            })
            let tempCapable: DawnCustomTransitionCapable?
            switch sign {
            case .customizing: return
            case .using(let type):
                tempCapable = type.toTransitionDeputy()
            default:
                tempCapable = toVC.dawn.transitionCapable
            }
            guard let capable = tempCapable else { return }
            let config = (drivenConfiguration != nil) ? drivenConfiguration! : capable.dawnAnimationConfigurationPresenting()
            let stage = capable.dawnModifierStagePresenting()
            let fromModifiers = preprocessFromModifiers(stage)
            let toModifiers = preprocessToModifiers(stage, config)
            Dawn.animate(duration: config.duration,
                         delay: config.delay,
                         options: config.curve.usable(),
                         usingSpring: config.spring) {
                fromModifiers?.didChange()
                toModifiers?.didChange()
            } completion: { finished in
                let _ = fromModifiers?.endChange()
                let _ = toModifiers?.endChange()
                self.complete(finished: finished)
            }
        } else { // dismissing
            let ctx = (containerView!, fromVC, toVC)
            let sign = fromVC.dawn.transitionCapable?.dawnTransitionDismissing(context: ctx) { [weak self] finished in
                self?.complete(finished: finished)
            }
            let tempCapable: DawnCustomTransitionCapable?
            switch sign {
            case .customizing: return
            case .using(let type):
                tempCapable = type.toTransitionDeputy()
            default:
                tempCapable = fromVC.dawn.transitionCapable
            }
            guard let capable = tempCapable else { return }
            let config = (drivenConfiguration != nil) ? drivenConfiguration! : capable.dawnAnimationConfigurationDismissing()
            let stage = capable.dawnModifierStageDismissing()
            let fromModifiers = preprocessFromModifiers(stage)
            let toModifiers = preprocessToModifiers(stage, config)
            Dawn.animate(duration: config.duration,
                         delay: config.delay,
                         options: config.curve.usable(),
                         usingSpring: config.spring) {
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
        guard let snoptView = fromView.dawn.snapshotView(inNavigationController) else { return nil }
        snoptView.frame = containerView.bounds
        containerView.addSubview(snoptView)
        
        if let begin = stage.fromViewBeginModifiers {
            snoptView.dawn.render(DawnTargetState.final(begin))
        }
        
        let didChange: AnimatedBlock = {
            if let end = stage.fromViewEndModifiers {
                snoptView.dawn.render(DawnTargetState.final(end))
            }
        }
        
        fromView.isHidden = true
        let endChange: FinishedBlock = {
            fromView.isHidden = false
            snoptView.dawn.nilOverlay()
            snoptView.removeFromSuperview()
            return true
        }
        return (didChange, endChange)
    }

    func preprocessToModifiers(_ stage: DawnModifierStage, _ config: DawnAnimationConfiguration) -> Changed? {
        guard let toView = toViewController?.view, let containerView = containerView else { return nil }
        containerView.backgroundColor = config.containerBackgroundColor
        guard let snoptView = toView.dawn.snapshotView(inNavigationController) else { return nil }
        snoptView.frame = containerView.bounds
        containerView.addSubview(snoptView)
        if config.sendToViewToBack {
            containerView.sendSubviewToBack(snoptView)
        } else {
            containerView.bringSubviewToFront(snoptView)
        }
        
        if let begin = stage.toViewBeginModifiers {
            snoptView.dawn.render(DawnTargetState.final(begin))
        }
        
        let didChange: AnimatedBlock = {
            if let end = stage.toViewEndModifiers {
                snoptView.dawn.render(DawnTargetState.final(end))
            }
        }
        
        let endChange: FinishedBlock = {
            snoptView.dawn.nilOverlay()
            snoptView.removeFromSuperview()
            return true
        }
        return (didChange, endChange)
    }
}

internal extension Dawn {
    
    static func animate(duration: TimeInterval,
                        delay: TimeInterval,
                        options: UIView.AnimationOptions,
                        usingSpring: (damping: CGFloat, velocity: CGFloat)?,
                        animations: @escaping () -> Void,
                        completion: ((Bool) -> Void)?) {
        if let spring = usingSpring {
            UIView.animate(withDuration: duration,
                           delay: delay,
                           usingSpringWithDamping: spring.damping,
                           initialSpringVelocity: spring.velocity,
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
