//
//  LentoBaseViewCell.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//

import UIKit

@objc open class LentoBaseTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .white
        commonInitialization()
        layoutInitialization()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitialization()
        layoutInitialization()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @objc open func commonInitialization() {
        // Initialize subviews
    }
    
    @objc open func layoutInitialization() {
        // Configure the view layout
    }
}

@objc open class LentoBaseCollectionCell: UICollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        commonInitialization()
        layoutInitialization()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitialization()
        layoutInitialization()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @objc open func commonInitialization() {
        // Initialize subviews
    }
    
    @objc open func layoutInitialization() {
        // Configure the view layout
    }
}
