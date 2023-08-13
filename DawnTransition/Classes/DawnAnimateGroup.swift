//
//  DawnAnimateGroup.swift
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

public class DawnAnimationGroup: NSObject {

    public var duration: CFTimeInterval = 0.5
    public var fillMode: CAMediaTimingFillMode = .forwards
    public var timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: .linear)
    public var didStart: ((CAAnimation) -> Void)?
    public var didStop: ((CAAnimation, Bool) -> Void)?
    
    internal weak var weakLayer: CALayer?
    internal lazy var group: CAAnimationGroup = {
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.delegate = self
        return group
    }()
    
    public func setAnimations(_ animations: [CAAnimation]?) {
        guard let values = animations, !values.isEmpty else { return }
        group.animations = values
        group.fillMode = fillMode
        group.duration = duration
        group.timingFunction = timingFunction
    }
    
    internal func bind(key: String?) {
        weakLayer?.add(group, forKey: key)
    }
    
    internal func unbind(key: String?) {
        guard let aKey = key else { return }
        weakLayer?.removeAnimation(forKey: aKey)
    }
}

extension DawnAnimationGroup: CAAnimationDelegate {
    
    public func animationDidStart(_ anim: CAAnimation) {
        didStart?(anim)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        didStop?(anim, flag)
        group.delegate = nil
    }
}

fileprivate var DawnCALayerStorageAnimGroupAssociatedKey: Void?
internal extension DawnExtension where Base: CALayer {
    
    fileprivate var storageAnimGroup: DawnAnimationGroup? {
        get {
            return objc_getAssociatedObject(base, &DawnCALayerStorageAnimGroupAssociatedKey) as? DawnAnimationGroup
        }
        set {
            objc_setAssociatedObject(base, &DawnCALayerStorageAnimGroupAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension CALayer: DawnCompatible {}
extension DawnExtension where Base: CALayer {
    
    public func add(_ group: DawnAnimationGroup, forKey key: String?) {
        group.weakLayer = base
        group.bind(key: key)
        storageAnimGroup = group
    }
    
    public func removeAnimation(forKey key: String) {
        guard let group = storageAnimGroup else { return }
        group.unbind(key: key)
        storageAnimGroup = nil
    }
}

internal extension Dawn {
    
    static func runningAnimations(_ animations: [CAAnimation]?,
                                  in layer: CALayer,
                                  duration: TimeInterval,
                                  completion: ((Bool) -> Void)? = nil) {
        let aKey = "dawn.anim.group.calayer"
        let group = DawnAnimationGroup()
        group.duration = duration
        group.setAnimations(animations)
        group.didStop = { anim, flag in
            layer.dawn.removeAnimation(forKey: aKey)
            completion?(flag)
        }
        layer.dawn.add(group, forKey: aKey)
    }
}
