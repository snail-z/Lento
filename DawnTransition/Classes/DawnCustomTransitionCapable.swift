//
//  DawnCustomTransitionCapable.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/9.
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
