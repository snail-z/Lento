//
//  LagerImageController.swift
//  DawnTransition_Example
//
//  Created by zhang on 2023/8/10.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class LagerImageController: UIViewController {

    var lagerImageView: UIImageView!
    var ccimage: UIImage? {
        didSet {
            lagerImageView?.image = ccimage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lagerImageView = UIImageView()
        lagerImageView.backgroundColor = .orange
        lagerImageView.contentMode = .scaleAspectFit
        lagerImageView.image = ccimage
        view.addSubview(lagerImageView)
        view.layer.masksToBounds = true
        
        let targetSize = ccimage?.sizeOfScaled(width: view.bounds.width) ?? .zero
        lagerImageView.dw.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(targetSize.width)
            make.height.equalTo(targetSize.height)
        }
        
        lagerImageView.addTapGesture { [weak self] _ in
            self?.view.tag = 2011
            self?.dismiss(animated: true)
        }
    }
}
