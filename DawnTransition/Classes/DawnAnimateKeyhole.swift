//
//  DawnAnimateKeyhole.swift
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

public class DawnAnimateKeyhole: NSObject, DawnCustomTransitionCapable {
    
    /// 动画时长
    public var duration: TimeInterval = 0.325
    
    /// 动画类型
    public var animType: DawnAnimationType = .push(direction: .left)
    
    public private(set) var holeView: UIView?
    
    public init(holeView: UIView?) {
        self.holeView = holeView
    }

    public func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign {
        return .using(animType)
    }
    
    public func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign {
        let containerView = context.container
        let fromView = context.fromViewController.view!
        let toView = context.toViewController.view!
        
        guard let holeView = holeView else { return .none }
        guard let sourceSnapshot = fromView.dawn.snapshotView() else { return .none }
        guard let targetSnapshot = toView.dawn.snapshotView() else { return .none }
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
                if !Dawn.shared.isTransitionCancelled {
                    tempView.alpha = 0
                }
            } completion: { _ in
                targetSnapshot.removeFromSuperview()
                tempView.removeFromSuperview()
                fromView.isHidden = false
                toView.isHidden = false
                complete(finished)
            }
        }
        UIView.animate(withDuration: duration - 0.15, delay: 0.15, options: .curveEaseOut) {
            roundView.alpha = 1
        }
        return .customizing
    }
}
