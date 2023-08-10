//
//  DawnTodayGestureRecognizer.swift
//  DawnTransition
//
//  Created by zhang on 2022/7/6.
//

import UIKit

public class DawnTodayGestureRecognizer: DawnPanGestureRecognizer {

    /// 拖动到达缩放边界是否自动转场
    public var shouldAutoDissmiss = true
    
    /// 拖动缩放到达的最小比例，取值范围(0-1]
    public var zoomScale: CGFloat = 0.8
    
    /// 拖动缩放系数，该值越大缩放越快，取值范围(0-1]
    public var zoomFactor: CGFloat = 0.8
    
    /// 拖动中页面圆角变化最大值
    public var zoomMaxRadius: CGFloat = 20
    
    /// 需要追踪的UIScrollView，用于解决手势冲突
    public weak var trackScrollView: UIScrollView?
}

extension DawnTodayGestureRecognizer {

    private var isScrolling: Bool {
        guard let scrollView = trackScrollView else { return false }
        return scrollView.contentOffset.y > .zero || scrollView.contentOffset.y < .zero
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard isScrolling else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        return false
    }
    
    public override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        switch recognizeDirection {
        case .leftToRight, .rightToLeft: return false
        default: return otherGestureRecognizer == trackScrollView?.panGestureRecognizer
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !isScrolling
    }
}

extension DawnTodayGestureRecognizer {
    
    override func handleLeft(_ g: UIPanGestureRecognizer) {
        let translation = g.translation(in: panView).x
        let distance = translation / panView.bounds.width
        zoom(progress: distance, gesture: g)
    }
    
    override func handleTop(_ g: UIPanGestureRecognizer) {
        let translation = g.translation(in: panView).y
        let distance = translation / panView.bounds.height
        zoom(progress: distance, gesture: g)
    }
}

extension DawnTodayGestureRecognizer {
    
    private func zoom(progress: CGFloat, gesture: UIPanGestureRecognizer) {
        let minScale: CGFloat = zoomScale, maxScale: CGFloat = 1
        let scale = 1 - progress * zoomFactor
        let minRadius: CGFloat = 0, maxRadius: CGFloat = zoomMaxRadius
        var shouldTransition = false
        if scale < minScale {
            self.panView.layer.transform = CATransform3DScale(CATransform3DIdentity, minScale, minScale, 1)
            self.panView.center = CGPoint(x: UIScreen.size.width / 2, y: UIScreen.size.height / 2)
            self.panView.layer.cornerRadius = maxRadius
            self.panView.layer.masksToBounds = true
            if shouldAutoDissmiss {
                self.startTransition?()
                return
            } else {
                shouldTransition = true
            }
        } else {
            self.panView.layer.transform = CATransform3DScale(CATransform3DIdentity, min(maxScale, scale), min(maxScale, scale), 1)
            self.panView.center = CGPoint(x: UIScreen.size.width / 2, y: UIScreen.size.height / 2)
            let cornerRadius = (1 - scale) / (1 - minScale) * maxRadius
            self.panView.layer.cornerRadius = max(minRadius, cornerRadius)
            self.panView.layer.masksToBounds = true
            shouldTransition = false
        }
        
        switch gesture.state {
        case .began, .changed: break
        default:
            let translation = gesture.translation(in: panView).x
            let velocity = gesture.velocity(in: panView)
            if ((translation + velocity.x) / panView.bounds.width) > 0.5 {
                self.startTransition?()
            } else if shouldTransition {
                self.startTransition?()
            } else {
                UIView.animate(withDuration: 0.15) {
                    self.panView.layer.transform = CATransform3DIdentity
                }
            }
        }
    }
}
