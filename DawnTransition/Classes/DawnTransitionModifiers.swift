//
//  DawnTransitionModifiers.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/12.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2022 snail-z <haozhang0770@163.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

public class DawnModifierStage {
    
    var fromViewBeginModifiers: [DawnModifier]?
    var fromViewEndModifiers: [DawnModifier]?
    
    var toViewBeginModifiers: [DawnModifier]?
    var toViewEndModifiers: [DawnModifier]?
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
    public var blurOverlay: (effect: BlurEffect, opacity: Float)?
    public var overlay: (color: UIColor, opacity: Float)?
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
    internal init(applyFunction:@escaping (inout DawnTargetState) -> Void) {
        apply = applyFunction
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
            targetState.position = .any(x: UIScreen.main.bounds.width * 0.5 + offset,
                                        y: UIScreen.main.bounds.height * 0.5)
        }
    }
    
    public static func position(vertical offset : CGFloat) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.position = .any(x: UIScreen.main.bounds.width * 0.5,
                                        y: UIScreen.main.bounds.height * 0.5 + offset)
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
    
    public static func overlay(color: UIColor, opacity: Float) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.overlay = (color, opacity)
        }
    }
    
    public static func blurOverlay(_ effect: DawnTargetState.BlurEffect, opacity: Float) -> DawnModifier {
        return DawnModifier { targetState in
            targetState.blurOverlay = (effect, opacity)
        }
    }
}

extension DawnModifier {
    
    /// 自定义CATransform3D变换
    public static func transform(_ t: CATransform3D) -> DawnModifier {
      return DawnModifier { targetState in
          targetState.transform = t
      }
    }
    
    /// 还原CATransform3D变换
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
