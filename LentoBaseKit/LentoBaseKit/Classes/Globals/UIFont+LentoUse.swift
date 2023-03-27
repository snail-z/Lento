//
//  UIFont+LentoUse.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//

import UIKit

public extension UIFont {
    
    static func gillSans(_ fontSize: CGFloat = 18) -> UIFont? {
        return UIFont.fontName(.avenir, style: .blackOblique, size: fontSize)
    }
    
    static func appFont(_ fontSize: CGFloat = 16) -> UIFont? {
        return UIFont.fontName(.pingFangSC, style: .regular, size: fontSize)
    }
    
    static func appFont(_ fontSize: CGFloat = 16, style: FontStyle = .normal) -> UIFont? {
        return UIFont.fontName(.pingFangSC, style: style, size: fontSize)
    }
    
    static func pingFang(_ fontSize: CGFloat = 18) -> UIFont? {
        return UIFont.fontName(.pingFangSC, style: .light, size: fontSize)
    }
}
