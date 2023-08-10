//
//  DawnAnimateDissolve.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/27.
//

import UIKit

internal extension CGRect {
    
    /// 使用宽高初始化CGRect
    init(w: CGFloat, h: CGFloat) {
        self.init(origin: .zero, size: CGSize(width: w, height: h))
    }
}

internal extension UIScreen {
    
    /// 屏幕尺寸
    static var size: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

public class DawnAnimateDissolve: DawnCustomTransitionCapable {
    
    /// 动画时长
    public var duration: TimeInterval = 0.275
    
    /// 动画弹性效果，默认nil不使用弹性效果
    public var usingSpring: (damping: CGFloat, velocity: CGFloat)?
    
    /// 背景层蒙版层样式
    public enum OverlayType {
        case clear
        case translucent(opacity: CGFloat, color: UIColor)
        case blur(style: UIBlurEffect.Style, color: UIColor)
    }
    public var overlayType: OverlayType = .clear
    
    private let kSnapshotKey = 2606, kOverlayKey = 2607
    public private(set) var pathSourceView: UIView?
    
    init(sourceView: UIView) {
        self.pathSourceView = sourceView
    }
    
    public func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign {
        let containerView = context.container
        let fromView = context.fromViewController.view!
        let toView = context.toViewController.view!
        
        guard let sourceView = pathSourceView else { return .none }
        guard let targetView = context.toViewController.view else { return .none }
        guard let sourceSnapshot = sourceView.dawn.snapshotView() else { return .none }
        guard let targetSnapshot = targetView.dawn.snapshotView() else { return .none }
        
        toView.frame = containerView.bounds
        containerView.addSubview(toView)
        toView.isHidden = true
        toView.layoutIfNeeded()
        
        let sourceFrame = sourceView.superview!.convert(sourceView.frame, to: containerView)
        let sourceScale = sourceView.bounds.width / sourceView.bounds.height
        let targetScale = targetView.bounds.width / targetView.bounds.height
        
        let tempView = UIView(frame: sourceFrame)
        tempView.backgroundColor = .white
        tempView.clipsToBounds = true
        tempView.layer.masksToBounds = true
        tempView.layer.cornerRadius = sourceView.layer.cornerRadius
        containerView.addSubview(tempView)
        
        targetSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.width / targetScale)
        targetSnapshot.alpha = 0
        tempView.addSubview(targetSnapshot)
        
        sourceSnapshot.frame = CGRect(origin: .zero, size: tempView.bounds.size)
        sourceSnapshot.alpha = 1
        tempView.addSubview(sourceSnapshot)
        
        Dawn.animate(duration: duration,
                     delay: 0,
                     options: .curveEaseInOut,
                     usingSpring: usingSpring) {
            tempView.frame = containerView.frame
            tempView.layer.cornerRadius = toView.layer.cornerRadius
            
            sourceSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.width / sourceScale)
            targetSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.width / targetScale)
            targetSnapshot.alpha = 1
            sourceSnapshot.alpha = 0
        } completion: { finished in
            tempView.removeFromSuperview()
            toView.isHidden = false
            fromView.layer.transform = CATransform3DIdentity
            
            /// fix：在截图前将sourceView隐藏，避免出现视觉重叠
            sourceView.isHidden = true
            if let fromSnapshotView = fromView.dawn.snapshotView() {
                sourceView.isHidden = false
                fromSnapshotView.frame = context.container.bounds
                fromSnapshotView.tag = self.kSnapshotKey
                context.container.insertSubview(fromSnapshotView, at: 0)
                switch self.overlayType {
                case .clear: break
                case .translucent(let opacity, let color):
                    let overlayView = UIView(frame: context.container.bounds)
                    overlayView.backgroundColor = color
                    overlayView.alpha = opacity
                    overlayView.tag = self.kOverlayKey
                    context.container.insertSubview(overlayView, aboveSubview: fromSnapshotView)
                case .blur(let style, let color):
                    let effectView = UIVisualEffectView(frame: context.container.bounds)
                    effectView.backgroundColor = color
                    effectView.effect = UIBlurEffect(style: style)
                    effectView.tag = self.kOverlayKey
                    context.container.insertSubview(effectView, aboveSubview: fromSnapshotView)
                }
            }
            complete(finished)
        }
        return .customizing
    }
    
    public func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign {
        let containerView = context.container
        let fromView = context.fromViewController.view!
        let toView = context.toViewController.view!
        
        guard let sourceView = pathSourceView else { return .none }
        guard let targetView = context.fromViewController.view else { return .none }
        guard let sourceSnapshot = sourceView.dawn.snapshotView() else { return .none }
        guard let targetSnapshot = targetView.dawn.snapshotView() else { return .none }
        toView.isHidden = true
        toView.layoutIfNeeded()
        fromView.isHidden = true
        
        let targetFrame = sourceView.superview!.convert(sourceView.frame, to: containerView)
        let sourceScale = sourceView.bounds.width / sourceView.bounds.height
        let targetScale = targetView.bounds.width / targetView.bounds.height
        
        let tempView = UIView(frame: fromView.frame)
        tempView.backgroundColor = .white
        tempView.layer.masksToBounds = true
        tempView.clipsToBounds = true
        tempView.layer.cornerRadius = fromView.layer.cornerRadius
        containerView.addSubview(tempView)
        
        sourceSnapshot.frame = CGRect(w: tempView.bounds.width, h: targetView.bounds.width / sourceScale)
        sourceSnapshot.alpha = 0
        tempView.addSubview(sourceSnapshot)
        
        targetSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.height)
        targetSnapshot.alpha = 1
        tempView.addSubview(targetSnapshot)
        
        let snapsView = containerView.viewWithTag(kSnapshotKey)
        let overlayView = containerView.viewWithTag(kOverlayKey)
        Dawn.animate(duration: duration,
                     delay: 0,
                     options: .curveEaseInOut,
                     usingSpring: usingSpring) {
            tempView.frame = targetFrame
            tempView.layer.cornerRadius = sourceView.layer.cornerRadius
            
            targetSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.width / targetScale)
            sourceSnapshot.frame = tempView.bounds
            
            sourceSnapshot.alpha = 1
            targetSnapshot.alpha = 0
            overlayView?.alpha = 0
        } completion: { finished in
            snapsView?.removeFromSuperview()
            overlayView?.removeFromSuperview()
            tempView.removeFromSuperview()
            toView.isHidden = false
            fromView.isHidden = false
            complete(finished)
        }
        return .customizing
    }
}
