//
//  FeedAdSectionController.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//

import UIKit
import IGListKit
import AmassingExtensions

final class FeedAdSectionController: ListSectionController {

    var model: FeedModel?
    
    override func numberOfItems() -> Int {
        return 5
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let model = model else {
            return .zero
        }
        return CGSize(width: collectionContext!.containerSize.width, height:FeedAdCell.height(with: model))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: FeedAdCell.self, for: self, at: index) as? FeedAdCell else {
            return UICollectionViewCell()
        }
        cell.contentView.backgroundColor = UIColor.random()
        cell.model = model
        return cell
    }
    
    override func didUpdate(to object: Any) {
        model = object as? FeedModel
        print("didUpdate is: \(object)")
    }
    
    override func didSelectItem(at index: Int) {
        print("index is: \(index)")
    }
}
