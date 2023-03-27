//
//  MALeftAlignedConst.swift
//  Lento
//
//  Created by zhang on 2022/10/24.
//

import UIKit
import AmassingExtensions

public struct MALeftAlignedConst {
    
    static let headerReferenceHeight: CGFloat = 30
    static let paddingLeft: CGFloat = 16
    static let paddingRight: CGFloat = 30
    static let itemSpacing: CGFloat = 8
    static let lineSpacing: CGFloat = 10
    static let itemHeight: CGFloat = 40
    static let normalHeight: CGFloat = 55
    
    static let itemInsetLeft: CGFloat = 10
    static let itemInsetRight: CGFloat = 10
    static let itemTextFont: UIFont? = .appFont(14)

    static let distribution = CGHorizontalEquantLayout1(count: 4, leadSpacing: paddingLeft, tailSpacing: paddingRight)
    static let minimumItemWidth = distribution.equalWidthThatFits(itemSpacing)
    static var maximumItemWidth = distribution.maxLayoutWidth - distribution.leadSpacing - distribution.tailSpacing
    
    static func minimumLineSpacing(with group: MALeftAlignedGroup?) -> CGFloat {
        guard let type = group?.type else { return .zero }
        switch type {
        case .normalList: return .zero
        default: return lineSpacing
        }
    }
    
    static func sectionInset(with group: MALeftAlignedGroup?) -> UIEdgeInsets {
        guard let type = group?.type else { return .zero }
        switch type {
        case .histories:
            return UIEdgeInsets(top: 15, left: distribution.leadSpacing, bottom: 15, right: distribution.tailSpacing)
        case .hotList:
            return UIEdgeInsets(top: 15, left: distribution.leadSpacing, bottom: 40, right: distribution.tailSpacing)
        default:
            return .zero
        }
    }
    
    static func itemLayoutSize(with group: MALeftAlignedGroup?, at indexPath: IndexPath) -> CGSize {
        guard let type = group?.type else { return .zero }
        switch type {
        case .location:
            return CGSize(width: distribution.maxLayoutWidth, height: 60)
        case .histories, .hotList:
            let item = group!.items?[indexPath.item]
            return itemSize(with: item)
        case .normalList:
            return CGSize(width: distribution.maxLayoutWidth, height: normalHeight)
        default:
            return .zero
        }
    }
    
    private static func itemSize(with item: MALeftAlignedItem?) -> CGSize {
        guard let name = item?.cityName else { return .zero }
        let maxsize = CGSize(width: maximumItemWidth, height: itemHeight)
        var size = name.boundingSize(with: maxsize, font: itemTextFont)
        let insetHorizontal = itemInsetLeft + itemInsetRight
        if size.width < minimumItemWidth - insetHorizontal {
            size.width = minimumItemWidth
        } else {
            size.width = ceil(size.width) + insetHorizontal
        }
        size.width = min(maximumItemWidth, size.width)
        return CGSize(width: size.width, height: itemHeight)
    }
}
