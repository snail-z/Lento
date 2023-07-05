//
//  SampleDawnAnimatePathway.swift
//  Lento
//
//  Created by zhang on 2023/6/27.
//

import UIKit

public protocol DawnTransitioningAnimatePathway: NSObjectProtocol {
    
    func dawnAnimatePathwayView() -> UIView?
}

public struct DawnAnimatePathway: DawnCustomTransitionCapable {
    
    public var duration: TimeInterval = 0.275
    public var zoomScale: CGFloat = 0.9
    
    public private(set) weak var sourceDelegate: DawnTransitioningAnimatePathway?
    public private(set) weak var targetDelegate: DawnTransitioningAnimatePathway?
    private let kFakeTag: Int = 10236
    
    init(source: DawnTransitioningAnimatePathway, target: DawnTransitioningAnimatePathway) {
        self.sourceDelegate = source
        self.targetDelegate = target
    }
    
    public func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool {
        let containerView = context.container
        let fromView = context.fromViewController.view!
        let toView = context.toViewController.view!
        
        guard let sourceView = sourceDelegate?.dawnAnimatePathwayView() else { return false }
        guard let targetView = targetDelegate?.dawnAnimatePathwayView() else { return false }
        guard let sourceSnapshot = sourceView.dawn.snapshotView() else { return false }
        guard let targetSnapshot = targetView.dawn.snapshotView() else { return false }
        
        containerView.addSubview(toView)
        toView.isHidden = true
        toView.layoutIfNeeded()
        
        let sourceFrame = sourceView.superview!.convert(sourceView.frame, to: containerView)
        let sourceScale = sourceView.width / sourceView.height
        let targetScale = targetView.width / targetView.height
        
        let tempView = UIView(frame: sourceFrame)
        tempView.backgroundColor = .white
        tempView.clipsToBounds = true
        tempView.layer.masksToBounds = true
        tempView.layer.cornerRadius = sourceView.layer.cornerRadius
        containerView.addSubview(tempView)
        
        targetSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.width / targetScale)
        targetSnapshot.alpha = 0
        tempView.addSubview(targetSnapshot)
        
        sourceSnapshot.frame = CGRect(origin: .zero, size: tempView.bounds.size)
        sourceSnapshot.alpha = 1
        tempView.addSubview(sourceSnapshot)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            fromView.layer.transform = CATransform3DScale(CATransform3DIdentity, zoomScale, zoomScale, 1)
            tempView.frame = containerView.frame
            tempView.layer.cornerRadius = toView.layer.cornerRadius
            
            sourceSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.width / sourceScale)
            targetSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.width / targetScale)
            targetSnapshot.alpha = 1
            sourceSnapshot.alpha = 0
        } completion: { finished in
            tempView.removeFromSuperview()
            toView.isHidden = false
            fromView.layer.transform = CATransform3DIdentity
            
            if let sView = fromView.dawn.snapshotView() {
                sView.frame = context.container.bounds
                sView.tag = kFakeTag
                context.container.insertSubview(sView, belowSubview: context.toViewController.view)
            }
         
            complete(finished)
        }
        return true
    }
    
    public func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool {
        let containerView = context.container
        let fromView = context.fromViewController.view!
        let toView = context.toViewController.view!
        
        guard let sourceView = sourceDelegate?.dawnAnimatePathwayView() else { return false }
        guard let targetView = targetDelegate?.dawnAnimatePathwayView() else { return false }
        guard let sourceSnapshot = sourceView.dawn.snapshotView() else { return false }
        guard let targetSnapshot = targetView.dawn.snapshotView() else { return false }
        
        toView.isHidden = true
        toView.layoutIfNeeded()
        
        fromView.isHidden = true
        fromView.layoutIfNeeded()
        
        let targetFrame = sourceView.superview!.convert(sourceView.frame, to: containerView)
        let sourceScale = sourceView.width / sourceView.height
        let targetScale = targetView.width / targetView.height
        
        let tempView = UIView(frame: fromView.frame)
        tempView.backgroundColor = .white
        tempView.layer.masksToBounds = true
        tempView.clipsToBounds = true
        tempView.layer.cornerRadius = fromView.layer.cornerRadius
        containerView.addSubview(tempView)
        
        sourceSnapshot.frame = CGRect(w: tempView.bounds.width, h: targetView.width / sourceScale)
        sourceSnapshot.alpha = 0
        tempView.addSubview(sourceSnapshot)
        
        targetSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.height)
        targetSnapshot.alpha = 1
        tempView.addSubview(targetSnapshot)
        
        let snpV = containerView.viewWithTag(kFakeTag)
        if fromView.tag == 2011 {
            snpV?.layer.transform = CATransform3DScale(CATransform3DIdentity, zoomScale, zoomScale, 1)
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            snpV?.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            snpV?.center = containerView.center
            
            tempView.frame = targetFrame
            tempView.layer.cornerRadius = sourceView.layer.cornerRadius
            
            targetSnapshot.frame = CGRect(w: tempView.bounds.width, h: tempView.bounds.width / targetScale)
            sourceSnapshot.frame = tempView.bounds
            
            sourceSnapshot.alpha = 1
            targetSnapshot.alpha = 0
        } completion: { finished in
            containerView.addSubview(toView)
            toView.isHidden = false
            
            containerView.addSubview(fromView)
            fromView.isHidden = false
            
            tempView.removeFromSuperview()
            fromView.isHidden = false
            toView.isHidden = false
            complete(finished)
        }
        return true
    }
}
