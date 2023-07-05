//
//  LenPopupViewController.swift
//  Lento
//
//  Created by zhang on 2022/12/30.
//

import UIKit
import AmassingUI
import LentoBaseKit

public class TesstLock {
    
    var os_lock = os_unfair_lock_s()
    
    var ticketsCount: Int = 15
    
    func saleTicket() {
        os_unfair_lock_lock(&os_lock)
        defer{ os_unfair_lock_unlock(&os_lock) }
        
        var oldTicketsCount = self.ticketsCount
        sleep(2)
        oldTicketsCount -= 1
        self.ticketsCount = oldTicketsCount
        
        print("还剩余\(self.ticketsCount)张票")
        print(Thread.current)
    }
    
    func ticketTest() {
        self.ticketsCount = 15
        
        DispatchQueue.global().async {
            self.saleTicket()
        }
        
        DispatchQueue.global().async {
            self.saleTicket()
        }
        
        DispatchQueue.global().async {
            self.saleTicket()
        }
    }
}

public class MKScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer {
    
}

public class RIghtView: UIView {
    
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer.isMember(of: MkUIPanGestureRecognizer.self) {
//            let gesture:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
//            let velocity = gesture.velocity(in: self)
//            if velocity.x < 0 {
//                if abs(velocity.x) > abs(velocity.y) {
//                    return true
//                }
//            }
//            return false
//        }
//        return true
//    }
}

public class LenPopupViewController: LentoBaseViewController {

    var nextButton: MAButton!
    
    let visorTab = RIghtView()
//    let visorViewController = LenPopupNextViewController()
    
    var isInteractive = false
    let interactiveCoordinator = UIPercentDrivenInteractiveTransition()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .debugColorRandom
        
//        visorViewController.transitioningDelegate = self
//        visorViewController.view.backgroundColor = .red
        
        let pan = MKScreenEdgePanGestureRecognizer(target: self, action: #selector(didPan))
        pan.edges = .right
        visorTab.addGestureRecognizer(pan)
        visorTab.backgroundColor = .random(.fairy)
        view.addSubview(visorTab)
        visorTab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nextButton = MAButton()
        nextButton.imagePlacement = .left
        nextButton.imageAndTitleSpacing = 10
        nextButton.imageView.image = UIImage(named: "hotfill")
        nextButton.imageFixedSize = CGSize(width: 16, height: 16)
        nextButton.titleLabel.textColor = .white
        nextButton.contentHorizontalAlignment = .center
        nextButton.backgroundColor = .brown
        nextButton.titleLabel.text = "Next"
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        nextButton.addTapGesture { [weak self] tap in
            let vc = LenPopupNextViewController()
            vc.transitioningDelegate = self
            self?.present(vc, animated: true)
//            self?.goto()
        }
        
        
        
        
        
    }
    
    
    func goto() {
        let lock = TesstLock()
//        lock.saleTicket()
        lock.ticketTest()
    }
    
    @objc func didPan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: view).x
        var distance = translation / view.bounds.width
        distance = abs(distance)
        
        self.interactiveCoordinator.completionSpeed = 1.1 - distance
                
        switch (pan.state) {
        case .began:
            self.isInteractive = true
            let vc = LenPopupNextViewController()
            vc.transitioningDelegate = self
            self.present(vc, animated: true)
        case .changed:
            self.interactiveCoordinator.update(distance)
        default:
            self.isInteractive = false
            
            if distance < 0.5 {
                self.interactiveCoordinator.cancel()
            } else {
                self.interactiveCoordinator.finish()
            }
        }
    }
}

extension LenPopupViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DragTransitionPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let pop = MAPopupAnimation(type: .capted)
        return pop
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let pop = MAPopupAnimation(type: .none)
        return pop
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactiveCoordinator : nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactiveCoordinator : nil
    }
}

public class DragTransitionPresentationController: UIPresentationController {
    
}
