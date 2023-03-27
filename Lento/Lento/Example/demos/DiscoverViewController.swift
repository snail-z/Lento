//
//  DiscoverViewController.swift
//  Lento
//
//  Created by zhang on 2023/1/6.
//

import UIKit
import LentoFeedModule

class DiscoverViewController: UIViewController {

    let visorTab = RIghtView()
    var isInteractive = false
    let interactiveCoordinator = UIPercentDrivenInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        let pan = MKScreenEdgePanGestureRecognizer(target: self, action: #selector(didPan))
        pan.edges = .left
        visorTab.addGestureRecognizer(pan)
        visorTab.backgroundColor = .random(.fairy)
        view.addSubview(visorTab)
        visorTab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    

    @objc func didPan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: view).x
        var distance = translation / view.bounds.width
        distance = abs(distance)
        print("distance is: \(distance)")
        self.interactiveCoordinator.completionSpeed = 1.1 - distance
                
        switch (pan.state) {
        case .began:
            self.isInteractive = true
            let vc = SidebarViewController()
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        case .changed:
            self.interactiveCoordinator.update(distance)
        default:
            self.isInteractive = false
            
            if distance < 0.5 {
                self.interactiveCoordinator.cancel()
                print("cancel===cancel")
            } else {
                self.interactiveCoordinator.finish()
                print("finish===finish")
            }
        }
    }

}

extension DiscoverViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DragTransitionPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let pop = MATabbarTransition()
        return pop
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let pop = MAPopupAnimation(type: .none)
        return pop
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactiveCoordinator : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactiveCoordinator : nil
    }
}
