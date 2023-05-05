//
//  MAGradientViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/19.
//

import UIKit
import AmassingUI
import LentoBaseKit

extension MAGradientViewController: PickerViewDataSource {
    public func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        return osxNames.count
    }
    
    public func pickerView(_ pickerView: PickerView, titleForRow row: Int) -> String {
        return osxNames[row]
    }
}

extension MAGradientViewController: PickerViewDelegate {
    public func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
     return 60
    }
    
    public func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        if (highlighted) {
            label.font = UIFont.systemFont(ofSize: 26.0, weight: UIFont.Weight.light)
            label.textColor = view.tintColor
        } else {
            label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.light)
            label.textColor = UIColor(red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        }
     
    }
    
//    public func pickerView(_ pickerView: PickerView, viewForRow row: Int, highlighted: Bool, reusingView view: UIView?) -> UIView? {
//        let v = UIView()
//        v.backgroundColor = .random(.granite)
//        return v
//    }
}

public class MAGradientViewController: LentoBaseViewController {
    
    private var gradientView1: MAGradientView!
    private var gradientView2: MAGradientView!
    private var gradientView3: MAGradientView!
    var examplePicker: PickerView!
    
    let osxNames = ["Cheetah", "Puma", "Jaguar", "Panther", "Tiger", "Leopard", "Snow Leopard", "Lion", "Montain Lion",
                    "Mavericks", "Yosemite", "El Capitan"]
    
    func setupPicker() {
        examplePicker = PickerView.init()
        examplePicker.dataSource = self
        examplePicker.delegate = self
        examplePicker.scrollingStyle = .default
        view.addSubview(examplePicker)
        
        examplePicker.backgroundColor = .yellow
        examplePicker.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(200)
            make.height.equalTo(180)
        }
        
        let redView = UIView()
        redView.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        view.addSubview(redView)
        
        redView.snp.makeConstraints { make in
            make.center.equalTo(examplePicker)
            make.width.equalTo(150)
            make.height.equalTo(60)
        }
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupPicker()
//        commonInitialization()
//        layoutInitialization()
//        addGadientPath()
//        gradientPathChanged()
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
