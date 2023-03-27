//
//  FeedModel.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//

import UIKit
import IGListKit
import LentoBaseKit

enum StructureType: Int {
    case none = -1      // 暂无
    case noMore = -2    // 没有更多
     
    case feedAd = 3 // 广告
    case fish = 4 // 多抓鱼
}

open class FeedModel: NSObject {

    public var noteId: Int = 0
    
    public var title: String = ""
    
    public var content: String = ""
    
    var structureType: StructureType = .none
    
    
    public var boundaryHeight: CGFloat {
        var height = title.boundingHeight(with: kGeneralLayoutMaxWidth, font: .pingFang(20))
        height += content.boundingHeight(with: kGeneralLayoutMaxWidth, font: .pingFang(12))
        height += (20 + 15 + 20)
        return height
    }
}

extension FeedModel: ListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let obj = object as? FeedModel else { return false }
        return self === obj // 判断两个实例类类型(class type)是否相同
    }
}

