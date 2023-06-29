//
//  DawnTest1ViewController.swift
//  Lento
//
//  Created by zhang on 2023/6/9.
//

import UIKit
import LentoBaseKit

/**
 /// 苹果商店toady样式
 case today
 /// 摘要精华区样式
 case digest
 */
class WrapVView: LentoBaseView {
    
    var imgView: UIImageView!
    var titleLabel: UILabel!
    
    override func commonInitialization() {
        imgView = UIImageView.init(image: UIImage.init(named: "img_2"))
        imgView.backgroundColor = .yellow
        addSubview(imgView)
        
        titleLabel = UILabel()
        titleLabel.font = .pingFang(15)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.text = "原神：开放世界的探险\n五星元素的玩也同样是使用单手剑冰留下了流风秋叶的领域"
        addSubview(titleLabel)
    }
    
    override func layoutInitialization() {
        imgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.67)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(imgView.snp.bottom).offset(10)
        }
    }
}

class DawnTest1ViewController: UIViewController {
    
    var avView: UIView!
    var wrapView: WrapVView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hex(0xEEEEEE)
        // Do any additional setup after loading the view.
        
        avView = UIView()
        avView.backgroundColor = .yellow
        view.addSubview(avView)
        avView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalTo(100)
        }
        avView.addTapGesture { [weak self] _ in
            self?.jumped()
        }
        
        wrapView = WrapVView()
        wrapView.backgroundColor = .white
        wrapView.layer.cornerRadius = 10
        wrapView.layer.masksToBounds = true
        view.addSubview(wrapView)
        wrapView.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(280)
            make.top.equalTo(350)
            make.right.equalToSuperview().inset(15)
        }
        wrapView.addTapGesture { [weak self] _ in
            self?.jumpedTwo()
        }
    }
    
    func jumped() {
        let vc = DawnTest2ViewController()
        vc.dawn.isTransitioningEnabled = true
        vc.dawn.modalAnimationType = .pageIn(direction: .left)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func jumpedTwo() {
        let vc = DawnTest3ViewController()
        vc.dawn.isTransitioningEnabled = true
        vc.dawn.transitionCapable = DawnAnimatePathway(source: self, target: vc)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension DawnTest1ViewController: DawnTransitioningAnimatePathway {
    
    func dawnAnimatePathwayView() -> UIView? {
        return wrapView
    }
}

extension DawnTest3ViewController: DawnTransitioningAnimatePathway {
    
    func dawnAnimatePathwayView() -> UIView? {
        return view
    }
}
