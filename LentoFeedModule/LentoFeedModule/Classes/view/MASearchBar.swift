//
//  MASearchView.swift
//  AmassingUI
//
//  Created by zhanghao on 2022/10/2.
//

import UIKit
import AmassingUI
import LentoBaseKit

class MASearchBar: LentoBaseView {

    private(set) var textField: MATextField!
    private(set) var cancelButton: MALabel!
    
    override func commonInitialization() {
        textField = MATextField()
        textField.backgroundColor = .colorF5F5F5
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        textField.setPlaceholder("请输入小区/商圈/地铁站")
        textField.font = .appFont(16, style: .medium)
        textField.textColor = .color333333
        textField.isSecureTextEntry = false
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.clearButtonPadding = 10
        
        let iconView = UIImageView()
        iconView.image = UIImage(named: "search_loupe")
        iconView.sizeToFit()
        let leftView = UIView()
        leftView.addSubview(iconView)
        leftView.frame = iconView.bounds
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.leftViewPadding = 15
        textField.textEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 10)
        addSubview(textField)
        
        cancelButton = MALabel()
        cancelButton.isUserInteractionEnabled = true
        cancelButton.font = .appFont(17, style: .semiBold)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 25)
        cancelButton.text = "取消"
        addSubview(cancelButton)
    }

    override func layoutInitialization() {
        cancelButton.setContentHuggingPriority(.required, for: .horizontal)
        cancelButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        cancelButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.right.equalTo(cancelButton.snp.left)
        }
    }
}
