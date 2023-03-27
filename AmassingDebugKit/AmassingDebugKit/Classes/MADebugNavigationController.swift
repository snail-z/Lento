//
//  MADebugNavigationController.swift
//  Lento
//
//  Created by zhang on 2023/3/15.
//

import UIKit

public class MADebugNavigationController: UINavigationController {

    public override func viewDidLoad() {
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
}
