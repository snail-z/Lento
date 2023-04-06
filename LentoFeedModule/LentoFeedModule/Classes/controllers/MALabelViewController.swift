//
//  MALabelViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/18.
//

import Foundation
import AmassingUI
import LentoBaseKit

public class MALabelViewController: LentoBaseViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        commonInitialization()
        layoutInitialization()
        dataUpdates()
    }
    
    var stackView: UIStackView!
    var bgstackView: UIView!
    var tagStackView: MATagContainerView!
    var tagLable1: UILabel!
    var tagLable2: UILabel!
    
    func commonInitialization() {
        bgstackView = UIView()
        bgstackView.backgroundColor = .yellow
        view.addSubview(bgstackView)
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        tagLable1 = UILabel()
        tagLable1.font = .appFont()
        tagLable1.textColor = .white
        tagLable1.backgroundColor = .brown
        stackView.addArrangedSubview(tagLable1)
        
        tagStackView = MATagContainerView()
        tagStackView.backgroundColor = .lightGray
        tagStackView.horizontalSpacing = 10
        tagStackView.verticalSpacing = 20
        tagStackView.preparedMaxLayoutWidth = UIScreen.main.bounds.width - 40
        stackView.addArrangedSubview(tagStackView)
        
        tagLable2 = UILabel()
        tagLable2.font = .appFont()
        tagLable2.textColor = .white
        tagLable2.backgroundColor = .brown
        stackView.addArrangedSubview(tagLable2)
        
        bgstackView.snp.makeConstraints { make in
            let exp: CGFloat = 5
            make.top.equalTo(stackView.snp.top).offset(-exp)
            make.left.equalTo(stackView.snp.left).offset(-exp)
            make.bottom.equalTo(stackView.snp.bottom).offset(exp)
            make.right.equalTo(stackView.snp.right).offset(exp)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(100)
        }
        
        let temps = ["hu", "哈哈哈哈啊😄阿莱克哈苏地方", "表便签吧啊～", "666666表吧啊～", "IJkk签吧啊"]
        setTagChildViews(temps)
        
        stringTest1()
    }
    
    func codePointCount() -> Int {
        return 30
    }
    
    func stringTest1() {
        let value1 = "hu😄👨‍👩‍👦‍👦啊"
        let value2 = "全是中文"
        
        let nsValue1 = value1.toNSString()
        let nsValue2 = value2.toNSString()
        
        let ds = nsValue1.rangeOfCodePoint(start: 0, end: 2)
        
        print("====> \(value1.unicodeScalars.count)")
    }
    
    func setTagChildViews(_ temps: [String]) {
        tagStackView.removeAllArrangedSubviews()
        for text in temps {
            let label1 = UILabel()
            label1.font = .appFont()
            label1.textColor = .white
            label1.backgroundColor = .random()
            label1.text = text
            tagStackView.addArrangedSubview(label1)
        }
    }
    
    func layoutInitialization() {
        self.tagLable2.text = "tagLable2-stackView"
        DispatchQueue.asyncAfter(delay: 1) {
            self.tagLable1.text = "哈哈500"
        }
        
        DispatchQueue.asyncAfter(delay: 2) {
            let temps = ["666克哈苏地方", "～", "说了的看法IJk吧啊"]
            self.setTagChildViews(temps)
        }
    }
    
    func dataUpdates() {
        
    }
}

/*
 private var lable1: MALabel!
 private var lable2: MALabel!
 private var lable3: MALabel!
 private var lable4: MALabel!
 private var lable5: MALabel!
 
 override func viewDidLoad() {
     super.viewDidLoad()
     commonInitialization()
     layoutInitialization()
     dataUpdates()
 }
 
 func makeLabel() -> MALabel {
     let lable = MALabel()
     lable.textColor = .white
     lable.numberOfLines = 0
     lable.font = UIFont.appFont()
     lable.backgroundColor = .appBlue(1)
     return lable
 }
 
 func commonInitialization() {
     lable1 = makeLabel()
     view.addSubview(lable1)
     
     lable2 = makeLabel()
     lable2.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
     view.addSubview(lable2)
     
     lable3 = makeLabel()
     lable3.textAlignment = .center
     view.addSubview(lable3)
     
     lable4 = makeLabel()
     lable4.contentVerticalAlignment = .top
     view.addSubview(lable4)
     
     lable5 = makeLabel()
     lable5.contentVerticalAlignment = .bottom
     lable5.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
     view.addSubview(lable5)
 }
 
 func layoutInitialization() {
     lable1.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(50)
     }
     
     lable2.snp.makeConstraints { make in
         make.top.equalTo(lable1.snp.bottom).offset(20)
         make.centerX.equalToSuperview()
     }
     
     lable3.snp.makeConstraints { make in
         make.top.equalTo(lable2.snp.bottom).offset(20)
         make.left.equalTo(60)
         make.right.equalToSuperview().inset(60)
         make.height.equalTo(120)
     }
     
     lable4.snp.makeConstraints { make in
         make.top.equalTo(lable3.snp.bottom).offset(20)
         make.left.equalTo(60)
         make.right.equalToSuperview().inset(60)
         make.height.equalTo(120)
     }
     
     lable5.snp.makeConstraints { make in
         make.top.equalTo(lable4.snp.bottom).offset(20)
         make.left.equalTo(60)
         make.right.equalToSuperview().inset(60)
         make.height.equalTo(120)
     }
 }
 
 func dataUpdates() {
     lable1.text = "自适应标题"
     lable2.text = "自适应标题并设置内间距"
     lable3.text = "约束宽高，内容会默认在竖直方向居中显示"
     lable4.text = "约束宽高，让内容居顶部显示"
     lable5.text = "约束宽高，让内容在底部显示并设置内间距"
 }
 */
