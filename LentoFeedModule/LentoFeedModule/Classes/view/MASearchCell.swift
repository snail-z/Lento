//
//  MASearchCell.swift
//  Lento
//
//  Created by zhang on 2022/10/27.
//

import UIKit
import AmassingUI
import LentoBaseKit

fileprivate typealias Const = MASearchConst

class MASearchHistoriesEmptyCell: LentoBaseCollectionCell {
    
    private var tipLabel: UILabel!
    
    override func commonInitialization() {
        tipLabel = UILabel()
        tipLabel.textAlignment = .left
        tipLabel.font = .appFont(12)
        tipLabel.textColor = .color999999
        tipLabel.text = "试试搜索小区、楼盘等名称去找寻心仪房源吧"
        contentView.addSubview(tipLabel)
    }
    
    override func layoutInitialization() {
        tipLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
}

@objc protocol MASearchHistoriesCellDelegate {

    @objc optional func historiesCell(_ historiesCell: MASearchHistoriesCell, didSelectItemAt index: Int)
    @objc optional func historiesCell(_ historiesCell: MASearchHistoriesCell, didDeleteItemAt index: Int)
}

class MASearchHistoriesCell: LentoBaseCollectionCell {
    
    public weak var delegate: MASearchHistoriesCellDelegate?
    public var itemIndex: Int = 0
    
    public var item: MASearchHistoryItem? {
        didSet { dataUpdates() }
    }
    
    private var button: MAButton!
    
    override func commonInitialization() {
        contentView.layer.cornerRadius = 2
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .colorF9F9F9
        
        button = MAButton()
        button.imagePlacement = .right
        button.imageAndTitleSpacing = Const.deleAndTextSpacing
        button.imageFixedSize = Const.deleIconSize
        button.imageView.image = UIImage(named: "chahao")?.withRenderingMode(.alwaysTemplate)
        button.imageView.tintColor = .color999999
        button.imageView.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .center
        button.titleLabel.textColor = .color333333
        button.titleLabel.lineBreakMode = .byTruncatingTail
        button.titleLabel.font = Const.itemTextFont
        button.titleLabel.isUserInteractionEnabled = true
        button.imageView.isUserInteractionEnabled = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: Const.itemInsetLeft, bottom: 0, right: Const.itemInsetRight)
        button.titleLabel.addGestureRecognizer(UITapGestureRecognizer.action.gestureClosure({ [weak self] _ in
            guard let `self` = self else { return }
            self.delegate?.historiesCell?(self, didSelectItemAt: self.itemIndex)
        }))
        button.imageView.addGestureRecognizer(UITapGestureRecognizer.action.gestureClosure({ [weak self] _ in
            guard let `self` = self else { return }
            self.delegate?.historiesCell?(self, didDeleteItemAt: self.itemIndex)
        }))
        contentView.addSubview(button)
    }
    
    override func layoutInitialization() {
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
    
    func dataUpdates() {
        button.titleLabel.text = item?.name
    }
}

@objc protocol MASearchDiscoverCellDelegate {

    @objc optional func discoverCell(_ discoverCell: MASearchDiscoverCell, didSelectItemAt index: Int)
}

class MASearchDiscoverCell: LentoBaseCollectionCell {
    
    public weak var delegate: MASearchDiscoverCellDelegate?
    public var itemIndex: Int = 0
    
    public var item: MASearchLeftItem? {
        didSet { dataUpdates() }
    }
    
    private var button: MAButton!
    
    override func commonInitialization() {
        contentView.layer.cornerRadius = 2
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .colorF9F9F9
        
        button = MAButton()
        button.imagePlacement = .left
        button.imageAndTitleSpacing = Const.hotAndTextSpacing
        button.imageFixedSize = Const.hotIconSize
        button.imageView.image = UIImage(named: "hotfill")?.withRenderingMode(.alwaysTemplate)
        button.imageView.tintColor = .appBlue()
        button.imageView.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .center
        button.titleLabel.textColor = .color333333
        button.titleLabel.lineBreakMode = .byTruncatingTail
        button.titleLabel.font = Const.itemTextFont
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: Const.itemInsetLeft, bottom: 0, right: Const.itemInsetRight)
        button.addGestureRecognizer(UITapGestureRecognizer.action.gestureClosure({ [weak self] _ in
            guard let `self` = self else { return }
            self.delegate?.discoverCell?(self, didSelectItemAt: self.itemIndex)
        }))
        contentView.addSubview(button)
    }
    
    override func layoutInitialization() {
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
    
    func dataUpdates() {
        button.titleLabel.text = item?.name
        button.imageView.isHidden = item?.hot?.isBlank ?? true
    }
}
