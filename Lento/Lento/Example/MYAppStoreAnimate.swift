//
//  MYAppStoreAnimate.swift
//  Lento
//
//  Created by zhang on 2023/6/29.
//

import UIKit

public protocol DawnTransitioningAppStoreToday: NSObjectProtocol {
    
    func dawnAnimatePathwayView() -> UIView
}

public struct DawnAnimateAppStoreToday: DawnCustomTransitionCapable {
    
    public func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool {
        
        return true
    }
    
    public func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> Bool {
        
        return true
    }
}
