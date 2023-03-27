//
//  MASearchListViewController+Layout.swift
//  Lento
//
//  Created by zhang on 2022/11/11.
//

import UIKit
import AmassingUI

extension MASearchListViewController {

    func commonInitialization() {
        person = Person()
        
        navigationBar.contentVeiw.backgroundColor = .white
        navigationBar.addShadow(radius: 6, opacity: 0.05)
        navigationBar.setBackButton(hidden: false)
        addNavigationBar(extendedLayout: 10)
        
        textField = MATextField()
        textField.setPlaceholder("请输入位置/名称")
        textField.backgroundColor = .colorF5F5F5
        textField.layer.cornerRadius = 20
        textField.layer.masksToBounds = true
        textField.font = .appFont(14)
        textField.textColor = .color999999
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
        navigationBar.addSubview(textField)
        
        filterBar = UIView()
        filterBar.backgroundColor = .lightGray
        view.insertSubview(filterBar, belowSubview: navigationBar)
        
        passwordField = MATextField()
        passwordField.setPlaceholder("请输入密码")
        passwordField.backgroundColor = .colorF5F5F5
        passwordField.layer.cornerRadius = 20
        passwordField.layer.masksToBounds = true
        passwordField.font = .appFont(14)
        passwordField.textColor = .color999999
        passwordField.isSecureTextEntry = false
        passwordField.returnKeyType = .search
        passwordField.clearButtonMode = .whileEditing
        passwordField.clearButtonPadding = 10
        passwordField.textEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 10)
        view.addSubview(passwordField)
        
        loginButton = UIButton()
        loginButton.backgroundColor = .yellow
        loginButton.setTitle("登录", for: .normal)
        view.addSubview(loginButton)
    }
    
    func layoutInitialization() {
        textField.snp.makeConstraints { make in
            make.left.equalTo(40)
            make.right.equalTo(-20)
            make.centerY.equalTo(navigationBar.backButton)
            make.height.equalTo(40)
        }
        
        filterBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.height.equalTo(50)
        }
        
        passwordField.snp.makeConstraints { make in
            make.left.equalTo(40)
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(filterBar.snp.bottom)
            make.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.left.equalTo(100)
            make.top.equalTo(200)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
}
