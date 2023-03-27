//
//  MAWrapTagView.swift
//  Lento
//
//  Created by zhang on 2023/3/4.
//

import UIKit
import AmassingUI

@objc open class LentoBaseView1: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
        layoutInitialization()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitialization()
        layoutInitialization()
    }
    
    @objc open func commonInitialization() {
        // Initialize subviews
    }
    
    @objc open func layoutInitialization() {
        // Configure the view layout
    }
}

class MAWrapTagView: LentoBaseView1 {

    var almentView: MATagContainerView!
    var tagLable1: MALabel!
    var tagLable2: UILabel!
    var tagLable3: UILabel!

    override func commonInitialization() {
        almentView = MATagContainerView()
        almentView.horizontalSpacing = 10
        almentView.verticalSpacing = 10
        almentView.preparedMaxLayoutWidth = UIScreen.main.bounds.width-20
        almentView.contentEdgeInsets = .zero
        almentView.baselineArrangement = .bottom
        almentView.backgroundColor = .blue
        addSubview(almentView)
    }
    
    override func layoutInitialization() {
        almentView.didIntrinsicSizeChanged = { [weak self] (_, newSize) in
            self?.almentView.snp.updateConstraints({ make in
                make.width.greaterThanOrEqualTo(newSize.width)
                make.height.equalTo(newSize.height)
            })
        }
    }
    
    func dadatUpdates(_ index: Int) {
        almentView.removeAllArrangedSubviews()
        
        tagLable1 = MALabel()
        tagLable1.font = .appFont()
        tagLable1.textColor = .white
        tagLable1.backgroundColor = .brown
        tagLable1.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        almentView.addArrangedSubview(tagLable1)
        
        tagLable2 = UILabel()
        tagLable2.font = .appFont()
        tagLable2.textColor = .white
        tagLable2.backgroundColor = .brown
        almentView.addArrangedSubview(tagLable2)
        
        tagLable3 = UILabel()
        tagLable3.font = .appFont()
        tagLable3.textColor = .white
        tagLable3.backgroundColor = .brown
        almentView.addArrangedSubview(tagLable3)
        
        tagLable1.text = index.isOdd ? "鲜芋i来上方" : "89历史的肯定是对的"
        tagLable2.text = index.isOdd ? "taglable2块口连1乐" : "ijk"
        tagLable3.text = index.isOdd ? "hah😄长测试2⃣️乐": "单"
                
        let _siz = almentView.takeIntrinsicSize()
        almentView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(_siz.width)
            make.height.equalTo(_siz.height)
        }
    }
}
