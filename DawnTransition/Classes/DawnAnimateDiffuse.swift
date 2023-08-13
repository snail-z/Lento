//
//  DawnAnimateDiffuse.swift
//  DawnTransition
//
//  Created by zhang on 2022/7/25.
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
