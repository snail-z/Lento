//
//  DawnTransition.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/9.
//

import UIKit

public enum DawnTransitionState: Int {
  
    // 可以开始新的转场
    case possible

    // DawnTransition的`start`方法已被调用，准备动画
    case starting

    // DawnTransition的`animate`方法已被调用，动画中
    case animating

    // 已调用DawnTransition的`complete` 方法，转场结束或取消正在清理
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
    
    internal var driveninViewController: UIViewController?
    internal var drivenConfiguration: DawnAnimationConfiguration?
    internal var drivenChanged: Bool = false
}
