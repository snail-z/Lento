//
//  MADebugBaseViewController.swift
//  Lento
//
//  Created by zhang on 2023/3/15.
//

import UIKit
import AmassingExtensions

internal extension UIColor {
    
    static var debugGreen: UIColor {
        return UIColor.hex(0x42d459)
    }
    
    static var debugBlack: UIColor {
        return UIColor.darkGray
    }
}

public class MADebugBaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let controllers = self.navigationController?.children, controllers.count > 1 {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let backitemmmm = UIBarButtonItem.init(customView: backView)
        navigationItem.leftBarButtonItems = [backitemmmm]
    }
    
    lazy var backView = {
        let aview = UIView()
        aview.layer.masksToBounds = false
        aview.size = CGSize(width: 44, height: 44)

        let imagev = UIImageView()
        imagev.frame = aview.bounds
        imagev.image = UIImage(named: "back_icon")?.withRenderingMode(.alwaysTemplate)
        imagev.left = -16
        imagev.tintColor = .black
        aview.addSubview(imagev)
        aview.addGestureRecognizer(UITapGestureRecognizer.action.gestureClosure({ [weak self] _ in            self?.backToViewController()
        }))
        return aview
    }()
    
    var backImageView: UIImageView? {
        return backView.subviews.last as? UIImageView
    }
    
    func backToViewController() {
        if let controllers = self.navigationController?.children, controllers.count > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

extension MADebugBaseViewController {
    
}
