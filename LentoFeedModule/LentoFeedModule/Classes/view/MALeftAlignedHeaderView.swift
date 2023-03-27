//
//  MALeftAlignedHeaderView.swift
//  Lento
//
//  Created by zhang on 2022/10/21.
//

import UIKit
import AmassingUI
import LentoBaseKit

class MALeftAlignedHeaderView: LentoBaseReusableView {
        
    private var backGradientView: MAGradientView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    
    override func commonInitialization() {
        backGradientView = MAGradientView()
        backGradientView.gradientDirection = .leftToRight
        backGradientView.gradientClolors = [.colorF9F9F9, .white]
        addSubview(backGradientView)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = .appFont(14, style: .medium)
        titleLabel.textColor = .color333333
        addSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .right
        subtitleLabel.font = .appFont(12)
        subtitleLabel.textColor = .color666666
        addSubview(subtitleLabel)
    }
    
    override func layoutInitialization() {
        backGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(MALeftAlignedConst.paddingLeft)
            make.height.equalTo(MALeftAlignedConst.headerReferenceHeight)
            make.top.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(MALeftAlignedConst.paddingRight)
        }
    }
    
    public func setTitle(_ title: String?, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle?.isBlank ?? true
    }
}
