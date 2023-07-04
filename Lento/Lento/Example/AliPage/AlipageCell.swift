//
//  AlipageCell.swift
//  Lento
//
//  Created by zhang on 2023/6/30.
//

import UIKit
import LentoBaseKit

struct AlipageModel {
    
    var image: UIImage?
    var imgName: String?
    var title: String?
    
    init(name: String = "image0", tit: String = "title", imag: UIImage? = nil) {
        imgName = name
        title = tit
        image = imag
    }
    
    func takeImage() -> UIImage {
        if let img = image {
            return img
        } else if let name = imgName {
            return UIImage(named: name) ?? UIImage(named: "image0")!
        } else {
            return UIImage(named: "image0")!
        }
    }
}

class AlipageCell: LentoBaseCollectionCell {
    
    var model: AlipageModel? {
        didSet { dataUpdates() }
    }
    
    var bgImageView: UIImageView!
    
    override func commonInitialization() {
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        bgImageView = UIImageView()
        bgImageView.clipsToBounds = true
        contentView.addSubview(bgImageView)
    }
    
    override func layoutInitialization() {
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func dataUpdates() {
        bgImageView.image = model?.takeImage()
    }
}
