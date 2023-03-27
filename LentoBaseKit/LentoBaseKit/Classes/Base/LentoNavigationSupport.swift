//
//  LentoNavigationSupport.swift
//  Lento
//
//  Created by zhang on 2022/11/1.
//

import UIKit

extension UIViewController {
    
    /// 设置导航栏背景色
    ///
    /// -viewDidLoad:
    /// setNavigationBarBackgroundColor(.orange)
    public func setNavBarBackgroundColor(_ color: UIColor?) {
        let image = UIImage.image(with: color)
        _setNavBGImage(image)
    }

    /// 设置导航栏透明样式
    ///
    /// -viewWillAppear：
    /// setNavigationBarTransparent(true)
    ///
    /// -viewWillDisappear：
    /// setNavigationBarTransparent(false)
    public func setNavBarTransparent(_ transparent: Bool) {
        navigationController?.navigationBar.isTranslucent = transparent
        guard transparent else { return }
        _setNavBGImage(UIImage())
    }
    
    /// 设置隐藏导航栏
    ///
    /// -viewWillAppear：
    /// setNavBarHidden(true, animated: animated)
    ///
    /// -viewWillDisappear：
    /// setNavBarHidden(false, animated: animated)
    public func setNavBarHidden(_ hidden: Bool, animated: Bool) {
        navigationController?.setNavigationBarHidden(hidden, animated: animated)
    }
}

extension UIViewController {
    
    private func _setNavBGImage(_ image: UIImage?) {
        if #available(iOS 15.0, *) {
            guard let navigationBarAppearance = navigationController?.navigationBar.standardAppearance else { return }
            if navigationController?.navigationBar.isTranslucent ?? false {
                navigationBarAppearance.configureWithTransparentBackground()
            } else {
                navigationBarAppearance.configureWithOpaqueBackground()
            }
            navigationBarAppearance.backgroundColor = .clear
            navigationBarAppearance.backgroundImage = image
            navigationBarAppearance.shadowImage = image
            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        } else {
            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            navigationController?.navigationBar.shadowImage = image
        }
    }
}
