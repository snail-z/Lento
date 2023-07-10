//
//  DawnNavTest1ViewController.swift
//  Lento
//
//  Created by zhang on 2023/7/10.
//

import UIKit

public class DawnNavTest1ViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addTapGesture { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let imgView = UIImageView.init(image: UIImage.init(named: "001"))
        imgView.backgroundColor = .white
        imgView.clipsToBounds = true
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.left.equalTo(100)
            make.right.equalTo(-100)
            make.height.equalTo(220)
            make.centerY.equalToSuperview()
        }
    }
}
