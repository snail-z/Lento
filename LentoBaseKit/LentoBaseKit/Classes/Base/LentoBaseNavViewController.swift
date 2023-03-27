//
//  LentoBaseNavViewController.swift
//  Lento
//
//  Created by corgi on 2022/8/13.
//

import UIKit

open class LentoBaseNavViewController: UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isTranslucent = false
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundColor = .white
            navigationBarAppearance.shadowImage = UIImage()
            navigationBarAppearance.shadowColor = .clear
            navigationBar.standardAppearance = navigationBarAppearance
            navigationBar.scrollEdgeAppearance = navigationBarAppearance
        } else {
            navigationBar.shadowImage = UIImage()
        }
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !self.viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
