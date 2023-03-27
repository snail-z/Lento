//
//  FontLibrariesCell.swift
//  Lento
//
//  Created by zhang on 2022/10/20.
//

import UIKit
import AmassingUI
import LentoBaseKit

class FontLibrariesHeaderView: LentoBaseView {
    
    public var title: String? {
        didSet {
            dataUpdates()
        }
    }
    
    private var titleLabel: UILabel!
    
    override func commonInitialization() {
        backgroundColor = .colorFAFAFA
        
        titleLabel = UILabel()
        titleLabel.font = .appFont()
        titleLabel.textColor = .appBlue()
        addSubview(titleLabel)
    }
    
    override func layoutInitialization() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }

    private func dataUpdates() {
        titleLabel.text = title
    }
}

class FontLibrariesCell: LentoBaseTableViewCell {
    
    public var title: String? {
        didSet {
            dataUpdates()
        }
    }
    
    public var hasLine: Bool = true {
        didSet {
            line.isHidden = !hasLine
        }
    }
    
    private var titleLabel: UILabel!
    private var line: MAGradientView!
    
    override func commonInitialization() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        line = MAGradientView()
        line.gradientClolors = [UIColor.appBlue(0.5), .appBlue(0.1)]
        line.gradientDirection = .leftToRight
        contentView.addSubview(line)
    }
    
    override func layoutInitialization() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalToSuperview().inset(40)
            make.top.equalTo(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        line.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
            make.height.equalTo(1/UIScreen.main.scale)
        }
    }
    
    private func dataUpdates() {
        titleLabel.attributedText = takeAttribText(with: title ?? "")
    }
    
    func dataUpdates2(_ tit: String?, index: Int) {
        titleLabel.attributedText = take22AttribText(with: tit ?? "", index: index)
    }
    
    private func take22AttribText(with name: String, index: Int) -> NSAttributedString {
        let normalFont = UIFont(name: name, size: 17)
        let largeFont = UIFont(name: name, size: 19)
        
        let mutableAttrib = NSMutableAttributedString()
        
        let numberAttrib = NSMutableAttributedString(string: "\(index)--秋天到了离开宗角禄康德弗里斯克己复礼都快结束了快捷的方式来打开肌肤")
        numberAttrib.foregroundColor(.black).font(normalFont)
        mutableAttrib.append(numberAttrib)

        let mailAttrib = NSMutableAttributedString(string: "\n一个字删掉了福克斯的方式德累斯顿疯狂三闾大夫i是的呢haozhang0770@163.com\n")
        mailAttrib.foregroundColor(.black).font(normalFont)
        mutableAttrib.append(mailAttrib)

        let nameAttrib = NSMutableAttributedString(string: name)
        nameAttrib.foregroundColor(.appBlue()).font(largeFont)
        mutableAttrib.append(nameAttrib)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment(.left).lineSpacing(7)
        mutableAttrib.paragraphStyle(paragraphStyle)
        return mutableAttrib
    }
    
    private func takeAttribText(with name: String) -> NSAttributedString {
        let normalFont = UIFont(name: name, size: 37)
        let largeFont = UIFont(name: name, size: 39)
        
        let mutableAttrib = NSMutableAttributedString()
        let numberAttrib = NSMutableAttributedString(string: "正心  \n正心\nZhengXin\n12345.67890")
        numberAttrib.foregroundColor(.black).font(normalFont)
        mutableAttrib.append(numberAttrib)

        let mailAttrib = NSMutableAttributedString(string: "\n邮箱：haozhang0770@163.com\n")
        mailAttrib.foregroundColor(.black).font(normalFont)
        mutableAttrib.append(mailAttrib)

        let nameAttrib = NSMutableAttributedString(string: name)
        nameAttrib.foregroundColor(.appBlue()).font(largeFont)
        mutableAttrib.append(nameAttrib)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment(.left).lineSpacing(7)
        mutableAttrib.paragraphStyle(paragraphStyle)
        return mutableAttrib
    }
}
