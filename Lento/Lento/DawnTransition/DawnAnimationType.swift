//
//  DawnAnimationType.swift
//  Lento
//
//  Created by zhang on 2023/6/25.
//

import UIKit

public enum DawnAnimationType: Equatable {
    
    public enum Direction {
        case left, right, up, down
    }
    
    case push(direction: Direction)
    case pull(direction: Direction)
    
    case pageIn(direction: Direction, scale: CGFloat = 0.9)
    case pageOut(direction: Direction, scale: CGFloat = 0.9)

    case zoomSlide(direction: Direction, scale: CGFloat = 0.8)
    case fade
    case none
    
    indirect case selectBy(presenting: DawnAnimationType, dismissing: DawnAnimationType)
}

extension DawnAnimationType {
    
    internal func reversed() -> DawnAnimationType {
        switch self {
        case .push(direction: .up):
            return .pull(direction: .down)
        case .push(direction: .down):
            return .pull(direction: .up)
        case .push(direction: .left):
            return .pull(direction: .right)
        case .push(direction: .right):
            return .pull(direction: .left)
        case .pull(direction: .left):
            return .push(direction: .right)
        case .pull(direction: .right):
            return .push(direction: .left)
        case .pull(direction: .up):
            return .push(direction: .down)
        case .pull(direction: .down):
            return .push(direction: .up)
        case .pageIn(direction: .left, let value):
            return .pageOut(direction: .right, scale: value)
        case .pageIn(direction: .right, let value):
            return .pageOut(direction: .left, scale: value)
        case .pageIn(direction: .up, let value):
            return .pageOut(direction: .down, scale: value)
        case .pageIn(direction: .down, let value):
            return .pageOut(direction: .up, scale: value)
        case .pageOut(direction: .left, let value):
            return .pageIn(direction: .right, scale: value)
        case .pageOut(direction: .right, let value):
            return .pageIn(direction: .left, scale: value)
        case .pageOut(direction: .up, let value):
            return .pageIn(direction: .down, scale: value)
        case .pageOut(direction: .down, let value):
            return .pageIn(direction: .up, scale: value)
        case .zoomSlide(direction: .left, let value):
            return .zoomSlide(direction: .right, scale: value)
        case .zoomSlide(direction: .right, let value):
            return .zoomSlide(direction: .left, scale: value)
        case .zoomSlide(direction: .up, let value):
            return .zoomSlide(direction: .down, scale: value)
        case .zoomSlide(direction: .down, let value):
            return .zoomSlide(direction: .up, scale: value)
        case .fade:
            return .fade
        default:
            return .none
        }
    }
    
    internal static var linearOffset: CGPoint {
        return CGPoint(x: UIScreen.size.width * 0.28, y: UIScreen.size.height * 0.28)
    }
    
    internal static func stage(type: DawnAnimationType) -> DawnModifierStage {
        let stage = DawnModifierStage()
        switch type {
        case .push(direction: .left):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(horizontal: -linearOffset.x), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(.right), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
        case .push(direction: .right):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(horizontal: linearOffset.x), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(.left), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
        case .push(direction: .up):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(vertical: -linearOffset.y), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(.down), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
        case .push(direction: .down):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(vertical: linearOffset.y), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(.up), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
            
        case .pull(direction: .left):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.left), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(horizontal: linearOffset.x), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
        case .pull(direction: .right):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.right), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(horizontal: -linearOffset.x), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
        case .pull(direction: .up):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.up), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(vertical: linearOffset.y), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
        case .pull(direction: .down):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.down), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(vertical: -linearOffset.y), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
        
        case .pageIn(direction: .left, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .cornerRadius(0)]
            stage.fromViewEndModifiers = [.scale(scale), .cornerRadius(10)]
            stage.toViewBeginModifiers = [.position(.right), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
        case .pageIn(direction: .right, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .cornerRadius(0)]
            stage.fromViewEndModifiers = [.scale(scale), .cornerRadius(10)]
            stage.toViewBeginModifiers = [.position(.left), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
        case .pageIn(direction: .up, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .cornerRadius(0)]
            stage.fromViewEndModifiers = [.scale(scale), .cornerRadius(10)]
            stage.toViewBeginModifiers = [.position(.down), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
        case .pageIn(direction: .down, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .cornerRadius(0)]
            stage.fromViewEndModifiers = [.scale(scale), .cornerRadius(10)]
            stage.toViewBeginModifiers = [.position(.up), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .defaultShadow()]
            
        case .pageOut(direction: .right, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.right), .defaultShadow()]
            stage.toViewBeginModifiers = [.scale(scale), .cornerRadius(10)]
            stage.toViewEndModifiers = [.transformIdentity, .cornerRadius(0)]
        case .pageOut(direction: .left, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.left), .defaultShadow()]
            stage.toViewBeginModifiers = [.scale(scale), .cornerRadius(10)]
            stage.toViewEndModifiers = [.transformIdentity, .cornerRadius(0)]
        case .pageOut(direction: .down, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.down), .defaultShadow()]
            stage.toViewBeginModifiers = [.scale(scale), .cornerRadius(10)]
            stage.toViewEndModifiers = [.transformIdentity, .cornerRadius(0)]
        case .pageOut(direction: .up, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.up), .defaultShadow()]
            stage.toViewBeginModifiers = [.scale(scale), .cornerRadius(10)]
            stage.toViewEndModifiers = [.transformIdentity, .cornerRadius(.zero)]
            
        case .zoomSlide(direction: .left, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.left), .scale(scale), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(.right), .scale(scale), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .transformIdentity, .defaultShadow()]
        case .zoomSlide(direction: .right, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.right), .scale(scale), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(.left), .scale(scale), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .transformIdentity, .defaultShadow()]
        case .zoomSlide(direction: .up, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.up), .scale(scale), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(.down), .scale(scale), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .transformIdentity, .defaultShadow()]
        case .zoomSlide(direction: .down, let scale):
            stage.fromViewBeginModifiers = [.position(.center), .defaultShadow()]
            stage.fromViewEndModifiers = [.position(.down), .scale(scale), .defaultShadow()]
            stage.toViewBeginModifiers = [.position(.up), .scale(scale), .defaultShadow()]
            stage.toViewEndModifiers = [.position(.center), .transformIdentity, .defaultShadow()]
           
        case .fade:
            stage.fromViewBeginModifiers = [.opacity(1)]
            stage.fromViewEndModifiers = [.opacity(0)]
            stage.toViewBeginModifiers = [.opacity(0)]
            stage.toViewEndModifiers = [.opacity(1)]
        default: break
        }
        return stage
    }
    
    internal func toTransitionDeputy() -> DawnCustomTransitionDeputy {
        let pType: DawnAnimationType, dType: DawnAnimationType
        switch self {
        case .selectBy(let presenting, let dismissing):
            pType = presenting
            dType = dismissing
        default:
            pType = self
            dType = reversed()
        }
        
        let deputy = DawnCustomTransitionDeputy()
        deputy.presentingModifierStage = DawnAnimationType.stage(type: pType)
        deputy.dismissingModifierStage = DawnAnimationType.stage(type: dType)
        
        let presentingToBack: Bool, dismissingToBack: Bool
        switch pType {
        case .pull(_), .pageOut(_,_): presentingToBack = true
        default: presentingToBack = false
        }
        
        switch dType {
        case .pull(_), .pageOut(_,_): dismissingToBack = true
        default: dismissingToBack = false
        }
        
        deputy.presentingConfiguration = DawnAnimationConfiguration(sendToViewToBack: presentingToBack)
        deputy.dismissingConfiguration = DawnAnimationConfiguration(sendToViewToBack: dismissingToBack)
        return deputy
    }
}

internal class DawnCustomTransitionDeputy {
    
    internal var presentingModifierStage: DawnModifierStage = .init()
    internal var dismissingModifierStage: DawnModifierStage = .init()
    
    internal var presentingConfiguration: DawnAnimationConfiguration = .init(sendToViewToBack: false)
    internal var dismissingConfiguration: DawnAnimationConfiguration = .init(sendToViewToBack: true)
}

extension DawnCustomTransitionDeputy: DawnCustomTransitionCapable {
    
    internal func dawnModifierStagePresenting() -> DawnModifierStage {
        return presentingModifierStage
    }
    
    internal func dawnModifierStageDismissing() -> DawnModifierStage {
        return dismissingModifierStage
    }
    
    internal func dawnAnimationConfigurationPresenting() -> DawnAnimationConfiguration {
        return presentingConfiguration
    }
    
    internal func dawnAnimationConfigurationDismissing() -> DawnAnimationConfiguration {
        return dismissingConfiguration
    }
}
