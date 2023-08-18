//
//  DawnAnimationConfiguration.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/26.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
//

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
