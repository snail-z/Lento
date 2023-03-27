//
//  MAIndexView.swift
//  AmassingUI
//
//  Created by zhanghao on 2022/10/2.
//

import UIKit
import AmassingExtensions
import SnapKit

@objc open class MAIndexView: UIControl {
    
    /// 设置索引标题数组
    @objc public var indexTitles: [String]? {
        didSet {
            setIndexTitles(indexTitles)
        }
    }
    
    /// 设置子视图间距
    @objc public var itemSpacing: CGFloat = 4 {
        didSet {
            stackView.spacing = itemSpacing
        }
    }
    
    /// 设置文本颜色
    @objc public var normalTextColor: UIColor? = .darkGray {
        didSet {
            updateIndexLabels()
        }
    }
    
    /// 设置文本字体
    @objc public var normalFont: UIFont? = .systemFont(ofSize: 10) {
        didSet {
            updateIndexLabels()
        }
    }
    
    /// 当前选中的索引，默认-1未选中
    public private(set) var currentIndex: Int = -1
    
    /// 设置指示器大小，设置为.zero则自适应
    @objc public var indicatorSize: CGSize = CGSize(width: 15, height: 15)
    
    /// 设置指示器自适应文本四周留白
    @objc public var indicatorInsets: UIEdgeInsets = .zero
    
    /// 拖动事件回调
    @objc public weak var dragEvents: MAIndexViewDragEvents?
    
    /// 设置选中索引
    @objc public func setIndex(_ index: Int) {
        changedIndex(index)
    }

    @objc public private(set) var indicatorLabel: UILabel!
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
        layoutInitialization()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(_:))))
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInitialization() {
        stackView = UIStackView()
        stackView.isUserInteractionEnabled = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = itemSpacing
        addSubview(stackView)
        
        indicatorLabel = UILabel()
        indicatorLabel.textAlignment = .center
        indicatorLabel.layer.cornerRadius = 2
        indicatorLabel.layer.masksToBounds = true
        indicatorLabel.backgroundColor = .systemBlue
        indicatorLabel.textColor = .white
        indicatorLabel.font = normalFont
        addSubview(indicatorLabel)
    }
    
    private func layoutInitialization() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setIndexTitles(_ indexTitles: [String]?) {
        guard let _ = indexTitles else { return }
        stackView.subviews.forEach({ $0.removeFromSuperview() })
        for title in indexTitles! {
            let label = UILabel()
            label.text = title
            label.font = normalFont
            label.textColor = normalTextColor
            stackView.addArrangedSubview(label)
        }
        layoutIfNeeded()
    }
    
    private func updateIndexLabels() {
        for element in stackView.subviews {
            let label = element as! UILabel
            label.font = normalFont
            label.textColor = normalTextColor
        }
    }
    
    private func nearestIndex(at point: CGPoint) -> Int {
        let leadPadding = stackView.frame.minY
        let spacing = stackView.spacing / 2
        var index = 0, lastIndex = stackView.subviews.count - 1
        for view in stackView.subviews {
            var top = view.frame.minY
            var bottom = view.frame.maxY
            top -= (index == 0 ? leadPadding : spacing)
            bottom += (index == lastIndex ? leadPadding : spacing)
            guard !(point.y >= top && point.y <= bottom) else { break }
            index += 1
        }
        return index
    }
    
    private func changedIndex(_ index: Int) {
        guard currentIndex != index else { return }
        currentIndex = index
        if index >= 0, index < stackView.subviews.count {
            let label = stackView.subviews[index] as! UILabel
            let p = stackView.convert(label.center, to: self)
            updateIndicator(with: label, position: p)
        } else {
            indicatorLabel.alpha = 0
        }
    }
    
    private func updateIndicator(with label: UILabel, position: CGPoint)  {
        var size = indicatorSize.equalTo(.zero) ? label.bounds.size : indicatorSize
        size.width += indicatorInsets.left + indicatorInsets.right
        size.height += indicatorInsets.top + indicatorInsets.bottom
        indicatorLabel.size = size
        indicatorLabel.center = position
        indicatorLabel.text = label.text
        indicatorLabel.alpha = 1
    }

    @objc private func tap(_ g: UITapGestureRecognizer) {
        let location = g.location(in: stackView)
        let index = nearestIndex(at: location)
        guard currentIndex != index else { return }
        currentIndex = index
        let label = stackView.subviews[index] as! UILabel
        let p = stackView.convert(label.center, to: self)
        updateIndicator(with: label, position: p)
        sendActions(for: .valueChanged)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    @objc private func pan(_ g: UIPanGestureRecognizer) {
        switch g.state {
        case .began:
            let location = g.location(in: stackView)
            let index = nearestIndex(at: location)
            guard index < stackView.subviews.count else { return }
            currentIndex = index
            let label = stackView.subviews[index] as! UILabel
            let p = stackView.convert(label.center, to: self)
            updateIndicator(with: label, position: p)
            sendActions(for: .valueChanged)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            dragEvents?.indexView?(self, willBeginDragging: p, index: index)
        case .changed:
            let location = g.location(in: stackView)
            let index = nearestIndex(at: location)
            guard index < stackView.subviews.count else { return }
            guard currentIndex != index else { return }
            currentIndex = index
            let label = stackView.subviews[index] as! UILabel
            let p = stackView.convert(label.center, to: self)
            updateIndicator(with: label, position: p)
            sendActions(for: .valueChanged)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            dragEvents?.indexView?(self, didDragging: p, index: index)
        default:
            guard currentIndex < stackView.subviews.count else { return }
            dragEvents?.indexView?(self, didEndDraggingAtIndex: currentIndex)
        }
    }
}

/// 拖动事件
@objc public protocol MAIndexViewDragEvents {
    
    /// 将要开始拖动
    @objc optional func indexView(_ indexView: MAIndexView, willBeginDragging position: CGPoint, index: Int)
    /// 正在拖动中
    @objc optional func indexView(_ indexView: MAIndexView, didDragging position: CGPoint, index: Int)
    /// 已经结束拖动
    @objc optional func indexView(_ indexView: MAIndexView, didEndDraggingAtIndex: Int)
}
