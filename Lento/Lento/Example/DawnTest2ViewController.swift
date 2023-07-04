//
//  DawnTest2ViewController.swift
//  Lento
//
//  Created by zhang on 2023/6/9.
//

import UIKit

class DawnTest2ViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:))))
        
        view.addTapGesture { [weak self] _ in
            self?.dismiss(animated: true)
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
    
    @objc func handlePan(gr: UIPanGestureRecognizer) {
        let translation = gr.translation(in: self.view).x
        let distance = translation / (view.bounds.width)
        switch gr.state {
        case .began:
//            Dawn.shared.driven(self, configuration: .init(duration: 2, curve: .linear))
            Dawn.shared.driven(dismissing: self)
            dismiss(animated: true)
        case .changed:
            Dawn.shared.update(distance)
        default:
            let velocity = gr.velocity(in: view)
            if ((translation + velocity.x) / view.bounds.width) > 0.5 {
                Dawn.shared.finish()
            } else {
                Dawn.shared.cancel()
            }
        }
    }
}





class DawnTest3ViewController: UIViewController {

    var wrapView: WrapVView!
    var btnView: UIView!
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:))))
        
        ///1544*1028 宽高比 = 1.5
        wrapView = WrapVView()
        wrapView.backgroundColor = .white
        wrapView.layer.cornerRadius = 0
        wrapView.layer.masksToBounds = true
        view.addSubview(wrapView)
        wrapView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(420)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        wrapView.addTapGesture { [weak self] _ in
            self?.view.tag = 2011
            self?.dismiss(animated: true)
        }
        
        btnView = UIView()
        btnView.backgroundColor = .orange
        view.addSubview(btnView)
        btnView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.top.equalTo(wrapView.snp.bottom).offset(150)
            make.centerX.equalToSuperview()
        }
        btnView.addTapGesture { [weak self] _ in
            self?.view.tag = 2011
            self?.dismiss(animated: true)
        }
    }
    
    var beginx: CGFloat = .zero
}

extension DawnTest3ViewController {
    
    @objc func handlePan2(gr: UIPanGestureRecognizer) {
        let translation = gr.translation(in: self.view).x
        let distance = translation / (view.bounds.width)
        switch gr.state {
        case .began:
            Dawn.shared.driven(dismissing: self)
            dismiss(animated: true)
        case .changed:
            Dawn.shared.update(distance)
        default:
            let velocity = gr.velocity(in: view)
            if ((translation + velocity.x) / view.bounds.width) > 0.5 {
                Dawn.shared.finish()
            } else {
                Dawn.shared.cancel()
            }
        }
    }
}

extension DawnTest3ViewController {
    
    @objc func handlePan(gr: UIPanGestureRecognizer) {
        let snpV = self.presentationController?.containerView?.viewWithTag(10212)
        
        let translation = gr.translation(in: self.view).x
        let distance = translation / (view.bounds.width)
        
        let minScale: CGFloat = 0.85
        var scale = 1 - distance * 0.35
        scale = min(1, scale)
        let maxRadius: CGFloat = 20
        let currentSc = (scale - minScale) / (1 - minScale)
        switch gr.state {
        case .began:
            view.layer.masksToBounds = true
            let velocity = gr.velocity(in: view)
            print("begin-translation ======> \(velocity.x)")
            beginx = velocity.x
        case .changed:
                if scale > minScale {
                    view.layer.transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
                    view.layer.cornerRadius = maxRadius - maxRadius * currentSc
                     
                    let snpSacle = 1 - 0.1 * currentSc
                    snpV?.layer.transform = CATransform3DScale(CATransform3DIdentity, snpSacle, snpSacle, 1)
                    snpV?.bottom = self.presentationController?.containerView?.bottom ?? 0
                } else {
                    view.layer.transform = CATransform3DScale(CATransform3DIdentity, minScale, minScale, 1)
                    view.layer.cornerRadius = maxRadius
                    snpV?.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                    snpV?.bottom = self.presentationController?.containerView?.bottom ?? 0
                }

//            Dawn.shared.update(distance)
        default:
//            Dawn.shared.driven(self)
           beginx = 0
            let velocity = gr.velocity(in: view)
            if ((translation + velocity.x) / view.bounds.width) > 0.5 {
//                Dawn.shared.finish()
                
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
                    snpV?.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                    snpV?.center = self.presentationController?.containerView?.center ?? .zero
                }
                dismiss(animated: true)
            } else {
//                Dawn.shared.cancel()
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
                    self.view.layer.transform = CATransform3DIdentity
                    snpV?.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
                    snpV?.center = self.presentationController?.containerView?.center ?? .zero
                }
            }
        }
    }
}
