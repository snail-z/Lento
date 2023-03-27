//
//  MACollectionView.swift
//  AmassingUI
//
//  Created by zhang on 2022/10/29.
//

import UIKit

@objc open class MACollectionView: UICollectionView {

    /// 触摸点在边缘时(panGestureTriggerBoundary以内)响应屏幕侧滑手势
    @objc public var panGestureTriggerBoundary: CGFloat = 40
}

extension MACollectionView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard panGestureTriggerBoundary > 0 else { return false }
        if contentOffset.x < (.zero - contentInset.left) { return false }
        if contentOffset.x + contentInset.left > 1 { return false }
        if (gestureRecognizer.location(in: self).x + contentInset.left) < panGestureTriggerBoundary {
            let kind1 = gestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
            let kind2 = otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
            return kind1 && kind2
        }
        return false
    }
}
