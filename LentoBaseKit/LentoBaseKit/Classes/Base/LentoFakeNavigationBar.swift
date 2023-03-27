//
//  LentoFakeNavigationBar.swift
//  Lento
//
//  Created by zhang on 2022/10/31.
//

import UIKit
import AmassingUI

public class LentoFakeNavigationBar: LentoBaseView {

    public private(set) var backButton: MAButton!
    public private(set) var contentVeiw: LentoFakeNavigationBarBGView!
    
    public override func commonInitialization() {
        contentVeiw = LentoFakeNavigationBarBGView()
        addSubview(contentVeiw)
        
        backButton = MAButton()
        backButton.imagePlacement = .left
        backButton.imageAndTitleSpacing = -5
        backButton.imageView.image = UIImage(named: "back_icon")?.withRenderingMode(.alwaysTemplate)
        backButton.imageView.tintColor = .black
        backButton.imageView.contentMode = .center
        backButton.contentHorizontalAlignment = .left
        backButton.titleLabel.font = .appFont(15)
        backButton.titleLabel.textColor = .black
        backButton.titleLabel.text = "返回"
        backButton.titleLabel.isHidden = true
        backButton.isHidden = true
        addSubview(backButton)
    }
    
    public override func layoutInitialization() {
        contentVeiw.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalTo(2)
            make.centerY.equalToSuperview().offset(UIScreen.statusBarHeight.scaled(0.5)) 
        }
    }
    
    /// 设置背景图
    public func setBackgroudImage(_ image: UIImage?) {
        contentVeiw.imageView.image = image
    }
    
    /// 设置是否显示返回按钮
    public func setBackButton(hidden: Bool, offset: UIEdgeInsets = .zero) {
        backButton.isHidden = hidden
        backButton.setContentHuggingPriority(.required, for: .horizontal)
        backButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        /// todo offset
    }
}

public class LentoFakeNavigationBarBGView: MAGradientView {
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        guard imageView.superview == nil else { return imageView }
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return imageView
    }()
}
