//
//  NoteAdCell.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//

import UIKit
import SnapKit
import LentoBaseKit

class FeedAdCell: LentoBaseCollectionCell {
 
    var model: FeedModel? {
        didSet {
            dataUpdate()
        }
    }
    
    var titleLabel: UILabel!
    var messageLabel: UILabel!
    
    override func commonInitialization() {
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.random(.gentle)
        titleLabel.font = .pingFang(20)
        contentView.addSubview(titleLabel)
        
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.font = .pingFang(12)
        messageLabel.textColor = UIColor.white
        contentView.addSubview(messageLabel)
    }
    
    override func layoutInitialization() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(kGeneralPaddingleft)
            make.right.equalTo(-kGeneralPaddingRight)
            make.top.equalTo(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.bottom.lessThanOrEqualTo(-20)
        }
    }
    
    func dataUpdate() {
        titleLabel.text = model?.title
        messageLabel.text = model?.content
    }
}

extension FeedAdCell {
    
    static func height(with model: FeedModel) -> CGFloat {
        var height = model.title.boundingHeight(with: kGeneralLayoutMaxWidth, font: .pingFang(20))
        height += model.content.boundingHeight(with: kGeneralLayoutMaxWidth, font: .pingFang(12))
        height += (20 + 15 + 20)
        return height
    }
}
