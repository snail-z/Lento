//
//  Push2ViewController.swift
//  DawnTransition_Example
//
//  Created by zhang on 2023/8/10.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import DawnTransition

class Push2ViewController: UIViewController {

    var btn1: UILabel!
    var btn2: UILabel!
    
    func makeLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .gillSans()
        label.textColor = .white
        label.backgroundColor = .random(.fairy)
        label.textAlignment = .center
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        btn1 = makeLabel(text: "Test1")
        view.addSubview(btn1)
        btn1.dw.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(150)
        }
        btn1.addTapGesture { [weak self] _ in
            self?.jump1()
        }
        
        btn2 = makeLabel(text: "Test2")
        view.addSubview(btn2)
        btn2.dw.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(btn1.dw.bottom).offset(20)
        }
        btn2.addTapGesture { [weak self] _ in
            self?.jump2()
        }
    }
}

extension Push2ViewController {
    
    func jump1() {
        let vc = Test1ViewController()
        vc.dawn.isModalEnabled = true
        vc.dawn.modalAnimationType = .pageIn(direction: .up)
        self.present(vc, animated: true)
    }
    
    func jump2() {
        let vc = Test1ViewController()
        vc.dawn.isModalEnabled = true
        vc.dawn.modalAnimationType = .pageIn(direction: .up)
        self.navigationController?.present(vc, animated: true)
    }
}

class BaseTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random(.fairy)
    }
}

class Test1ViewController: BaseTestViewController {
    var btn1: UILabel!
    func makeLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .gillSans()
        label.textColor = .darkGray
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random(.fairy)
        
        btn1 = makeLabel(text: "Back")
        view.addSubview(btn1)
        btn1.dw.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(150)
        }
        btn1.addTapGesture { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        let pan = DawnPanGestureRecognizer(driver: self, type: .dismiss) { [weak self] in
            self?.dismiss(animated: true)
        }
        pan.isRecognizeWhenEdges = true
        pan.recognizeDirection = .leftToRight
        view.dawn.addPanGestureRecognizer(pan)
    }
}
