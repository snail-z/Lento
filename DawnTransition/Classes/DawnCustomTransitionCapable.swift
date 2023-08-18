//
//  DawnCustomTransitionCapable.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/9.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
//

import UIKit

public enum DawnTransitionCapableSign: Equatable {
    case customizing
    case none // .using(.none)
    case using(_ type: DawnAnimationType)
}

public protocol DawnCustomTransitionCapable {
    
    /// 自定义视图状态
    func dawnModifierStagePresenting() -> DawnModifierStage
    func dawnModifierStageDismissing() -> DawnModifierStage
    
    /// 自定义转场配置
    func dawnAnimationConfigurationPresenting() -> DawnAnimationConfiguration
    func dawnAnimationConfigurationDismissing() -> DawnAnimationConfiguration
    
    /// 实现以下方法并返回.customizing则完全由外部自定义动画
    typealias DawnSign = DawnTransitionCapableSign
    typealias DawnContext = (container: UIView, fromViewController: UIViewController, toViewController: UIViewController)
    func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign
    func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign
}

extension DawnCustomTransitionCapable {
    
    public func dawnModifierStagePresenting() -> DawnModifierStage {
        return .init()
    }
    
    public func dawnModifierStageDismissing() -> DawnModifierStage {
        return .init()
    }
    
    public func dawnAnimationConfigurationPresenting() -> DawnAnimationConfiguration {
        return .init(sendToViewToBack: false)
    }
    
    public func dawnAnimationConfigurationDismissing() -> DawnAnimationConfiguration {
        return .init(sendToViewToBack: false)
    }
    
    public func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign {
        return .none
    }
    
    public func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign {
        return .none
    }
}
