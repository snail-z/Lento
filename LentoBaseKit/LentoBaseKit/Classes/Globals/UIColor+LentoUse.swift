//
//  UIColor+LentoUse.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//
//

import UIKit

// Debug
public extension UIColor {
    
    static var debugColorRed: UIColor {
        return .debugColor(.red)
    }
    
    static var debugColorYellow: UIColor {
        
        return .yellow
    }
    
    static var debugColorGreen: UIColor {
        return .green
    }
    
    static var debugColorBlue: UIColor {
        return .blue
    }
    
    static var debugColorGray: UIColor {
        return .gray
    }
    
    static var debugColorDarkGray: UIColor {
        return .darkGray
    }
    
    static var debugColorRandom: UIColor {
        return .debugColor(.random())
    }
    
    static func appBlue(_ alpha: CGFloat = 1) -> UIColor {
        return UIColor.systemBlue.withAlphaComponent(alpha)
    }
}


public extension UIColor {
    
    static var color666666: UIColor {
        return UIColor.hex(0x666666)
    }
    
    static var color333333: UIColor {
        return UIColor.hex(0x333333)
    }
    
    static var color999999: UIColor {
        return UIColor.hex(0x999999)
    }
    
    static var colorF9F9F9: UIColor {
        return UIColor.hex(0xF9F9F9)
    }
    
    static var colorEEEEEE: UIColor {
        return UIColor.hex(0xEEEEEE)
    }
    
    static var colorFAFAFA: UIColor {
        return UIColor.hex(0xFAFAFA)
    }
    
    static var colorFBFBFB: UIColor {
        return UIColor.hex(0xFBFBFB)
    }
    
    static var colorF5F5F5: UIColor {
        return UIColor.hex(0xF5F5F5)
    }
}
