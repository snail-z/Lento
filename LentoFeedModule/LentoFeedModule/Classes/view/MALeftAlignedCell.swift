//
//  MALeftAlignedCell.swift
//  Lento
//
//  Created by zhang on 2022/10/21.
//

import UIKit
import AmassingUI
import LentoBaseKit

fileprivate typealias Const = MALeftAlignedConst

class MALeftAlignedBaseCell: LentoBaseCollectionCell {
    
    public var item: MALeftAlignedItem? {
        didSet { dataUpdates() }
    }
    
    public func dataUpdates() {}
}

extension MALeftAlignedBaseCell {
    
    static func registerCells(with collectionView: UICollectionView) {
        collectionView.register(cellWithClass: MALeftAlignedLocationCell.self)
        collectionView.register(cellWithClass: MALeftAlignedHistoriesCell.self)
        collectionView.register(cellWithClass: MALeftAlignedHotCell.self)
        collectionView.register(cellWithClass: MALeftAlignedNormalCell.self)
    }
    
    static func dequeueCell(_ collectionView: UICollectionView, type: MALeftAlignedGroup.GroupType, for indexPath: IndexPath) -> Self {
        let cell: MALeftAlignedBaseCell
        switch type {
        case .location:
            cell = collectionView.dequeueReusableCell(withClass: MALeftAlignedLocationCell.self, for: indexPath)
        case .histories:
            cell = collectionView.dequeueReusableCell(withClass: MALeftAlignedHistoriesCell.self, for: indexPath)
        case .hotList:
            cell = collectionView.dequeueReusableCell(withClass: MALeftAlignedHotCell.self, for: indexPath)
        default:
            cell = collectionView.dequeueReusableCell(withClass: MALeftAlignedNormalCell.self, for: indexPath)
        }
        return cell as! Self
    }
}

class MALeftAlignedLocationCell: MALeftAlignedBaseCell {
    
    private var button: MAButton!
    
    override func commonInitialization() {
        button = MAButton()
        button.imagePlacement = .right
        button.imageAndTitleSpacing = 8
        button.imageFixedSize = CGSize(width: 18, height: 18)
        button.imageView.image = UIImage(named: "loading_02")?.withRenderingMode(.alwaysTemplate)
        button.imageView.tintColor = .appBlue()
        button.imageView.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets.make(left: 15)
        button.titleLabel.font = .appFont(14)
        button.titleLabel.textColor = .color333333
        contentView.addSubview(button)
    }
    
    override func layoutInitialization() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func dataUpdates() {
        button.titleLabel.text = "重新定位"
    }
}

class MALeftAlignedNormalCell: MALeftAlignedBaseCell {
    
    private var textLabel: UILabel!
    private var line: UIView!
    
    override func commonInitialization() {
        textLabel = UILabel()
        textLabel.textAlignment = .left
        textLabel.font = Const.itemTextFont
        textLabel.textColor = .color333333
        contentView.addSubview(textLabel)
        
        line = UIView()
        line.backgroundColor = .colorEEEEEE
        contentView.addSubview(line)
    }
    
    override func layoutInitialization() {
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(Const.paddingLeft)
            make.right.equalToSuperview().inset(Const.paddingRight)
            make.centerY.equalToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.left.equalTo(Const.paddingLeft)
            make.right.equalToSuperview().inset(Const.paddingLeft)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    override func dataUpdates() {
        textLabel.text = item?.cityName
    }
}

class MALeftAlignedHotCell: MALeftAlignedBaseCell {
    
    fileprivate var textLabel: UILabel!
    
    override func commonInitialization() {
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .colorF9F9F9
        
        textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.font = Const.itemTextFont
        textLabel.textColor = .color333333
        contentView.addSubview(textLabel)
    }
    
    override func layoutInitialization() {
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(Const.itemInsetLeft)
            make.right.equalToSuperview().inset(Const.itemInsetRight)
            make.centerY.equalToSuperview()
        }
    }
    
    override func dataUpdates() {
        textLabel.text = item?.cityName
    }
}

class MALeftAlignedHistoriesCell: MALeftAlignedHotCell {
    
    override func commonInitialization() {
        super.commonInitialization()
        contentView.backgroundColor = .colorFBFBFB
        textLabel.textColor = .color666666
    }
}
