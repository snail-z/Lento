//
//  AlipageLagerImageController.swift
//  Lento
//
//  Created by zhang on 2023/6/30.
//

import UIKit
import LentoBaseKit

class AlipageLagerImageController: LentoBaseViewController {

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
        lagerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(targetSize.width)
            make.height.equalTo(targetSize.height)
        }
        
        lagerImageView.addTapGesture { [weak self] _ in
            self?.view.tag = 2011
            self?.dismiss(animated: true)
        }
        
        //手势监听器
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture(_:)))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
    }
}

extension AlipageLagerImageController {
    
    @objc func edgePanGesture(_ gr: UIScreenEdgePanGestureRecognizer) {
        let translation = gr.translation(in: self.view).x
        let distance = translation / (view.bounds.width)
        switch gr.state {
        case .began:
            Dawn.shared.driven(dismissing: self)
            dismiss(animated: true)
        case .changed:
            Dawn.shared.update(distance)
        default:
            let velocity = gr.velocity(in: view)
            if ((translation + velocity.x) / view.bounds.width) > 0.5 {
                Dawn.shared.finish()
            } else {
                Dawn.shared.cancel()
            }
        }
    }
}
