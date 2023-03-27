//
//  MAWaterfallCell.swift
//  Lento
//
//  Created by zhang on 2022/10/19.
//

import UIKit
import LentoBaseKit

class MAWaterfallCell: LentoBaseCollectionCell {
    
    public private(set) var imageView: UIImageView!
    
    override func commonInitialization() {
        imageView = UIImageView()
        imageView.backgroundColor = .orange
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        contentView.backgroundColor = .colorFBFBFB
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
    }
    
    override func layoutInitialization() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
