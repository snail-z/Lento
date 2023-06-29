//
//  DawnTransitionModifiers.swift
//  Lento
//
//  Created by zhang on 2023/6/12.
//

import UIKit

public class DawnModifierStage {
    
    /// 动画开始前样式
    var fromViewBeginModifiers: [DawnModifier]?
    /// 动画完成后样式
    var fromViewEndModifiers: [DawnModifier]?
    
    var toViewBeginModifiers: [DawnModifier]?
    var toViewEndModifiers: [DawnModifier]?
}

extension DawnModifierStage {
    
    internal static func `default`() -> DawnModifierStage {
        let stage = DawnModifierStage()
        return stage
    }
}

public struct DawnTargetState {
    
    public var transform: CATransform3D?
    
    public enum Position {
        case left
        case right
        case up
        case down
        case center
        case any(x: CGFloat, y: CGFloat)
    }
    public var position: Position?
    
    public var size: CGSize?
    public var opacity: Float?
    public var cornerRadius: CGFloat?
    public var backgroundColor: CGColor?
    
    public var borderWidth: CGFloat?
    public var borderColor: CGColor?
    
    public var shadowColor: CGColor?
    public var shadowOpacity: Float?
    public var shadowOffset: CGSize?
    public var shadowRadius: CGFloat?
    
    public enum BlurEffect: Int {
        case extraLight = 0
        case light = 1
        case dark = 2
    }
    public var blurOverlay: (effect: BlurEffect, opacity: CGFloat)?
    public var overlay: (color: UIColor, opacity: CGFloat)?
}

extension DawnTargetState {
    
    internal static func final(_ modifiers: [DawnModifier]) -> DawnTargetState {
        var state = DawnTargetState()
        for modifier in modifiers {
            modifier.apply(&state)
        }
        return state
    }
}

public final class DawnModifier {
  
    internal let apply:(inout DawnTargetState) -> Void
  
    public init(applyFunction:@escaping (inout DawnTargetState) -> Void) {
        apply = applyFunction
    }
}

extension DawnModifier {
    
    public static func transform(_ t: CATransform3D) -> DawnModifier {
      return DawnModifier { targetState in
          targetState.transform = t
      }
    }
    
    public static var transformIdentity: DawnModifier {
        return DawnModifier { targetState in
            targetState.transform = CATransform3DIdentity
        }
    }
    
    /// 缩放-设置x轴y轴和z轴上的缩放比例，默认为1
    public static func scale(x: CGFloat = 1, y: CGFloat = 1, z: CGFloat = 1) -> DawnModifier {
      return DawnModifier { targetState in
          targetState.transform = CATransform3DScale(targetState.transform ?? CATransform3DIdentity, x, y, z)
      }
    }
    
    /// 缩放-设置x轴y轴上的缩放比例
    public static func scale(_ xy: CGFloat) -> DawnModifier {
        return .scale(x: xy, y: xy)
    }
    
    /// 平移-设置x轴y轴和z轴上的平移距离，默认为0
    public static func translate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.transform = CATransform3DTranslate(targetState.transform ?? CATransform3DIdentity, x, y, z)
        }
    }
    
    /// 平移-设置x轴y轴上的平移距离，默认为0
    public static func translate(_ point: CGPoint, z: CGFloat = 0) -> DawnModifier {
        return translate(x: point.x, y: point.y, z: z)
    }
    
    /// 旋转-设置x轴y轴和z轴上的旋转角度，默认为0
    public static func rotate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.transform = CATransform3DRotate(targetState.transform ?? CATransform3DIdentity, x, 1, 0, 0)
            targetState.transform = CATransform3DRotate(targetState.transform!, y, 0, 1, 0)
            targetState.transform = CATransform3DRotate(targetState.transform!, z, 0, 0, 1)
        }
    }
}

extension DawnModifier {
    
    public static func size(_ size: CGSize) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.size = size
        }
    }
    
    public static func position(_ position: DawnTargetState.Position) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.position = position
        }
    }
    
    public static func position(horizontal offset : CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            let bounds = UIScreen.main.bounds
            targetState.position = .any(x: bounds.width * 0.5 + offset, y: bounds.height * 0.5)
        }
    }
    
    public static func position(vertical offset : CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            let bounds = UIScreen.main.bounds
            targetState.position = .any(x: bounds.width * 0.5, y: bounds.height * 0.5 + offset)
        }
    }
    
    public static func opacity(_ opacity: CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.opacity = Float(opacity)
        }
    }
    
    public static func cornerRadius(_ cornerRadius: CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.cornerRadius = cornerRadius
        }
    }
    
    public static func backgroundColor(_ backgroundColor: UIColor) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.backgroundColor = backgroundColor.cgColor
        }
    }
}

extension DawnModifier {
    
    public static func borderWidth(_ borderWidth: CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.borderWidth = borderWidth
        }
    }
    
    public static func borderColor(_ borderColor: UIColor) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.borderColor = borderColor.cgColor
        }
    }
    
    public static func border(_ color: UIColor, width: CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.borderColor = color.cgColor
            targetState.borderWidth = width
        }
    }
    
    public static func shadowColor(_ shadowColor: UIColor) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.shadowColor = shadowColor.cgColor
        }
    }
    
    public static func shadowOpacity(_ shadowOpacity: CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    public static func shadowOffset(_ shadowOffset: CGSize) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.shadowOffset = shadowOffset
        }
    }
    
    public static func shadowRadius(_ shadowRadius: CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.shadowRadius = shadowRadius
        }
    }
    
    public static func shadow(_ color: UIColor, opacity: CGFloat, radius: CGFloat = 6, offset: CGSize = .zero) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.shadowColor = color.cgColor
            targetState.shadowOpacity = Float(opacity)
            targetState.shadowRadius = radius
            targetState.shadowOffset = offset
        }
    }
    
    public static func defaultShadow() -> DawnModifier {
        return DawnModifier { targetState in
            targetState.shadowColor = UIColor.black.cgColor
            targetState.shadowOpacity = Float(0.08)
            targetState.shadowRadius = 8
            targetState.shadowOffset = .zero
        }
    }
    
    public static func overlay(color: UIColor, opacity: CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.overlay = (color, opacity)
        }
    }
    
    public static func blurOverlay(_ effect: DawnTargetState.BlurEffect, opacity: CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.blurOverlay = (effect, opacity)
        }
    }
}
