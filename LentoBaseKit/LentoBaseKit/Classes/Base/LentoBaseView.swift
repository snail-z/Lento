//  LentoBaseView.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//

import UIKit

@objc open class LentoBaseView: UIView {
    
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

@objc open class LentoBaseReusableView: UICollectionReusableView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
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

@objc open class LentoBaseHeaderFooterView: UITableViewHeaderFooterView {
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
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

@objc open class LentoTableView: UITableView {
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .white
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = .zero
        } else {
            // Fallback on earlier versions
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
