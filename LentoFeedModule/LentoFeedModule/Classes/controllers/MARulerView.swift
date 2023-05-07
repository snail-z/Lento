//
//  MARulerView.swift
//  LentoFeedModule
//
//  Created by zhang on 2023/5/6.
//

import UIKit

public class MARulerView: UIView {

    /// 外观样式
    public var style: MARulerStyle = .default
    
    /// 当前刻度尺指示的值
    public private(set) var currentValue: Int = 0
    
    /// 重载数据，当style属性更新后需调用此方法使生效
    public func reloadData() {
        collectionView.reloadData()
    }
    
    /// 手动设置刻度尺指示的值
    public func setCurrentValue(_ value: Int, animated: Bool) {
        DispatchQueue.main.async {
            self.update(value: value, animated: animated)
        }
    }
    
    /// 当前刻度尺指示值 currentValue 改变回调
    public var didValueChangedClosure: ((_ oldValue: Int, _ newValue: Int) -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellWithClass: MARulerCell.self)
        return collectionView
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: .zero, y: .zero, width: floor(bounds.width), height: bounds.height)
        if let value = style.scrollContentInset {
            collectionView.contentInset = value
        } else {
            //注意使用一个floor函数，一个ceil函数，可以保证在bounds.width为奇数时也是准确的
            collectionView.contentInset = UIEdgeInsets(top: 0, left: floor(bounds.width / 2), bottom: 0, right: ceil(bounds.width / 2))
        }
    }
    
    private func update(value: Int, animated: Bool) {
        currentValue = min(style.maxValue, max(style.minValue, value))
        let offsetX = CGFloat(currentValue - style.minValue) * style.spacing / style.accuracy - collectionView.contentInset.left
        collectionView.setContentOffset(CGPoint(x: offsetX, y: .zero), animated: animated)
    }
}

extension MARulerView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let value = CGFloat(style.maxValue - style.minValue) / style.accuracy
        return Int(value / 10)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MARulerCell.self, for: indexPath)
        cell.dateUpdates(style, at: indexPath)
        return cell
    }
}

extension MARulerView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: style.spacing * 10, height: collectionView.bounds.height)
    }
}

extension MARulerView: UICollectionViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let value = (offsetX + scrollView.contentInset.left) / style.spacing * style.accuracy + CGFloat(style.minValue) + 0.5
        let indicatorValue = Int(floor(value))
        guard currentValue != indicatorValue else { return }
        didValueChangedClosure?(currentValue, indicatorValue)
        currentValue = indicatorValue
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let p = CGPoint(x: targetContentOffset.pointee.x, y: targetContentOffset.pointee.y)
        let targetX = round((p.x + scrollView.contentInset.left) / style.spacing) * style.spacing
        targetContentOffset.pointee = CGPoint(x: targetX - scrollView.contentInset.left, y: p.y)
    }
}

fileprivate class MARulerCell: UICollectionViewCell {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
        layoutInitialization()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var layerViews: UIView!
    private var labelViews: UIView!
    
    private func commonInitialization() {
        layerViews = UIView()
        layerViews.backgroundColor = .clear
        contentView.addSubview(layerViews)
        
        labelViews = UIView()
        labelViews.backgroundColor = .clear
        contentView.addSubview(labelViews)
        
        for idx in 0...10 {
            let subLayer = CALayer()
            layerViews.layer.addSublayer(subLayer)
            let label = UILabel()
            label.textAlignment = .center
            label.isUserInteractionEnabled = false
            labelViews.addSubview(label)
        }
    }
    
    private func layoutInitialization() {
        layerViews.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        labelViews.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public func dateUpdates(_ style: MARulerStyle, at indexPath: IndexPath) {
        guard let layers = layerViews.layer.sublayers else { return }
        for (index, subLayer) in layers.enumerated() {
            let label = labelViews.subviews[index] as! UILabel
            let isNeeded = index == 5 || index == 10 || (indexPath.item == 0 && index == 0)
            label.isHidden = !isNeeded
            label.font = style.indicatorFont
            label.textColor = style.indicatorTextColor
            label.backgroundColor = style.indicatorBackgroundColor
            label.text = String(indexPath.item * 10 + index + style.minValue)
            if style.indicatorSize.equalTo(.zero) {
                label.sizeToFit()
            } else {
                label.size = style.indicatorSize
            }
            
            var rect = CGRect.zero
            rect.origin.x = CGFloat(index) * style.spacing
            rect.size.width = style.lineWidth
            let dVaule = style.indicatorBottomPadding + label.bounds.height + style.indicatorTopPadding
            if longMarked(index) {
                rect.origin.y = bounds.height - dVaule - style.longLineDistance
                rect.size.height = style.longLineDistance
            } else {
                rect.origin.y = bounds.height - dVaule - style.shortLineDistance
                rect.size.height = style.shortLineDistance
            }
            subLayer.frame = rect
            subLayer.cornerRadius = rect.width / 2
            subLayer.masksToBounds = true
            subLayer.backgroundColor = style.lineColor.cgColor
            
            label.centerX = subLayer.centerX
            label.centerY = (subLayer.frame.maxY + label.bounds.height / 2) + style.indicatorTopPadding
        }
    }
    
    private func longMarked(_ index: Int) -> Bool {
        return index == 0 || index == 5 || index == 10
    }
}
