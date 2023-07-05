//
//  DawnAnimateRoundKnob.swift
//  Lento
//
//  Created by zhang on 2023/7/3.
//

import UIKit

public struct DawnAnimateRoundKnob: DawnCustomTransitionCapable {
    
    private let kFakeTag: Int = 10236
    public var duration: TimeInterval = 0.275
    public var zoomScale: CGFloat = 0.9

    public func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool {
        return false
    }
    
    public func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool {
        let containerView = context.container
        let fromView = context.fromViewController.view!
        let toView = context.toViewController.view!
        
        guard let sourceSnapshot = fromView.dawn.snapshotView() else { return false }
        guard let targetSnapshot = toView.dawn.snapshotView() else { return false }
        
        targetSnapshot.frame = containerView.bounds
        containerView.addSubview(targetSnapshot)
        
        let tempView = UIView(frame: containerView.bounds)
        tempView.backgroundColor = .yellow
        tempView.layer.masksToBounds = true
        tempView.clipsToBounds = true
        tempView.layer.cornerRadius = fromView.layer.cornerRadius
        tempView.layer.masksToBounds = true
        containerView.addSubview(tempView)
        
        sourceSnapshot.frame = containerView.bounds
        tempView.addSubview(sourceSnapshot)
        
        let roundView = UIView()
        roundView.frame = tempView.bounds
        roundView.backgroundColor = .white
        roundView.alpha = 0
        tempView.addSubview(roundView)
        
        fromView.isHidden = true
        tempView.layer.cornerRadius = 10
        UIView.animate(withDuration: 0.275, delay: 0, options: .curveEaseOut) {
            let size = CGSize(width: 60, height: 60)
            let paddingtop: CGFloat = 5
            let x = UIScreen.main.bounds.width - paddingtop - size.width
            tempView.frame = CGRect(x: x, y: paddingtop + UIScreen.totalNavHeight, width: size.width, height: size.height)
            sourceSnapshot.frame = tempView.bounds
            roundView.alpha = 1
            tempView.layer.cornerRadius = size.width / 2
        } completion: { finished in
            UIView.animate(withDuration: 0.25) {
                tempView.alpha = 0
            } completion: { _ in
                targetSnapshot.removeFromSuperview()
                tempView.removeFromSuperview()
                fromView.isHidden = false
                toView.isHidden = false
                complete(finished)
            }
        }
        return true
    }
}
