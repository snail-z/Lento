//
//  ALGTableViewCell.swift
//  DailyAlgorithm
//
//  Created by zhang on 2023/12/19.
//

import UIKit

class ALGTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var messageLabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = ALGTableViewCell.titleFont()
        label.numberOfLines = .zero
        return label
    }()
    
    lazy var lineView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return lineView
    }()
    
    func setup() {
        contentView.addSubview(messageLabel)
        contentView.addSubview(lineView)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 1/UIScreen.main.scale)
        messageLabel.frame = CGRect(x: 15, y: 15, width: bounds.width - 30, height: bounds.height - 30)
    }
}

extension ALGTableViewCell {
    
    static func titleFont() -> UIFont {
        return UIFont(name: "pingFangSC-light", size: 18)!
    }

    static func cellHeight(title: String) -> CGFloat {
        let maxW = UIScreen.main.bounds.width - 30
        let height = title.boundingHeight(constraint: maxW, font: titleFont())
        return height + 30
    }
}
