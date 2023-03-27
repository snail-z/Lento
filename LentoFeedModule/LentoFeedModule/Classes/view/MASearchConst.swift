//
//  MASearchConst.swift
//  Lento
//
//  Created by zhang on 2022/10/27.
//

import UIKit

public struct MASearchConst {

    static let headerReferenceHeight: CGFloat = 35
    static let paddingLeft: CGFloat = 16
    static let paddingRight: CGFloat = 16
    
    static let itemHeight: CGFloat = 38
    static let itemInsetLeft: CGFloat = 15
    static let itemInsetRight: CGFloat = 15
    static let itemTextFont: UIFont? = .appFont(13)
    static let itemSpacing: CGFloat = 15
    static let lineSpacing: CGFloat = 10
    
    static let hotIconSize: CGSize = CGSize(width: 14, height: 16)
    static let hotAndTextSpacing: CGFloat = 6
    
    static let deleIconSize = CGSize(width: 8, height: 8)
    static let deleAndTextSpacing: CGFloat = 10
 
    static let boundsWidth = UIScreen.main.bounds.width
    
    static let topPageSize = CGSize(width: 260, height: MASearchPagesCellConst.contentHeight)
    static let tapPageSpacing: CGFloat = 20
    
    static let minimumItemWidth: CGFloat = 30
    static let maximumItemWidth: CGFloat = boundsWidth - paddingLeft - paddingRight
}

extension MASearchConst {
    
    static func headerReferenceSize(with group: MASearchGroup?) -> CGSize {
        guard let type = group?.type else { return .zero }
        switch type {
        case .histories, .discover:
            return CGSize(width: boundsWidth, height: MASearchConst.headerReferenceHeight)
        default: return .zero
        }
    }
    
    static func sectionInset(with group: MASearchGroup?) -> UIEdgeInsets {
        guard let type = group?.type else { return .zero }
        switch type {
        case .histories, .discover:
            return UIEdgeInsets(top: 10, left: paddingLeft, bottom: 10, right: paddingRight)
        case .topList:
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        default:
            return .zero
        }
    }
    
    static func itemLayoutSize(with group: MASearchGroup?, at indexPath: IndexPath) -> CGSize {
        guard let type = group?.type else { return .zero }
        switch type {
        case .histories:
            guard let list = group?.historiesList, !list.isEmpty else {
                return CGSize(width: maximumItemWidth, height: itemHeight)
            }
            return historiesItemSize(with: list[indexPath.item])
        case .discover:
            return itemSize(with: group?.discoverList?[indexPath.item])
        default:
            return CGSize(width: boundsWidth, height: topPageSize.height)
        }
    }
    
    private static func itemSize(with item: MASearchLeftItem?) -> CGSize {
        var size = textWidth(item?.name)
        let hotIsBlank = item?.hot?.isBlank ?? true
        size.width =  size.width + (hotIsBlank ? 0 : hotIconSize.width + hotAndTextSpacing)
        size.width = max(minimumItemWidth, size.width)
        size.width = min(maximumItemWidth, size.width)
        return CGSize(width: size.width, height: itemHeight)
    }
    
    private static func historiesItemSize(with item: MASearchHistoryItem?) -> CGSize {
        var size = textWidth(item?.name)
        size.width =  size.width + deleAndTextSpacing + deleIconSize.width
        size.width = max(minimumItemWidth, size.width)
        size.width = min(maximumItemWidth, size.width)
        return CGSize(width: size.width, height: itemHeight)
    }
    
    private static func textWidth(_ text: String?) -> CGSize {
        guard let name = text else { return .zero }
        let maxsize = CGSize(width: maximumItemWidth, height: itemHeight)
        var size = name.boundingSize(with: maxsize, font: itemTextFont)
        size.width = ceil(size.width) + itemInsetLeft + itemInsetRight
        return size
    }
}
 
public struct MASearchPagesCellConst {

    static let topPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 15
    static let titleHeight: CGFloat = 35
    static let cellSpacing: CGFloat = 0
    static let cellHeight: CGFloat = 40
    static let topCount: Int = 10
}

extension MASearchPagesCellConst {
    
    static var contentHeight: CGFloat {
        var height = topPadding
        height += titleHeight
        height += cellSpacing * CGFloat(topCount - 1)
        height += cellHeight * CGFloat(topCount)
        height += bottomPadding
        return height
    }
}
