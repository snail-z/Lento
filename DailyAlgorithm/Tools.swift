//
//  Tools.swift
//  DailyAlgorithm
//
//  Created by zhang on 2023/12/19.
//

import UIKit

public extension String {
    
    /// 将String转NSString
    func toNSString() -> NSString {
        return self as NSString
    }
    
    /// 获取字符串尺寸 (约束最大布局尺寸)
    func boundingSize(constraint size: CGSize, attributes: [NSAttributedString.Key: Any]?) -> CGSize {
        let size = toNSString().boundingRect(
            with: size,
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: attributes, context: nil
        ).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    /// 获取字符串尺寸 (设置字体、行高、省略模式)
    func boundingSize(constraint size: CGSize, font: UIFont!) -> CGSize {
        let fontValue = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: fontValue]
        return boundingSize(constraint: size, attributes: attributes)
    }
    
    /// 获取字符串宽度 (约束高度)
    func boundingWidth(constraint height: CGFloat, attributes: [NSAttributedString.Key: Any]?) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)
        return boundingSize(constraint: size, attributes: attributes).width
    }
    
    /// 获取字符串宽度 (约束高度)
    func boundingWidth(constraint height: CGFloat, font: UIFont!) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)
        return boundingSize(constraint: size, font: font).width
    }
    
    /// 获取字符串高度 (约束宽度)
    func boundingHeight(constraint width: CGFloat, attributes: [NSAttributedString.Key: Any]?) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        return boundingSize(constraint: size, attributes: attributes).height
    }
    
    /// 获取字符串高度 (约束宽度)
    func boundingHeight(constraint width: CGFloat, font: UIFont!) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        return boundingSize(constraint: size, font: font).height
    }
}
