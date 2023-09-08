//
//  DawnAnimationCapable.swift
//  DawnTransition
//
//  Created by zhang on 2022/7/25.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
//

import UIKit

public protocol DawnAnimationCapable { /// 自定义转场动画协议类

    /// 自定义转场动画，将要显示前
    func dawnAnimationPresenting(_ dawn: DawnTransition)
   
    /// 自定义转场动画，将要消失前
    func dawnAnimationDismissing(_ dawn: DawnTransition)
    
    /// 返回.none时，首选自定义转场`dawnAnimationPresenting`，
    /// 否则将使用现有类型`DawnAnimationType`
    func dawnAnimationPresentingAnimationType() -> DawnAnimationType
    
    /// 返回.none时，首选自定义转场`dawnAnimationDismissing`，
    /// 否则将使用现有类型`DawnAnimationType`
    func dawnAnimationDismissingAnimationType() -> DawnAnimationType
}

extension DawnAnimationCapable {
    
    public func dawnAnimationPresenting(_ dawn: DawnTransition) {
        /// 控制器转场显示动画，自定义实现...
    }
   
    public func dawnAnimationDismissing(_ dawn: DawnTransition) {
        /// 控制器转场消失动画，自定义实现...
    }
    
    public func dawnAnimationPresentingAnimationType() -> DawnAnimationType {
        return .none
    }
 
    public func dawnAnimationDismissingAnimationType() -> DawnAnimationType {
        return .none
    }
}
