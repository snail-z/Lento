//
//  MASearchPagesCell.swift
//  Lento
//
//  Created by zhang on 2022/10/27.
//

import UIKit
import AmassingUI
import LentoBaseKit

@objc protocol MASearchPagesCellDelegate {
    
    @objc optional func pageCell(_ pageCell: MASearchPagesCell, didSelectItemAt indexPath: IndexPath)
}

class MASearchPagesCell: LentoBaseCollectionCell {
    
    public weak var delegate: MASearchPagesCellDelegate?
    
    public var topItems: [MASearchTopListItem]? {
        didSet { dataUpdates() }
    }
    
    private var collectionView: MACollectionView!
    private var selectedIndex: Int = 0
    
    override func commonInitialization() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        layout.itemSize = MASearchConst.topPageSize
        collectionView = MACollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.register(cellWithClass: MASearchPagesListCell.self)
        contentView.addSubview(collectionView)
    }
    
    override func layoutInitialization() {
        collectionView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
    
    private func dataUpdates() {
        collectionView.reloadData()
    }
}

extension MASearchPagesCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MASearchPagesListCell.self, for: indexPath)
        cell.item = topItems?[indexPath.item]
        cell.itemIndex = indexPath.item
        cell.ownerCell = self
        return cell
    }
}

extension MASearchPagesCell: UICollectionViewDelegate {
    
    /// 自定义分页位置 // .decelerationRate = .fast // .isPagingEnabled = false
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let pageWidth = MASearchConst.topPageSize.width
//        let pageSpacing = MASearchConst.tapPageSpacing
//        let x = targetContentOffset.pointee.x
//        let movedX = x - pageWidth * CGFloat(selectedIndex) - pageSpacing * CGFloat(selectedIndex)
//        if movedX < -pageWidth * 0.5 {
//            selectedIndex -= 1
//        } else if movedX > pageWidth * 0.5 {
//            selectedIndex += 1
//        }
//        var endX = pageWidth * CGFloat(selectedIndex)
//        endX += pageSpacing * CGFloat(selectedIndex)
//        endX += scrollView.contentInset.left
//        if abs(velocity.x) >= 2 {
//            targetContentOffset.pointee.x = endX
//        } else {
//            targetContentOffset.pointee.x = scrollView.contentOffset.x
//            scrollView.setContentOffset(CGPoint(x: endX, y: scrollView.contentOffset.y), animated: true)
//        }
//    }
}

class MASearchPagesListCell: LentoBaseCollectionCell {
    
    public weak var ownerCell: MASearchPagesCell?
    public var itemIndex: Int = 0
    
    public var item: MASearchTopListItem? {
        didSet { dataUpdates() }
    }
    
    private var gradientView: MAGradientView!
    private var titleLabel: UILabel!
    private var stackView: UIStackView!
    
    override func commonInitialization() {
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.hex(0xF1F1F1).cgColor
        contentView.layer.borderWidth = 0.5
        
        gradientView = MAGradientView()
        gradientView.gradientDirection = .topToBottom
        contentView.addSubview(gradientView)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = .appFont(16, style: .semiBold)
        titleLabel.textColor = .black
        contentView.addSubview(titleLabel)
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = MASearchPagesCellConst.cellSpacing
        contentView.addSubview(stackView)
        
        buildTopTenViews()
    }
    
    override func layoutInitialization() {
        gradientView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(MASearchPagesCellConst.topPadding)
            make.height.equalTo(MASearchPagesCellConst.titleHeight)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    private func buildTopTenViews() {
        for index in 0..<10 {
            let label = MASearchTopTenLabel()
            label.tag = index
            stackView.addArrangedSubview(label)
            label.addGestureRecognizer(UITapGestureRecognizer.action.gestureClosure({ [weak self] sender in
                guard let `self` = self else { return }
                let indexPath = IndexPath(item: sender.view!.tag, section: self.itemIndex)
                self.ownerCell!.delegate?.pageCell?(self.ownerCell!, didSelectItemAt: indexPath)
            }))
        }
    }
    
    private func dataUpdates() {
        let colors = [UIColor.hex(0xFFEFFE), UIColor.hex(0xEFEFFE), UIColor.hex(0xEFFFFE)]
        let index = item?.style ?? 0
        let color = colors.element(safe: index) ?? colors.first!
        gradientView.gradientClolors = [color.withAlphaComponent(0.25), .white]
        titleLabel.text = item?.title
        guard let values = item?.items else { return }
        for (index, view) in stackView.subviews.enumerated() {
            let label = view as! MASearchTopTenLabel
            let element = values.element(safe: index)
            label.item = element
            label.isHidden = element == nil
        }
    }
}

fileprivate class MASearchTopTenLabel: LentoBaseView {
    
    var item: MASearchTopItem? {
        didSet { dataUpdates() }
    }
    
    var leftLabel: UILabel!
    var textLabel: UILabel!
    var rightLabel: UILabel!
    
    override func commonInitialization() {
        textLabel = UILabel()
        textLabel.textAlignment = .left
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.font = .appFont(14)
        textLabel.textColor = .color333333
        addSubview(textLabel)
        
        leftLabel = UILabel()
        leftLabel.textAlignment = .right
        leftLabel.font = UIFont.fontName(.avenir, style: .blackOblique, size: 14)
        leftLabel.textColor = .black
        addSubview(leftLabel)
        
        rightLabel = UILabel()
        rightLabel.textAlignment = .right
        rightLabel.font = .appFont(8, style: .semiBold)
        addSubview(rightLabel)
    }
    
    override func layoutInitialization() {
        leftLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview().offset(1)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(leftLabel.snp.right).offset(8)
            make.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualTo(rightLabel.snp.left).offset(-5)
            make.height.equalTo(MASearchPagesCellConst.cellHeight)
        }
    }
    
    private func dataUpdates() {
        leftLabel.text = item?.level?.toString()
        textLabel.text = item?.name
        switch item?.trendType {
        case .rise:
            rightLabel.textColor = .red
            rightLabel.text = "↑"
        case .fall:
            rightLabel.text = "↓"
            rightLabel.textColor = .green
        default:
            rightLabel.text = ""
        }
    }
}
