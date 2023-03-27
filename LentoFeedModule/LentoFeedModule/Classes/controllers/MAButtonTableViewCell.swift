//
//  MAButtonTableViewCell.swift
//  Lento
//
//  Created by zhang on 2023/2/25.
//

import UIKit
import LentoBaseKit

class MAButtonTableViewCell: LentoBaseTableViewCell {

    var titleLabel: UILabel!
    var stackView: UIStackView!
    var stackBG: UIView!
    var descLabel: UILabel!
    var seplitLine: UIView!
    
    var item1Label: UILabel!
    var item2Label: UILabel!
    var wrapView: MAWrapTagView!
    
    override func commonInitialization() {
        titleLabel = UILabel()
        titleLabel.font = .appFont()
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .orange
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        contentView.addSubview(stackView)
        
        stackBG = UIView()
        stackBG.backgroundColor = .yellow
        contentView.insertSubview(stackBG, belowSubview: stackView)
        
        descLabel = UILabel()
        descLabel.font = .appFont()
        descLabel.textColor = .white
        descLabel.backgroundColor = .systemPink
        descLabel.numberOfLines = 0
        contentView.addSubview(descLabel)
        
        seplitLine = UIView()
        seplitLine.backgroundColor = .red
        contentView.addSubview(seplitLine)
        
        setStackChildViews()
    }
    
    func setStackChildViews() {
        item1Label = UILabel()
        item1Label.font = .appFont()
        item1Label.textColor = .white
        item1Label.backgroundColor = .purple
        item1Label.numberOfLines = 0
        stackView.addArrangedSubview(item1Label)
        
        wrapView = MAWrapTagView()
        wrapView.backgroundColor = .yellow
        stackView .addArrangedSubview(wrapView)
        
        item2Label = UILabel()
        item2Label.font = .appFont()
        item2Label.textColor = .white
        item2Label.backgroundColor = .purple
        item2Label.numberOfLines = 0
        stackView.addArrangedSubview(item2Label)
    }
    
    override func layoutInitialization() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.greaterThanOrEqualTo(22)
            make.top.equalTo(10)
        }
        
        stackBG.snp.makeConstraints { make in
            let exp: CGFloat = 5
            make.top.equalTo(stackView.snp.top).offset(-exp)
            make.left.equalTo(stackView.snp.left).offset(-exp)
            make.bottom.equalTo(stackView.snp.bottom).offset(exp)
            make.right.equalTo(stackView.snp.right).offset(exp)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.bottom.equalTo(-30)
        }
        
        seplitLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1.5)
        }
    }
    
    func dataUpdates(_ index: Int) {
        if index.isEven {
            titleLabel.text = "-我是单行标题"
        } else {
            titleLabel.text = "-标题记录变量lastTimestamp首次为0，判断当前果你的体脂率在标准范围内，女生的体脂率是20%～25%，男生体脂率15%～18%。则可以直接做肌肉训练，跳过减脂这个过程"
        }
        
        item1Label.text = "wo 是item1label"
        item2Label.text = "item2Label ah哈哈哈成年男性的体脂率计算公式：\n参数a=腰围（cm）×0.74"
        descLabel.text = "desclabel"
        item1Label.isHidden = index.isOdd
        
        wrapView.isHidden = index.isEven
        wrapView.dadatUpdates(index)
    }
}
