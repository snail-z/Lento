//
//  UIView+ANOverrides.swift
//  AnswerExtensions
//
//  Created by zhang on 2020/2/26.
//  Copyright © 2020 snail-z. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

// MARK: - ANTextField

/**
*  提供以下功能：
*  1. 支持调整左视图边缘留白 (leftViewPadding)
*  2. 支持调整右视图边缘留白 (rightViewPadding)
*  3. 支持调整清除按钮边缘留白 (clearButtonPadding)
*  4. 支持输入框文本边缘留白 (textEdgeInsets)
*  5. 增加键盘删除按钮的响应事件 - ANTextField.deleteBackward
*/
@objc open class ANTextField: UITextField {
    
    /// 左视图边缘留白
    @objc public var leftViewPadding: CGFloat = 0
    
    /// 右视图边缘留白
    @objc public var rightViewPadding: CGFloat = 0
    
    /// 清除按钮边缘留白
    @objc public var clearButtonPadding: CGFloat = 0
    
    /// 文本边缘留白
    @objc public var textEdgeInsets: UIEdgeInsets = .zero
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var leftRect = super.leftViewRect(forBounds: bounds)
        leftRect.origin.x += leftViewPadding
        return leftRect
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightRect = super.rightViewRect(forBounds: bounds)
        rightRect.origin.x -= rightViewPadding
        return rightRect
    }
    
    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var clearRect = super.clearButtonRect(forBounds: bounds)
        clearRect.origin.x = bounds.size.width - clearRect.size.width - clearButtonPadding
        return clearRect
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return takeInputRect(forBounds: bounds, modes: [.always])
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return takeInputRect(forBounds: bounds, modes: [.always, .whileEditing])
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard isEditing else {
            return textRect(forBounds: bounds)
        }
        return editingRect(forBounds: bounds)
    }
    
    private func takeInputRect(forBounds bounds: CGRect, modes: [ViewMode]) -> CGRect {
        var insets = textEdgeInsets
        
        if let _ = leftView, modes.contains(leftViewMode) {
            insets.left += leftViewRect(forBounds: bounds).maxX
        }
        
        if let _ = rightView, modes.contains(rightViewMode) {
            insets.right += (bounds.width - rightViewRect(forBounds: bounds).minX)
        } else {
            if modes.contains(clearButtonMode) {
                insets.right += (bounds.width - clearButtonRect(forBounds: bounds).minX)
            }
        }
        
        return bounds.inset(by: insets)
    }

    open override func deleteBackward() {
        super.deleteBackward()
        sendActions(for: ANTextField.deleteBackward)
    }
    
    /// 键盘删除按钮的响应事件
    ///
    ///     Usage: textField.addTarget(self, action: #selector(textFieldDeleteBackward(_:)), for: ANTextField.deleteBackward)
    @objc public static var deleteBackward: UIControl.Event {
        return UIControl.Event(rawValue: 2020)
    }
}


// MARK: - ANTextView

/**
*  提供以下功能：
*  1. 支持设置占位文本 (placeholder)
*  2. 支持设置占位文本颜色 (placeholderColor)
*  3. 支持设置占位文本内边距 (placeholderInsets)
*  4. 支持设置文本框是否需要自适应内容高度 (adjustsToFitContentHeightAutomatically)
*  5. 输入框 contentSize 改变回调 - didContentSizeChanged(oldSize, newSize)
*  6. 输入框变化增加删除事件 - deleteBackward
*/
@objc open class ANTextView: UITextView, UITextViewDelegate {
    
    /// 设置占位文本
    @objc public var placeholder: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 设置占位文本颜色
    @objc public var placeholderColor: UIColor? = .gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 调整占位文本内边距
    @objc public var placeholderInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 8) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 是否自适应内容高度，默认false (需要固定水平约束)
    @objc public var adjustsToFitContentHeightAutomatically = false

    /// 内容自适应限制的最大行数，默认0无限制
    @objc public var maxOfLinesToAutomaticallyLimit: NSInteger = 0 {
        didSet {
            guard oldValue != maxOfLinesToAutomaticallyLimit else {
                return
            }
            let oldSize = bounds.size
            invalidateIntrinsicContentSize()
            didContentSizeChanged?(oldSize, getIntrinsicContentSize())
        }
    }
    
    /// 输入框 contentSize 改变回调
    @objc public var didContentSizeChanged: ((_ oldSize: CGSize, _ newSize: CGSize) -> Void)? = nil
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        layoutManager.allowsNonContiguousLayout = false
        bindNotifications()
    }
    
    public required init?(coder: NSCoder) { super.init(coder: coder) }
    
    public override func draw(_ rect: CGRect) {
        guard !hasText else { return }
        guard let textValue = placeholder else { return }
        let fontValue = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let colorValue = placeholderColor ?? UIColor.gray
        let attributedText = NSMutableAttributedString(string: textValue)
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(.font, value: fontValue, range: range)
        attributedText.addAttribute(.foregroundColor, value: colorValue, range: range)
        let rect = CGRect(x: placeholderInset.left + 8, // 优化占位文本偏移问题
                          y: placeholderInset.top,
                          width: bounds.width - placeholderInset.left - placeholderInset.right,
                          height: bounds.height - placeholderInset.top - placeholderInset.bottom)
        attributedText.draw(in: rect)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    public override var font: UIFont? {
        get {
            return super.font
        } set {
            super.font = newValue
            setNeedsDisplay()
        }
    }
    
    public override var attributedText: NSAttributedString! {
        get {
            return super.attributedText
        } set {
            setNeedsDisplay()
        }
    }
    
    public override var text: String! {
        get {
            return super.text
        } set {
            setNeedsDisplay()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return getIntrinsicContentSize()
    }
    
    private func heightForNumberOfLines(_ lines: NSInteger) -> CGFloat {
        return ceil((font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)).lineHeight * CGFloat(lines) + textContainerInset.top + textContainerInset.bottom)
    }
    
    private func getIntrinsicContentSize() -> CGSize {
        var size = self.contentSize
        size.height = max(heightForNumberOfLines(1), size.height)
        if maxOfLinesToAutomaticallyLimit > 0 {
            size.height = min(heightForNumberOfLines(maxOfLinesToAutomaticallyLimit), size.height)
        }
        return size;
    }
    
    private func bindNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        addObserver(self, forKeyPath: "contentSize", options: [.old, .new], context: nil)
    }
    
    private func unbindNotifications() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        removeObserver(self, forKeyPath: "contentSize")
    }
    
    @objc private func textDidChange(_ notif: Notification) {
        setNeedsDisplay()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            guard adjustsToFitContentHeightAutomatically else { return }
            if let oldSize = change?[.oldKey] as? CGSize,
               let newSize = change?[.newKey] as? CGSize,
                !oldSize.equalTo(newSize), newSize.width > 0, newSize.height > 0 {
                invalidateIntrinsicContentSize()
                didContentSizeChanged?(oldSize, getIntrinsicContentSize())
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        unbindNotifications()
    }
    
    public override func deleteBackward() {
        super.deleteBackward()
        delegate?.textViewDidChange?(self)
    }
}

// MARK: - ANLabel

/// 提供调整UILabel文本内边距功能
@objc open class ANLabel: UILabel {
    
    /// 设置文本内边距
    @objc public var contentEdgeInsets: UIEdgeInsets = .zero
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentEdgeInsets))
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard contentEdgeInsets != .zero else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }
        let insets = contentEdgeInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}

#endif
