//
//  MASearchReusableView.swift
//  Lento
//
//  Created by zhang on 2022/10/27.
//

import UIKit
import AmassingUI
import LentoBaseKit

@objc protocol MASearchHeaderViewDelegate {

    @objc optional func headerViewDidClearHistories(_ headerView: MASearchHeaderView)
}

class MASearchHeaderView: LentoBaseReusableView {
    
    public weak var delegate: MASearchHeaderViewDelegate?
    
    public var group: MASearchGroup? {
        didSet { dataUpdates() }
    }
    
    private var titleLabel: UILabel!
    private var deleteView: MAButton!
    
    override func commonInitialization() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = .appFont(17, style: .semiBold)
        titleLabel.textColor = .black
        addSubview(titleLabel)
        
        deleteView = MAButton()
        deleteView.titleLabel.isHidden = true
        deleteView.imageView.image = UIImage(named: "delete")
        deleteView.touchResponseInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        deleteView.addGestureRecognizer(UITapGestureRecognizer.action.gestureClosure({ [weak self] _ in
            guard let `self` = self else { return }
            self.delegate?.headerViewDidClearHistories?(self)
        }))
        addSubview(deleteView)
    }
    
    override func layoutInitialization() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(MALeftAlignedConst.paddingLeft)
            make.top.bottom.equalToSuperview()
        }
        
        deleteView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(MASearchConst.paddingRight)
            make.width.equalTo(20)
            make.height.equalTo(18)
        }
    }
    
    private func dataUpdates() {
        guard let `group` = group else { return }
        titleLabel.text = group.title
        if group.type == .histories {
            deleteView.isHidden = group.historiesList?.isEmpty ?? true
        } else {
            deleteView.isHidden = true
        }
    }
}
