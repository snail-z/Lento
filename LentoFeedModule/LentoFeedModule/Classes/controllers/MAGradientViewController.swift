//
//  MAGradientViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/19.
//

import UIKit
import AmassingUI
import LentoBaseKit

public class MAGradientViewController: LentoBaseViewController {
    
    private var gradientView1: MAGradientView!
    private var gradientView2: MAGradientView!
    private var gradientView3: MAGradientView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        commonInitialization()
        layoutInitialization()
        addGadientPath()
        gradientPathChanged()
    }
    
    func commonInitialization() {
        gradientView1 = MAGradientView()
        gradientView1.layer.cornerRadius = 4
        gradientView1.layer.masksToBounds = true
        gradientView1.gradientClolors = [.appBlue(), .appBlue(0.2)]
        gradientView1.gradientDirection = .leftToRight
        view.addSubview(gradientView1)
        
        gradientView2 = MAGradientView()
        gradientView2.layer.cornerRadius = 4
        gradientView2.layer.masksToBounds = true
        gradientView2.gradientClolors = [.appBlue(), .appBlue(0.2)]
        gradientView2.gradientDirection = .leftToRight
        view.addSubview(gradientView2)
        
        gradientView3 = MAGradientView()
        gradientView3.layer.cornerRadius = 4
        gradientView3.layer.masksToBounds = true
        gradientView3.gradientClolors = [.appBlue(), .appBlue(0.2)]
        gradientView3.gradientDirection = .leftTopToRightBottom
        view.addSubview(gradientView3)
    }
    
    func layoutInitialization() {
        gradientView1.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(80)
        }
        
        gradientView2.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(110)
            make.centerX.equalToSuperview()
            make.top.equalTo(gradientView1.snp.bottom).offset(20)
        }
        
        gradientView3.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(110)
            make.centerX.equalToSuperview()
            make.top.equalTo(gradientView2.snp.bottom).offset(20)
        }
    }
    
    func addGadientPath() {
        gradientView2.layoutIfNeeded()
        gradientView2.gradientPath = curvePath(gradientView2).cgPath
    }
    
    func gradientPathChanged() {
        gradientView3.layoutIfNeeded()
        let path1 = curve2Path(gradientView3).cgPath
        let path2 = curvePath(gradientView3).cgPath
        gradientView3.gradientPath = path1
        DispatchQueue.asyncAfter(delay: 1.0) {
            self.gradientView3.setGradient(path: path2, animation: 0.5)
        }
    }
}

extension MAGradientViewController {
    
    func curvePath(_ aView: UIView) -> UIBezierPath {
        let width: CGFloat = aView.width
        let height: CGFloat = aView.height
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: 0, y: height / 3))
        let p1 = CGPoint(x: 90, y: 20)
        let p2 = CGPoint(x: 160, y: 50)
        path.addCurve(to: CGPoint(x: width, y: 60), controlPoint1: p1, controlPoint2: p2)
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        return path
    }
    
    func curve2Path(_ aView: UIView) -> UIBezierPath {
        let width: CGFloat = aView.width
        let height: CGFloat = aView.height
        let path = UIBezierPath.init()
        path.move(to: CGPoint(x: 0, y: height / 3))
        let p1 = CGPoint(x: 30, y: 120)
        let p2 = CGPoint(x: 160, y: 20)
        path.addCurve(to: CGPoint(x: width, y: 60), controlPoint1: p1, controlPoint2: p2)
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        return path
    }
}
