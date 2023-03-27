//
//  SidebarViewController.swift
//  Lento
//
//  Created by zhang on 2023/1/6.
//

import UIKit
import AmassingUI
import LentoBaseKit
import LentoFeedModule

class SidebarViewController: LentoBaseViewController {

    var dissButton: MAButton!
    var visorTab: UIView!
    var isInteractive = false
    let interactiveCoordinator = UIPercentDrivenInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        visorTab = UIView()
//        let pan = MKScreenEdgePanGestureRecognizer(target: self, action: #selector(didPan))
//        pan.edges = .left
//        visorTab.addGestureRecognizer(pan)
        view.addSubview(visorTab)
        visorTab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dissButton = MAButton()
        dissButton.imagePlacement = .left
        dissButton.imageAndTitleSpacing = 10
        dissButton.imageView.image = UIImage(named: "hotfill")
        dissButton.imageFixedSize = CGSize(width: 16, height: 16)
        dissButton.titleLabel.textColor = .white
        dissButton.contentHorizontalAlignment = .center
        dissButton.backgroundColor = .brown
        dissButton.titleLabel.text = "点我消失"
        view.addSubview(dissButton)
        
        dissButton.snp.makeConstraints { make in
            make.top.equalTo(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        dissButton.addTapGesture { [weak self] tap in
            self?.dismiss(animated: true)
        }
    }
    
    @objc func didPan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: view).x
        let distance = translation / view.bounds.width

        let speed = pan.velocity(in: view)
        print("飞机===> speed is: \(speed)")

        self.interactiveCoordinator.completionSpeed = 1.1 - distance

        switch (pan.state) {
        case .began:
            print("===> began speed is: \(speed)")
            self.isInteractive = true
            self.transitioningDelegate = self
            self.dismiss(animated: true)
        case .changed:
            self.interactiveCoordinator.update(distance)
        default:
            print("===> end speed is: \(speed)")
            self.isInteractive = false

            if speed.x < 0 {
                if abs(speed.x) > 100 {
                    self.interactiveCoordinator.cancel()
                } else {
                    if distance < 0.5 {
                        self.interactiveCoordinator.cancel()
                    } else {
                        self.interactiveCoordinator.finish()
                    }
                }
            } else {/// 意图向下
                if abs(speed.x) > 100 {
                    self.interactiveCoordinator.finish()
                } else {
                    if distance < 0.5 {
                        self.interactiveCoordinator.cancel()
                    } else {
                        self.interactiveCoordinator.finish()
                    }
                }
            }
        }
    }
}


extension SidebarViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let pop = MAPopupAnimation(type: .none)
        let poo = MATabbarTransition()
        return poo
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let pop = MAPopupAnimation.init(type: .none)
        return pop
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DragTransitionPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactiveCoordinator : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactiveCoordinator : nil
    }
}

