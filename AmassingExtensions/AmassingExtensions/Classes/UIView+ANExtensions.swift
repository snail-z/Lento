//
//  UIView+ANExtensions.swift
//  AnswerExtensions
//
//  Created by zhang on 2020/2/26.
//  Copyright © 2020 snail-z. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

public extension UIView {
    
    /// 设置视图禁用交互时长
    func disableInteraction(duration: TimeInterval) {
        guard self.isUserInteractionEnabled else { return }
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isUserInteractionEnabled = true
        }
    }
    
    /// 删除视图的所有子视图
    func removeAllSubviews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    /// 返回视图所在的控制器
    func respondedViewController() -> UIViewController? {
        weak var dependResponder: UIResponder? = self
        while dependResponder != nil {
            dependResponder = dependResponder!.next
            if let viewController = dependResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /// 返回对当前View的截图
    func screenshots() -> UIImage? {
        return self.layer.screenshots()
    }
    
    /// 为视图添加阴影效果
    ///
    ///     let aView = UIView()
    ///     aView.pk.addShadow(radius: 5, opacity: 0.7, offset: .zero, color: .red)
    ///
    /// - Parameters:
    ///   - radius: 阴影半径
    ///   - opacity: 阴影透明度，取值范围0至1
    ///   - offset: 阴影偏移量，默认CGSize.zero
    ///
    ///            - offset设置为.zero时，可以为四周添加阴影效果
    ///            - offset中的width为正数时，阴影向右偏移，为负数时，向左偏移
    ///            - offset中的height为正数时，阴影向下偏移，为负数时，向上偏移
    ///
    ///   - color: 阴影颜色，默认灰色
    func addShadow(radius: CGFloat, opacity: Float, offset: CGSize = .zero, color: UIColor? = .gray) {
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color?.cgColor
    }
    
    /// 为视图指定位置添加圆角 (通过视图mask属性设置)
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 添加圆角的位置，默认四周
    func addCorner(radius: CGFloat, byRoundingCorners corners: UIRectCorner = .allCorners) {
//        let makeClosure: (_ : UIView) -> Void = { sender in
//            sender.pk._setCorner(radius: radius, byRoundingCorners: corners)
//        }
//        makeClosure(base)
//        base.pk_addViewObserver("frame", makeClosure, identify: "corner")
//        base.pk_addViewObserver("bounds", makeClosure, identify: "corner")
    }
    
    /// 为视图指定位置添加边框线
    /// - Parameters:
    ///   - width: 边框线宽度
    ///   - color: 边框线颜色
    ///   - edges: 添加边框线的位置，默认四周
    func addBorderLayer(width: CGFloat, color: UIColor? = .gray, byRectEdge edges: UIRectEdge = .left) {
//        let makeClosure: (_ : UIView) -> Void = { sender in
//            sender.pk._setBorder(width: width, color: color, byRectEdge: edges)
//        }
//        makeClosure(base)
//        base.pk_addViewObserver("frame", makeClosure, identify: "border")
//        base.pk_addViewObserver("bounds", makeClosure, identify: "border")
    }
    
    /// 删除视图边框线 (对应-addBorderLayer:方法)
    func removeBorderLayer() {
//        base.pk_borderLayer?.removeFromSuperlayer()
//        base.pk_borderLayer = nil
    }
}

public extension UIView {
    
    /// 提示窗是否显示中
    var isAlerting: Bool {
        return self.pk_alertVisible
    }

    /// 显示提示文本框
    /// - Parameters:
    ///   - text: 提示文本
    ///   - delay: 显示时长
    ///   - offset: 位置偏移
    func showAlert(text: String?, delay: TimeInterval = 1.5, offset: CGFloat = -15) {
        guard !isAlerting else { return }
        guard let message = text else { return }
        
        let hud = UIView()
        hud.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        hud.clipsToBounds = true
        hud.layer.cornerRadius = 2
        self.addSubview(hud)
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.preferredMaxLayoutWidth = 220
        hud.addSubview(label)
        
        label.pk.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        hud.pk.makeConstraints { (make) in
            let insets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            make.left.equalTo(label).offset(-insets.left)
            make.right.equalTo(label).offset(insets.right)
            make.top.equalTo(label).offset(-insets.top)
            make.bottom.equalTo(label).offset(insets.bottom)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(offset)
        }
        
        hud.alpha = 0
        UIView.animate(withDuration: 0.25) {
            hud.alpha = 1
        }
        
        self.pk_alertVisible = true
        DispatchQueue.asyncAfter(delay: delay) {
            UIView.animate(withDuration: 0.25, animations: {
                hud.alpha = 0
            }) { (_) in
                hud.removeFromSuperview()
                self.pk_alertVisible = false
            }
        }
    }
}

public extension PKViewExtensions where Base: UIView {
    
    /// 指示器是否加载中
    var isLoading: Bool {
        return (base.pk_loadingViewSet != nil)
    }
    
    /// 开启指示器加载效果
    func beginLoading(text: String? = nil, tintColor: UIColor = .gray, offset: CGFloat = 0) {
        guard base.pk_loadingViewSet == nil else { return }
        base.pk_loadingViewSet = Set()
        
        let indicatorView: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            indicatorView = UIActivityIndicatorView(style: .medium)
        } else {
            indicatorView = UIActivityIndicatorView(style: .gray)
        }
        indicatorView.hidesWhenStopped = false
        indicatorView.color = tintColor
        indicatorView.startAnimating()
        base.addSubview(indicatorView)
        base.pk_loadingViewSet?.insert(indicatorView)
        
        if let message = text {
            let textLabel = UILabel()
            textLabel.numberOfLines = 0
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 12)
            textLabel.textColor = tintColor
            textLabel.text = message
            base.addSubview(textLabel)
            base.pk_loadingViewSet?.insert(textLabel)
            
            let gapView = UIView()
            base.addSubview(gapView)
            base.pk_loadingViewSet?.insert(gapView)
            
            gapView.pk.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(offset)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(8)
            }
            
            indicatorView.pk.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(gapView.pk.top)
            }
            
            textLabel.pk.makeConstraints { (make) in
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.top.equalTo(gapView.pk.bottom)
            }
        } else {
            indicatorView.pk.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(offset)
            }
        }
    }
    
    /// 结束指示器加载效果
    func endLoading() {
        guard base.pk_loadingViewSet != nil else { return }
        base.pk_loadingViewSet?.forEach({ $0.removeFromSuperview() })
        base.pk_loadingViewSet?.removeAll()
        base.pk_loadingViewSet = nil
    }
}

public extension UIView {
    
    /// 为视图添加轻按手势
    @discardableResult
    func addTapGesture(numberOfTaps: Int = 1, action: @escaping (UITapGestureRecognizer) -> Void) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer.action.gestureClosure { (g) in
            action(g)
        }
        tap.numberOfTapsRequired = numberOfTaps
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        return tap
    }
    
    /// 为视图添加双击手势 (参数-other：当响应双击手势时，使other手势不会被响应)
    @discardableResult
    func addDoubleTapGesture(lapsed other: UIGestureRecognizer? = nil, action: @escaping (UITapGestureRecognizer) -> Void) -> UITapGestureRecognizer {
        let doubleTap = UITapGestureRecognizer.action.gestureClosure { (g) in
            action(g)
        }
        doubleTap.numberOfTapsRequired = 2
        if let g = other { g.require(toFail: doubleTap) }
        self.addGestureRecognizer(doubleTap)
        self.isUserInteractionEnabled = true
        return doubleTap
    }
    
    /// 为视图添加长按手势
    @discardableResult
    func addLongPressGesture(action: @escaping (UILongPressGestureRecognizer) -> Void) -> UILongPressGestureRecognizer {
        let longPress = UILongPressGestureRecognizer.action.gestureClosure { (g) in
            action(g)
        }
        self.addGestureRecognizer(longPress)
        self.isUserInteractionEnabled = true
        return longPress
    }
    
    /// 为视图添加拖动手势
    @discardableResult
    func addPanGesture(action: @escaping (UIPanGestureRecognizer) -> Void) -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer.action.gestureClosure { (g) in
            action(g)
        }
        self.addGestureRecognizer(pan)
        self.isUserInteractionEnabled = true
        return pan
    }
    
    /// 为视图添加捏合手势
    @discardableResult
    func addPinchGesture(action: @escaping (UIPinchGestureRecognizer) -> Void) -> UIPinchGestureRecognizer {
        let pinch = UIPinchGestureRecognizer.action.gestureClosure { (g) in
            action(g)
        }
        self.addGestureRecognizer(pinch)
        self.isUserInteractionEnabled = true
        return pinch
    }
    
    /// 为视图添加滑动手势
    @discardableResult
    func addSwipeGesture(numberOfTouches: Int = 1, direction: UISwipeGestureRecognizer.Direction, action: @escaping (UISwipeGestureRecognizer) -> Void) -> UISwipeGestureRecognizer {
        let swipe = UISwipeGestureRecognizer.action.gestureClosure { (g) in
            action(g)
        }
        swipe.numberOfTouchesRequired = numberOfTouches
        swipe.direction = direction
        self.addGestureRecognizer(swipe)
        self.isUserInteractionEnabled = true
        return swipe
    }
}

private var UIViewAssociatedPKMakeBorderLineKey: Void?
private var UIViewAssociatedPKMakeGradientKey: Void?
private var UIViewAssociatedPKAlertVisibleKey: Void?
private var UIViewAssociatedPKLoadingViewsKey: Void?

private extension UIView {
    var pk_borderLayer: CAShapeLayer? {
        get {
            return objc_getAssociatedObject(self, &UIViewAssociatedPKMakeBorderLineKey) as? CAShapeLayer
        } set {
            objc_setAssociatedObject(self, &UIViewAssociatedPKMakeBorderLineKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var pk_gradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &UIViewAssociatedPKMakeGradientKey) as? CAGradientLayer
        } set {
            objc_setAssociatedObject(self, &UIViewAssociatedPKMakeGradientKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var pk_alertVisible: Bool {
        get {
            return objc_getAssociatedObject(self, &UIViewAssociatedPKAlertVisibleKey) as? Bool ?? false
        } set {
            objc_setAssociatedObject(self, &UIViewAssociatedPKAlertVisibleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var pk_loadingViewSet: Set<UIView>? {
        get {
            return objc_getAssociatedObject(self, &UIViewAssociatedPKLoadingViewsKey) as? Set
        } set {
            objc_setAssociatedObject(self, &UIViewAssociatedPKLoadingViewsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private extension UIView {
    
    func pk_removeViewObserver(identify: String) {
        guard let superView = self.superview else { return }
        superView.pk_KVOWrappers.removeObject(forKey: identify)
    }
    
    func pk_addViewObserver(_ keyPath: String, _ handler: @escaping (_ sender: UIView) -> Void, identify: String) {
        pk_addViewObserver(keyPath: keyPath, handler: { (object, _) in
            handler(object as! UIView)
        }, identify: identify)
    }
    
    private func pk_addViewObserver(keyPath: String,
                                    handler: @escaping (_ sender: NSObject, _ change: [NSKeyValueChangeKey : Any]?) -> Void,
                                    identify: String) {
        if let superView = self.superview {
            let anyObj = superView.pk_KVOWrappers.value(forKey: identify)
            if let wrapper = anyObj as? _PKObserverWrapper {
                let newWrapper = _PKObserverWrapper(wrapper: wrapper, ketPath: keyPath, handler: handler)
                superView.pk_KVOWrappers.setValue(newWrapper, forKey: identify)
            } else {
                let wrapper = _PKObserverWrapper(target: self, keyPath: keyPath, handler: handler)
                superView.pk_KVOWrappers.setValue(wrapper, forKey: identify)
            }
        } else {
            let wrapper = _PKObserverWrapper(target: self, keyPath: keyPath, handler: handler)
            DispatchQueue.main.async {
                guard let superView = self.superview else {
                    fatalError("Could not find the superview! \(self)")
                }
                
                let anyObj = superView.pk_KVOWrappers.value(forKey: identify)
                if let wrapper = anyObj as? _PKObserverWrapper {
                    let newWrapper = _PKObserverWrapper(wrapper: wrapper, ketPath: keyPath, handler: handler)
                    superView.pk_KVOWrappers.setValue(newWrapper, forKey: identify)
                } else {
                    superView.pk_KVOWrappers.setValue(wrapper, forKey: identify)
                }
            }
        }
    }
    
    private var pk_KVOWrappers: NSMutableDictionary { // [identifyKey: _PKObserverWrapper]
        let wrappers: NSMutableDictionary
        if let existing = objc_getAssociatedObject(self, &UIViewAssociatedKVODictionaryKey) as? NSMutableDictionary {
            wrappers = existing
        } else {
            wrappers = NSMutableDictionary()
            objc_setAssociatedObject(self, &UIViewAssociatedKVODictionaryKey, wrappers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return wrappers
    }
}

private var UIViewAssociatedKVOSetKey: Void?
private var UIViewAssociatedKVODictionaryKey: Void?

private extension UIView {
 
    private func _setCorner(radius: CGFloat, byRoundingCorners corners: UIRectCorner = .allCorners) {
        guard self.bounds.size.isValid else { return }
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

public extension UIView {
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: top, width: width, height: height)
        }
    }

    var right: CGFloat {
        get {
            return left + width
        } set(value) {
            left = value - width
        }
    }

    var top: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: left, y: value, width: width, height: height)
        }
    }

    var bottom: CGFloat {
        get {
            return top + height
        } set(value) {
            top = value - height
        }
    }

    var width: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: left, y: top, width: value, height: height)
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: left, y: top, width: width, height: value)
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }

    var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }
}

#endif
