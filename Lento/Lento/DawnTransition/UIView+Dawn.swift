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
        let snapshot = base.snapshotView(afterScreenUpdates: true)
//        if #available(iOS 11.0, *), let oldSnapshot = snapshot {
//            // 在iOS 11中，snapshotView(afterScreenUpdates)快照不会包含容器视图
//            return DawnSnapshotView(contentView: oldSnapshot)
//        } else {
            return snapshot
//        }
    }
}

internal var UIViewAssociatedDawnOverlayKey: Void?
internal var UIViewAssociatedDawnEffectViewKey: Void?

internal extension UIView {
    
    var dawnOverlay: UIView {
        get {
            if let overlay = objc_getAssociatedObject(self, &UIViewAssociatedDawnOverlayKey) as? UIView {
                return overlay
            }
            let overlay = UIView(frame: bounds)
            addSubview(overlay)
            self.dawnOverlay = overlay
            return overlay
        }
        set { objc_setAssociatedObject(self, &UIViewAssociatedDawnOverlayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var dawnEffectView: UIVisualEffectView {
        get {
            if let overlay = objc_getAssociatedObject(self, &UIViewAssociatedDawnEffectViewKey) as? UIVisualEffectView {
                return overlay
            }
            let effectView = UIVisualEffectView(frame: bounds)
            addSubview(effectView)
            self.dawnEffectView = effectView
            return effectView
        }
        set { objc_setAssociatedObject(self, &UIViewAssociatedDawnEffectViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func dawnOverlayNil() {
        if let overlay = objc_getAssociatedObject(self, &UIViewAssociatedDawnOverlayKey) as? UIView {
            overlay.removeFromSuperview()
            objc_setAssociatedObject(self, &UIViewAssociatedDawnOverlayKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        if let effectView = objc_getAssociatedObject(self, &UIViewAssociatedDawnEffectViewKey) as? UIVisualEffectView {
            effectView.removeFromSuperview()
            objc_setAssociatedObject(self, &UIViewAssociatedDawnEffectViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func dawnRender(_ targetState: DawnTargetState) {
        if let backgroundColor = targetState.backgroundColor {
            layer.backgroundColor = backgroundColor
        }
        if let size = targetState.size {
            layer.bounds.size = size
        }
        if let type = targetState.position, let bounds = superview?.bounds {
            let fbounds = CGSize(width: bounds.width / 2, height: bounds.height / 2)
            switch type {
            case .up:
                layer.position = CGPoint(x: layer.position.x, y:  .zero - fbounds.height)
            case .down:
                layer.position = CGPoint(x: layer.position.x, y:  bounds.height + fbounds.height)
            case .left:
                layer.position = CGPoint(x: .zero - fbounds.width, y: layer.position.y)
            case .right:
                layer.position = CGPoint(x: bounds.width + fbounds.width, y: layer.position.y)
            case .center:
                layer.position = CGPoint(x: fbounds.width, y: fbounds.height)
            case .any(let x, let y):
                layer.position = CGPoint(x: x, y: y)
            }
        }
        if let opacity = targetState.opacity {
            layer.opacity = opacity
        }
        if let cornerRadius = targetState.cornerRadius {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
        if let borderWidth = targetState.borderWidth {
            layer.borderWidth = borderWidth.native
        }
        if let borderColor = targetState.borderColor {
            layer.borderColor = borderColor
        }
        if let transform = targetState.transform {
            layer.transform = transform
        }
        if let shadowColor = targetState.shadowColor {
            layer.shadowColor = shadowColor
        }
        if let shadowRadius = targetState.shadowRadius {
            layer.shadowRadius = shadowRadius
        }
        if let shadowOpacity = targetState.shadowOpacity {
            layer.shadowOpacity = shadowOpacity
        }
        if let shadowOffset = targetState.shadowOffset {
            layer.shadowOffset = shadowOffset
        }
        if let overlay = targetState.overlay {
            self.dawnOverlay.backgroundColor = overlay.color
            self.dawnOverlay.alpha = overlay.opacity
        }
        if let overlay = targetState.blurOverlay {
            guard let style = UIBlurEffect.Style(rawValue: overlay.effect.rawValue) else { return }
            self.dawnEffectView.effect = UIBlurEffect(style: style)
            self.dawnEffectView.alpha = overlay.opacity
        }
    }
}
