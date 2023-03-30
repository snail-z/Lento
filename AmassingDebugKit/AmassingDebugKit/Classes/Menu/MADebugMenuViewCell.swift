//
//  MADebugMenuViewCell.swift
//  Lento
//
//  Created by zhang on 2023/3/16.
//

import UIKit
import AmassingUI

class MADebugMenuViewCell: UICollectionViewCell {
    
    var item: MADebugMenuItem? {
        didSet {
            dataUpdates()
        }
    }
    
    var container: UIView!
    var iconLabel: MALabel!
    var descLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        commonInitialization()
        layoutInitialization()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitialization()
        layoutInitialization()
    }
    
    @objc open func commonInitialization() {
        container = UIView()
        contentView.addSubview(container)
        
        iconLabel = MALabel()
        iconLabel.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        iconLabel.adjustsRoundedCornersAutomatically = true
        iconLabel.font = UIFont.name(.menlo, style: .bold, size: 28)
        iconLabel.textColor = .white
        iconLabel.textAlignment = .center
        iconLabel.backgroundColor = UIColor.rgb(same: 222)
        iconLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(iconLabel)
        
        descLabel = UILabel()
        descLabel.font = UIFont.name(.pingFangSC, style: .light, size: 14)
        descLabel.textColor = .darkText
        contentView.addSubview(descLabel)
    }
    
    @objc open func layoutInitialization() {
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(iconLabel.snp.top)
            make.bottom.equalTo(descLabel.snp.bottom)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(iconLabel.snp.width)
        }
        
        descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconLabel.snp.bottom).offset(12)
            make.width.lessThanOrEqualToSuperview().inset(10)
        }
    }
    
    func dataUpdates() {
        iconLabel.text = item?.short
        descLabel.text = item?.desc
    }
}
