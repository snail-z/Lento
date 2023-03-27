//
//  LentoBaseTabBarController.swift
//  Lento
//
//  Created by zhang on 2023/1/6.
//

import UIKit
import LentoBaseKit

class LentoBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let vcs = [ViewController(), DiscoverViewController(), MineViewController()]
        let titles = ["N", "Discover", "Mine"]
        for (index, vc) in vcs.enumerated() {
            
            let nav = LentoBaseNavViewController.init(rootViewController: vc)
            vc.tabBarItem.title = titles.element(safe: index)
            vc.title = titles.element(safe: index)
            addChild(nav)
        }
        self.tabBar.isTranslucent = false
    }
    
    public func SwiftClassFromString(_ className: String) -> AnyClass! {
        // get the project name
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            // YourProject.className
            let classStringName = appName + "." + className
            return NSClassFromString(classStringName)
        }
        return nil;
    }
}
