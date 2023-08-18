//
//  UIView+DawnPanGestureRecognizer.swift
//  DawnTransition
//
//  Created by zhang on 2022/7/5.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
//

import UIKit

extension DawnExtension where Base: UIView {

    /// 添加转场驱动手势
    public func addPanGestureRecognizer(_ gestureRecognizer: DawnPanGestureRecognizer) {
        removePanGestureRecognizer(gestureRecognizer)
        gestureRecognizer.bindPanRecognizer(base)
        panGestures?.append(gestureRecognizer)
    }
    
    /// 删除转场驱动手势
    public func removePanGestureRecognizer(_ gestureRecognizer: DawnPanGestureRecognizer) {
        guard let _ = panGestures else { return }
        let gr = panGestures!.first(where: { $0 == gestureRecognizer })
        gr?.unbindPanRecognizer(base)
        panGestures!.removeAll(where: { $0 == gestureRecognizer })
        guard panGestures!.isEmpty else { return }
        panGestures = nil
    }
    
    /// 删除全部驱动手势
    public func removeAllPanGestureRecognizers() {
        guard let _ = panGestures else { return }
        for gr in panGestures! {
            gr.unbindPanRecognizer(base)
        }
        panGestures?.removeAll()
        panGestures = nil
    }
}

fileprivate var UIViewAssociatedDawnPanGestureRecognizerKey: Void?
extension DawnExtension where Base: UIView {
    
    fileprivate var panGestures: [DawnPanGestureRecognizer]? {
        get {
            if let value = objc_getAssociatedObject(base, &UIViewAssociatedDawnPanGestureRecognizerKey) as? [DawnPanGestureRecognizer] {
                return value
            }
            let values = [DawnPanGestureRecognizer]()
            self.panGestures = values
            return values
        }
        set {
            objc_setAssociatedObject(base, &UIViewAssociatedDawnPanGestureRecognizerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public class DawnPanGestureRecognizer: NSObject {
    
    /// 默认true只在屏幕边缘识别手势，若设为false则全屏幕识别
    public var isRecognizeWhenEdges: Bool = true

    public enum Direction {
        case leftToRight, rightToLeft, topToBottom, bottomToTop
    }
    /// 设置手势从某个方向开始识别
    public var recognizeDirection: Direction = .leftToRight
    
    public enum TransitioningType {
        case present, dismiss
    }
    public internal(set) var transitionType: TransitioningType
    public internal(set) weak var driverViewController: UIViewController!

    internal weak var panView: UIView!
    internal var panGestureRecognizer: UIPanGestureRecognizer?
    internal var startTransition: (() -> Void)?
    
    public init(driver: UIViewController, type: TransitioningType, prepare: (() -> Void)!) {
        self.driverViewController = driver
        self.transitionType = type
        self.startTransition = prepare
    }
}

internal class _DawnPanGestureRecognizer: UIPanGestureRecognizer {}
internal class _DawnEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer {}

extension DawnPanGestureRecognizer {
    
    fileprivate func bindPanRecognizer(_ view: UIView) {
        panView = view
        isRecognizeWhenEdges ? addEdgePanRecognizer(inView: view) : addPanRecognizer(inView: view)
    }
    
    fileprivate func unbindPanRecognizer(_ view: UIView) {
        guard let pan = panGestureRecognizer else { return }
        view.removeGestureRecognizer(pan)
    }
    
    private func addPanRecognizer(inView view: UIView) {
        panGestureRecognizer = _DawnPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureRecognizer!.delegate = self
        view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    private func addEdgePanRecognizer(inView view: UIView) {
        let edgePan = _DawnEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan(_:)))
        edgePan.delegate = self
        edgePan.edges = directionToEdge()
        panGestureRecognizer = edgePan
        view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    private func directionToEdge() -> UIRectEdge {
        switch recognizeDirection {
        case .leftToRight: return .left
        case .rightToLeft: return .right
        case .topToBottom: return .top
        case .bottomToTop: return .bottom
        }
    }
}

extension DawnPanGestureRecognizer {
    
    @objc private func handlePan(_ g: UIPanGestureRecognizer) {
        handle(gesture: g)
    }
    
    @objc private func handleEdgePan(_ g: UIScreenEdgePanGestureRecognizer) {
        handle(gesture: g)
    }
    
    private func handle(gesture g: UIPanGestureRecognizer) {
        switch recognizeDirection {
        case .leftToRight: handleLeft(g)
        case .rightToLeft: handleRight(g)
        case .topToBottom: handleTop(g)
        case .bottomToTop: handleBottom(g)
        }
    }
}

extension DawnPanGestureRecognizer {
    
    @objc internal func prepare() {
        switch transitionType {
        case .present:
            Dawn.shared.driven(presenting: driverViewController)
        case .dismiss:
            Dawn.shared.driven(dismissing: driverViewController)
        }
        startTransition?()
    }
    
    @objc internal func handleLeft(_ g: UIPanGestureRecognizer) {
        let translation = g.translation(in: panView).x
        let distance = translation / panView.bounds.width
        switch g.state {
        case .began:
            prepare()
        case .changed:
            Dawn.shared.update(distance)
        default:
            let velocity = g.velocity(in: panView)
            if ((translation + velocity.x) / panView.bounds.width) > 0.5 {
                Dawn.shared.finish()
            } else {
                Dawn.shared.cancel()
            }
        }
    }
    
    @objc internal func handleRight(_ g: UIPanGestureRecognizer) {
        let translation = abs(g.translation(in: panView).x)
        let distance = abs(translation / panView.bounds.width)
        switch g.state {
        case .began:
            prepare()
        case .changed:
            Dawn.shared.update(distance)
        default:
            let velocity = g.velocity(in: panView)
            if ((translation - velocity.x) / panView.bounds.width) > 0.5 {
                Dawn.shared.finish()
            } else {
                Dawn.shared.cancel()
            }
        }
    }
    
    @objc internal func handleTop(_ g: UIPanGestureRecognizer) {
        let translation = g.translation(in: panView).y
        let distance = translation / panView.bounds.height
        switch g.state {
        case .began:
            prepare()
        case .changed:
            Dawn.shared.update(distance)
        default:
            let velocity = g.velocity(in: panView)
            if ((translation + velocity.y) / panView.bounds.height) > 0.5 {
                Dawn.shared.finish()
            } else {
                Dawn.shared.cancel()
            }
        }
    }
    
    @objc internal func handleBottom(_ g: UIPanGestureRecognizer) {
        let translation = abs(g.translation(in: panView).y)
        let distance = abs(translation / panView.bounds.height)
        switch g.state {
        case .began:
            prepare()
        case .changed:
            Dawn.shared.update(distance)
        default:
            let velocity = g.velocity(in: panView)
            if ((translation - velocity.y) / panView.bounds.height) > 0.5 {
                Dawn.shared.finish()
            } else {
                Dawn.shared.cancel()
            }
        }
    }
}

extension DawnPanGestureRecognizer: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard !isRecognizeWhenEdges else { return true }
        let g = gestureRecognizer as! UIPanGestureRecognizer
        let velocity = g.velocity(in: panView)
        switch recognizeDirection {
        case .leftToRight:
            return (velocity.x > .zero) && (abs(velocity.x) > abs(velocity.y))
        case .rightToLeft:
            return (velocity.x < .zero) && (abs(velocity.x) > abs(velocity.y))
        case .topToBottom:
            return (velocity.y > .zero) && (abs(velocity.y) > abs(velocity.x))
        case .bottomToTop:
            return (velocity.y < .zero) && (abs(velocity.y) > abs(velocity.x))
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
