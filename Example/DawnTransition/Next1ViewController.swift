//
//  Next1ViewController.swift
//  DawnTransition_Example
//
//  Created by zhang on 2023/8/10.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class Next1ViewController: UIViewController {

    var btn1: UILabel!
    var btn2: UILabel!
    
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
            self?.navigationController?.popViewController(animated: true)
        }
        
        btn2 = makeLabel(text: "Push")
        view.addSubview(btn2)
        btn2.dw.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(btn1.dw.bottom).offset(20)
        }
        btn2.addTapGesture { [weak self] _ in
            let vc = Next1PushViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func jump() {
        
    }
}

class Next1PushViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
