//
//  DawnAnimateDiffuse.swift
//  DawnTransition
//
//  Created by zhang on 2022/7/25.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
//

import UIKit

/// DawnAnimateDiffuse暂不支持手势响应
/// 目前仅 UIView.animate(withDuratio...) 方式处理的动画支持手势响应，
/// 使用 CAAnimation/CAAnimationGroup 动画组暂不支持手势，需要结合CADisplayLink更新每一帧进度，待完善...
public class DawnAnimateDiffuse: NSObject, DawnCustomTransitionCapable {

    /// 动画时长
    public var duration: TimeInterval = 0.375
    
    /// 透明度动画时长占比，默认25%
    public var fadeDurationProportion: Double = 0.25
    
    public private(set) var diffuseOutView: UIView?
    public private(set) var diffuseInView: UIView?
    
    public init(diffuseOut: UIView?, diffuseIn: UIView?) {
        diffuseOutView = diffuseOut
        diffuseInView = diffuseIn
    }

    public func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign {
        let containerView = context.container
        let toView = context.toViewController.view!
        guard let tempView = toView.dawn.snapshotView() else { return .none }
        guard let sourceView = diffuseOutView else { return .none }
        tempView.frame = containerView.bounds
        containerView.addSubview(tempView)
        
        let center = CGPoint(x: containerView.bounds.width / 2, y: containerView.bounds.height / 2)
        let raduius = sqrt(pow(center.x, 2) + pow(center.y, 2))
        let sourceFrame = sourceView.superview!.convert(sourceView.frame, to: containerView)
        let startPath = UIBezierPath(ovalIn: sourceFrame)
        let endPath = UIBezierPath(arcCenter: containerView.center, radius: raduius, startAngle: .zero, endAngle: CGFloat.pi*2, clockwise: true)

        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        tempView.layer.mask = maskLayer

        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.fromValue = startPath.cgPath
        pathAnim.toValue = endPath.cgPath
        pathAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 0
        opacityAnim.toValue = 1
        opacityAnim.beginTime = 0
        opacityAnim.duration = duration * fadeDurationProportion
        opacityAnim.timingFunction = CAMediaTimingFunction(name: .linear)

        Dawn.runningAnimations([pathAnim, opacityAnim], in: maskLayer, duration: duration) { flag in
            tempView.removeFromSuperview()
            complete(flag)
        }
        return .customizing
    }
    
    public func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign {
        let containerView = context.container
        let fromView = context.fromViewController.view!
        let toView = context.toViewController.view!
    
        guard let tempView = fromView.dawn.snapshotView() else { return .none }
        guard let inView = diffuseInView else { return .none }
        toView.frame = containerView.bounds
        containerView.addSubview(toView)
        tempView.frame = containerView.bounds
        containerView.addSubview(tempView)
        
        let center = CGPoint(x: containerView.bounds.width / 2, y: containerView.bounds.height / 2)
        let raduius = sqrt(pow(center.x, 2) + pow(center.y, 2))
        let sourceFrame = inView.superview!.convert(inView.frame, to: containerView)
        let startPath = UIBezierPath(arcCenter: containerView.center, radius: raduius, startAngle: .zero, endAngle: CGFloat.pi*2, clockwise: true)
        let endPath = UIBezierPath(ovalIn: sourceFrame)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        tempView.layer.mask = maskLayer

        let pathAnim = CABasicAnimation(keyPath: "path")
        pathAnim.fromValue = startPath.cgPath
        pathAnim.toValue = endPath.cgPath
        pathAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1
        opacityAnim.toValue = 0
        opacityAnim.beginTime = duration - duration * fadeDurationProportion
        opacityAnim.duration = duration * fadeDurationProportion
        opacityAnim.timingFunction = CAMediaTimingFunction(name: .linear)
        
        Dawn.runningAnimations([pathAnim, opacityAnim], in: maskLayer, duration: duration) { flag in
            tempView.removeFromSuperview()
            complete(flag)
        }
        return .customizing
    }
}
