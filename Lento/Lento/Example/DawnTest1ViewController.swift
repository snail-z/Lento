//
//  DawnTest1ViewController.swift
//  Lento
//
//  Created by zhang on 2023/6/9.
//

import UIKit
import LentoBaseKit

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
    
    var avView1: UILabel!
    var avView2: UILabel!
    var avView3: UILabel!
    var avView4: UILabel!
    var wrapView: WrapVView!
    var roundBG: UIView!
    var roundBtn: UIImageView!
    
    func makeLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .gillSans()
        label.textColor = .white
        label.backgroundColor = .random(.fairy)
        label.textAlignment = .center
        return label
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .hex(0xEEEEEE)
        
        avView1 = makeLabel(text: "normal")
        view.addSubview(avView1)
        avView1.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(50)
        }
        avView1.addTapGesture { [weak self] _ in
            self?.jumped()
        }
        
        avView2 = makeLabel(text: "Today")
        view.addSubview(avView2)
        avView2.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(avView1.snp.bottom).offset(20)
        }
        avView2.addTapGesture { [weak self] _ in
            self?.jumped2()
        }
        
        avView3 = makeLabel(text: "AliPage")
        view.addSubview(avView3)
        avView3.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(avView2.snp.bottom).offset(20)
        }
        avView3.addTapGesture { [weak self] _ in
            self?.jumped3()
        }
        
        avView4 = makeLabel(text: "RoundKnob")
        view.addSubview(avView4)
        avView4.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(avView3.snp.bottom).offset(20)
        }
        avView4.addTapGesture { [weak self] _ in
            self?.jumped4()
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
        
        roundBG = UIView()
        roundBG.backgroundColor = .blue
        roundBG.layer.cornerRadius = 30
        roundBG.layer.masksToBounds = true
        view.addSubview(roundBG)
        roundBG.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(5)
            make.width.height.equalTo(60)
        }
        roundBtn = UIImageView(image: UIImage(named: "plus-circle"))
        roundBtn.contentMode = .scaleAspectFit
        roundBtn.backgroundColor = .blue
        roundBG.addSubview(roundBtn)
        roundBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        roundBG.addTapGesture { [weak self] _ in
            self?.jumped5()
        }
                
        let pan = DawnPanGestureRecognizer(driver: self, type: .present) { [weak self] in
            let vc = DawnTest2ViewController()
            vc.dawn.isTransitioningEnabled = true
            vc.dawn.modalAnimationType = .pageIn(direction: .left)
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
        pan.isRecognizeWhenEdges = true
        pan.recognizeDirection = .rightToLeft
        view.dawn.addPanGestureRecognizer(pan)
    }
    
    func jumped2() {
        let vc = StoreViewController()
        vc.dawn.isTransitioningEnabled = true
        vc.dawn.modalAnimationType = .pageIn(direction: .up)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
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
    
    func jumped3() {
        let vc = AlipageViewController()
        vc.dawn.isTransitioningEnabled = true
        vc.dawn.modalAnimationType = .zoomSlide(direction: .left, scale: 0.85)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func jumped4() {
        let item1 = StoreItemModel.init(title: "我是主标题", subTitle: "我是副标题哈哈哈哈哈哈哈", imageName: "image2", content: "在这个春意盎然的季节，我收获了几缕春风，他们轻轻地、悄悄地拂过我心田，停留在我记忆中，挥之不去。友情，是一缕春风，拂去我心灵的阴霾；亲情，是一缕春风，呵护是我心中的美好；关爱，是一缕春风，吹去刺骨的冰冷，带来温暖。\n繁花似锦，你我手拉手，肩并肩齐走在回家的那条平坦的小路上。你偶尔会摸摸我的头，掐掐我的脸，而我也尽力找话茬，希望不会太闷。“你说……我们长大了还能上同一间高中不？”我小心翼翼地问道。你抿了抿唇，苦涩的味道在你的声音里散开，“也许吧。”“但是……无论怎么样，我们都是好朋友。”看似平静的语调，在我心中激起万丈波澜，在昏暗的灯光下，我俩的手握的更紧了。百花争艳，友情更美。")
        let vc = StoreDetailViewController(storeItem: item1)
        vc.dawn.isTransitioningEnabled = true
        vc.dawn.modalAnimationType = .push(direction: .left)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func jumped5() {
        let vc = AlipageViewController()
        vc.dawn.isTransitioningEnabled = true
        vc.dawn.modalAnimationType = .push(direction: .left)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
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
