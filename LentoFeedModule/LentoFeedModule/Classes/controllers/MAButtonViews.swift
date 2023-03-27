//
//  MAButtonViews.swift
//  Lento
//
//  Created by zhang on 2023/2/25.
//

import UIKit
import AmassingUI
import LentoBaseKit

class TTView: LentoBaseView {
    
    var leftLabel: UILabel!
    var rightLabel: MALabel!
    var line: UIView!
    
    override func commonInitialization() {
        leftLabel = UILabel()
        leftLabel.textColor = .white
        leftLabel.font = .appFont(12)
        addSubview(leftLabel)
        
        rightLabel = MALabel()
        rightLabel.textColor = .white
        rightLabel.font = .appFont(10)
        rightLabel.backgroundColor = .orange
        rightLabel.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        addSubview(rightLabel)
        
        line = UIView()
        line.backgroundColor = .red
        addSubview(line)
    }
    
    override func layoutInitialization() {
        leftLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.bottom.equalTo(-5)
            make.left.equalTo(5)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.left.equalTo(leftLabel.snp.right).offset(10)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(0.6)
            make.centerX.equalTo(rightLabel.snp.left)
        }
        
        leftLabel.text = "我是label1哈哈"
        rightLabel.text = "$10002"
    }
}

class DemoLabel: MALabel {
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override var intrinsicContentSize: CGSize {
        return super.intrinsicContentSize
    }
}


