//
//  LentoBaseViewController.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//

import UIKit

open class LentoBaseViewController: UIViewController, UIGestureRecognizerDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        let aview = UIView()
        aview.layer.masksToBounds = false
        aview.size = CGSize(width: 44, height: 44)

        let imagev = UIImageView()
        imagev.frame = aview.bounds
        imagev.image = UIImage(named: "back_icon")?.withRenderingMode(.alwaysTemplate)
        imagev.left = -16
        imagev.tintColor = .black
        aview.addSubview(imagev)
        aview.addGestureRecognizer(UITapGestureRecognizer.action.gestureClosure({ [weak self] _ in             self?.backToViewController()
        }))
        
        let backitemmmm = UIBarButtonItem.init(customView: aview)
        navigationItem.leftBarButtonItems = [backitemmmm]
    }
    
    public func backToViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    public private(set) lazy var navigationBar: LentoFakeNavigationBar = {
        let navigationBar = LentoFakeNavigationBar()
        navigationBar.contentVeiw.gradientDirection = .leftToRight
        navigationBar.backButton.addGestureRecognizer(UITapGestureRecognizer.action.gestureClosure({ [weak self] _ in
            self?.backToViewController()
        }))
        return navigationBar
    }()
}

extension LentoBaseViewController {
    
    /// 页面添加自定义导航栏
    public func addNavigationBar(extendedLayout: CGFloat = .zero) {
        guard navigationBar.superview == nil else { return }
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(UIScreen.totalNavHeight + extendedLayout)
        }
    }
    
    public func addNavigationBar(extendedLayout: CGFloat = .zero, aboveSubview: UIView) {
        guard navigationBar.superview == nil else { return }
        view.insertSubview(navigationBar, aboveSubview: aboveSubview)
        navigationBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(UIScreen.totalNavHeight + extendedLayout)
        }
    }
    
    public func addNavigationBar(extendedLayout: CGFloat = .zero, belowSubview: UIView) {
        guard navigationBar.superview == nil else { return }
        view.insertSubview(navigationBar, belowSubview: belowSubview)
        navigationBar.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(UIScreen.totalNavHeight + extendedLayout)
        }
    }
}
