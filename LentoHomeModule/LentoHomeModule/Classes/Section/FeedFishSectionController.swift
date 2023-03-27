//
//  FeedFishSectionController.swift
//  Lento
//
//  Created by corgi on 2022/9/9.
//

import UIKit
import IGListKit

final class FeedFishSectionController: ListSectionController {

    var model: FeedModel?
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let model = model else {
            return .zero
        }
        return CGSize(width: collectionContext!.containerSize.width, height:FeedFishCell.height(with: model))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: FeedFishCell.self, for: self, at: index) as? FeedFishCell else {
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
        
        let vc = LentoFishViewController()
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
