//
//  Push1ViewController.swift
//  DawnTransition_Example
//
//  Created by zhang on 2023/8/10.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import DawnTransition

class Push1ViewController: UIViewController {

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
        
        btn1 = makeLabel(text: "normal")
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
        
        btn2 = makeLabel(text: "Plain")
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

extension Push1ViewController {
    
    func jump1() {
        let vc = Next1ViewController()
        vc.dawn.isNavigationEnabled = true
        vc.dawn.navigationAnimationType = .pageIn(direction: .right)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func jump2() {
        let vc = Next2ViewController()
        vc.dawn.isNavigationEnabled = true
        vc.dawn.navigationAnimationType = .pageIn(direction: .left)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
