//
//  MAWaterfallDetailViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/25.
//

import UIKit
import LentoBaseKit

extension MAWaterfallDetailViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return MAWaterfallPopTransion()
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is MAWaterfallPopTransion {
            return self.percentDrivenTransition
        } else {
            return nil
        }
    }
}

class MAWaterfallDetailViewController: LentoBaseViewController {

    var imageView: UIImageView!
    var ccimage: UIImage? {
        didSet {
            imageView?.image = ccimage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView()
        imageView.backgroundColor = .orange
        imageView.contentMode = .scaleAspectFit
        imageView.image = ccimage
        view.addSubview(imageView)
        view.layer.masksToBounds = true
        
        let targetSize = ccimage?.sizeOfScaled(width: view.bounds.width) ?? .zero
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(targetSize.width)
            make.height.equalTo(targetSize.height)
        }
        
        //手势监听器
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture(_:)))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
//        let image = UIImage.image(with: .clear)
//        if #available(iOS 15.0, *) {
//            let navigationBarAppearance = UINavigationBarAppearance()
//            if navigationController?.navigationBar.isTranslucent ?? false {
//                navigationBarAppearance.configureWithTransparentBackground()
//            } else {
//                navigationBarAppearance.configureWithOpaqueBackground()
//            }
//            navigationBarAppearance.backgroundColor = .clear
//            navigationBarAppearance.backgroundImage = image
//            navigationBarAppearance.shadowImage = UIImage()
//            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
//            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
//        } else {
//            navigationController?.navigationBar.barTintColor = .clear
//            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            navigationController?.navigationBar.shadowImage = UIImage()
//        }
        
        
    }
    
    
    
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    
    @objc func edgePanGesture(_ edgePan: UIScreenEdgePanGestureRecognizer) {
        
        self.navigationController?.delegate = self
        
        let progress = edgePan.translation(in: self.view).x / self.view.bounds.width
        
        if edgePan.state == .began {
            self.percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
        } else if edgePan.state == .changed {
            self.percentDrivenTransition?.update(progress)
        } else if edgePan.state == .ended {
            if progress > 0.25 {
                self.percentDrivenTransition?.finish()
            } else {
                self.percentDrivenTransition?.cancel()
            }
            self.percentDrivenTransition = nil
            
            self.navigationController?.delegate = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarTransparent(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavBarTransparent(false)
    }
}
