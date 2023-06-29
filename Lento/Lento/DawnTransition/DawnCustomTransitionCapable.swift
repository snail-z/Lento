//
//  DawnCustomTransitionCapable.swift
//  Lento
//
//  Created by zhang on 2023/6/9.
//

import UIKit

public protocol DawnCustomTransitionCapable {
    
    /// 自定义视图状态
    func dawnModifierStagePresenting() -> DawnModifierStage
    func dawnModifierStageDismissing() -> DawnModifierStage
    
    /// 自定义转场配置
    func dawnAnimationConfigurationPresenting() -> DawnAnimationConfiguration
    func dawnAnimationConfigurationDismissing() -> DawnAnimationConfiguration
    
    /// 实现以下方法并返回true则完全由外部自定义动画
    typealias DawnContext = (container: UIView, fromViewController: UIViewController, toViewController: UIViewController)
    func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool
    func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool
}

extension DawnCustomTransitionCapable {
    
    public func dawnModifierStagePresenting() -> DawnModifierStage {
        return .default()
    }
    
    public func dawnModifierStageDismissing() -> DawnModifierStage {
        return .default()
    }
    
    public func dawnAnimationConfigurationPresenting() -> DawnAnimationConfiguration {
        return DawnAnimationConfiguration(sendToViewToBack: false)
    }
    
    public func dawnAnimationConfigurationDismissing() -> DawnAnimationConfiguration {
        return DawnAnimationConfiguration(sendToViewToBack: false)
    }
}

extension DawnCustomTransitionCapable {
    
    public func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool {
        return false
    }
    
    public func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool {
        return false
    }
}
