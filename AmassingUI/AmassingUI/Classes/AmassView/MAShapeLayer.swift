//
//  MAShapeLayer.swift
//  AmassingUI
//
//  Created by zhang on 2022/10/4.
//

import UIKit

/**
*  1. 默认去除CALayer的隐式动画
*  2. 切换path时可通过动画转换显示
*/
@objc open class MAShapeLayer: CAShapeLayer {
    
    /// 是否禁止隐式动画，默认true
    @objc public var disableActions: Bool = true
    
    /// 设置路径变化动画
    @discardableResult
    @objc public func pathActions(duration: TimeInterval, closure: ((_ basicAnim: CABasicAnimation) -> Void)? = nil) -> String? {
        guard let oldValue = oldPath, let toValue = path else {
            return nil
        }
        guard duration > .zero else {
            return nil
        }
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = oldValue
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        closure?(animation)
        let animKey = "kMAPathAnimation"
        add(animation, forKey: animKey)
        return animKey
    }
    
    private var oldPath: CGPath?
    
    @objc open override var path: CGPath? {
        didSet {
            oldPath = oldValue
        }
    }
    
    open override func action(forKey event: String) -> CAAction? {
        guard disableActions else {
            return super.action(forKey: event)
        }
        return nil
    }
}
