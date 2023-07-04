//
//  UIView+Dawn.swift
//  Lento
//
//  Created by zhang on 2023/6/9.
//

import UIKit

internal class DawnSnapshotView: UIView {
    
    let contentView: UIView
    init(contentView: UIView) {
        self.contentView = contentView
        super.init(frame: contentView.frame)
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.bounds.size = bounds.size
        contentView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
}

extension UIView: DawnCompatible {}
internal extension DawnExtension where Base: UIView {
    
    func slowSnapshotView() -> UIView {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, 0)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return UIView()
        }
        base.layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: image)
        imageView.frame = base.bounds
        return DawnSnapshotView(contentView: imageView)
    }
    
    func snapshotView() -> UIView? {
        return base.snapshotView(afterScreenUpdates: true)
    }
}

internal var UIViewAssociatedDawnOverlayKey: Void?
internal var UIViewAssociatedDawnEffectViewKey: Void?

internal extension DawnExtension where Base: UIView {
    
    var overlay: UIView {
        get {
            if let aView = objc_getAssociatedObject(base, &UIViewAssociatedDawnOverlayKey) as? UIView {
                return aView
            }
            let overlay = UIView(frame: base.bounds)
            base.addSubview(overlay)
            self.overlay = overlay
            return overlay
        }
        set { objc_setAssociatedObject(base, &UIViewAssociatedDawnOverlayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var effectView: UIVisualEffectView {
        get {
            if let aView = objc_getAssociatedObject(base, &UIViewAssociatedDawnEffectViewKey) as? UIVisualEffectView {
                return aView
            }
            let effectView = UIVisualEffectView(frame: base.bounds)
            base.addSubview(effectView)
            self.effectView = effectView
            return effectView
        }
        set { objc_setAssociatedObject(base, &UIViewAssociatedDawnEffectViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func nilOverlay() {
        if let overlay = objc_getAssociatedObject(base, &UIViewAssociatedDawnOverlayKey) as? UIView {
            overlay.removeFromSuperview()
            objc_setAssociatedObject(base, &UIViewAssociatedDawnOverlayKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        if let effectView = objc_getAssociatedObject(base, &UIViewAssociatedDawnEffectViewKey) as? UIVisualEffectView {
            effectView.removeFromSuperview()
            objc_setAssociatedObject(base, &UIViewAssociatedDawnEffectViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func render(_ targetState: DawnTargetState) {
        if let backgroundColor = targetState.backgroundColor {
            base.layer.backgroundColor = backgroundColor
        }
        if let size = targetState.size {
            base.layer.bounds.size = size
        }
        if let type = targetState.position, let bounds = base.superview?.bounds {
            let fbs = CGSize(width: bounds.width / 2, height: bounds.height / 2)
            switch type {
            case .up:
                base.layer.position = CGPoint(x: base.layer.position.x, y:  .zero - fbs.height)
            case .down:
                base.layer.position = CGPoint(x: base.layer.position.x, y:  bounds.height + fbs.height)
            case .left:
                base.layer.position = CGPoint(x: .zero - fbs.width, y: base.layer.position.y)
            case .right:
                base.layer.position = CGPoint(x: bounds.width + fbs.width, y: base.layer.position.y)
            case .center:
                base.layer.position = CGPoint(x: fbs.width, y: fbs.height)
            case .any(let x, let y):
                base.layer.position = CGPoint(x: x, y: y)
            }
        }
        if let opacity = targetState.opacity {
            base.layer.opacity = opacity
        }
        if let cornerRadius = targetState.cornerRadius {
            base.layer.cornerRadius = cornerRadius
            base.layer.masksToBounds = true
        }
        if let borderWidth = targetState.borderWidth {
            base.layer.borderWidth = borderWidth.native
        }
        if let borderColor = targetState.borderColor {
            base.layer.borderColor = borderColor
        }
        if let transform = targetState.transform {
            base.layer.transform = transform
        }
        if let shadowColor = targetState.shadowColor {
            base.layer.shadowColor = shadowColor
        }
        if let shadowRadius = targetState.shadowRadius {
            base.layer.shadowRadius = shadowRadius
        }
        if let shadowOpacity = targetState.shadowOpacity {
            base.layer.shadowOpacity = shadowOpacity
        }
        if let shadowOffset = targetState.shadowOffset {
            base.layer.shadowOffset = shadowOffset
        }
        if let normalOverlay = targetState.overlay {
            overlay.backgroundColor = normalOverlay.color
            overlay.alpha = normalOverlay.opacity
        }
        if let blurOverlay = targetState.blurOverlay {
            guard let style = UIBlurEffect.Style(rawValue: blurOverlay.effect.rawValue) else { return }
            effectView.effect = UIBlurEffect(style: style)
            effectView.alpha = blurOverlay.opacity
        }
    }
}
