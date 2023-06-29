//
//  HeroViewController.swift
//  LentoFeedModule
//
//  Created by zhang on 2023/6/8.
//

import UIKit
import Hero

public class HeroViewController: UIViewController {

    var avView: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        // Do any additional setup after loading the view.
        
        avView = UIView()
        avView.backgroundColor = .gray
        view.addSubview(avView)
        avView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(400)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        avView.addTapGesture { [weak self] _ in
            self?.jumped()
        }
        
        
    }
    
    func jumped() {
        let vc = HeroNextViewController()
        vc.hero.isEnabled = true
//        vc.view.heroID = "ironMan"
//        vc.view.hero.modifiers = [.overlay(color: .red, opacity: 0.6)]
//        vc.hero.modalAnimationType = .pageIn(direction: .left)
        vc.hero.modalAnimationType =  .push(direction: .left)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}


public class HeroNextViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:))))
    }
    
    @objc func handlePan(gr: UIPanGestureRecognizer) {
        let translation = gr.translation(in: self.view).x
        let distance = translation / (view.bounds.width)
        
        switch gr.state {
        case .began:
            view.tag = 10229
            dismiss(animated: true)
        case .changed:
            Hero.shared.update(distance)
        default:
            let velocity = gr.velocity(in: view)
            if ((translation + velocity.x) / view.bounds.width) > 0.5 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}
