//
//  DawnAnimationConfiguration.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/26.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2022 snail-z <haozhang0770@163.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public struct DawnAnimationConfiguration {
 
    /// 动画延迟
    public var delay: TimeInterval = 0
    
    /// 动画时长
    public var duration: TimeInterval = 0.295
    
    /// 动画曲线，默认慢快慢
    public var curve: DawnAnimationCurve = .easeInOut
    
    /// 使用自定义阻尼弹性动画
    public var spring: (damping: CGFloat, velocity: CGFloat)?
    
    /// 截图类型
    public var snapshotType: DawnSnapshotType = .normal
    
    /// 转场容器背景色
    public var containerBackgroundColor: UIColor = .black
    
    /// 是否将toView推到最后面
    public var sendToViewToBack: Bool = false
}

public enum DawnAnimationCurve {
    
    case linear
    case easeIn
    case easeOut
    case easeInOut
}

extension DawnAnimationCurve {
    
    internal func usable() -> UIView.AnimationOptions {
        switch self {
        case .linear: return .curveLinear
        case .easeIn: return .curveEaseIn
        case .easeOut: return .curveEaseOut
        case .easeInOut: return .curveEaseInOut
        }
    }
}

public enum DawnSnapshotType {
    
    /// 正常快照视图动画
    case normal
    
    /// 不创建快照，直接视图做动画(会打乱视图层次结构，视图控制器必须重建「慎用」)
    case noSnapshot//todo
}
