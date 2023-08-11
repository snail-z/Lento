//
//  DawnTransition.swift
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

public enum DawnTransitionState: Int {
  
    // 可以开始新的转场
    case possible

    // DawnTransition的`start`方法已被调用，准备动画
    case starting

    // DawnTransition的`animate`方法已被调用，动画中
    case animating

    // 已调用DawnTransition的`complete` 方法，转场结束正在清理
    case completing
}

public class Dawn: NSObject {
    
    public static var shared = DawnTransition()
}

public class DawnTransition: NSObject {
    
    public var isTransitioning: Bool { return state != .possible }
    
    public internal(set) var isPresenting: Bool = true
    
    /// 目标视图控制器
    internal var toViewController: UIViewController?
    
    /// 源视图控制器
    internal var fromViewController: UIViewController?

    /// 转场上下文对象
    internal weak var transitionContext: UIViewControllerContextTransitioning?
    
    /// 转场容器对象
    internal var containerView: UIView?
    
    /// 转场对象状态
    internal var state: DawnTransitionState = .possible
    
    internal var inNavigationController = false
    internal var driveninViewController: UIViewController?
    internal var drivenConfiguration: DawnAnimationConfiguration?
    internal var drivenChanged = false
}
