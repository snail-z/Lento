//
//  ViewController.swift
//  Lento
//
//  Created by corgi on 2022/7/4.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AmassingExtensions
import AmassingUI
import LentoBaseKit
import LentoFeedModule

class ViewController: UIViewController {

    private var tableView: UITableView!
    private var contentView: GRayView!
    private var pupupView: YellowView!
    private var coverView: CoverView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    let amassingUIs = ["LenPopupViewController", "TabTest","UICollectionViewLeftAlignedLayout", "UICollectionViewWaterfallLayout" , "Font Libraries", "MAButton", "MASearchView", "MAPageListViewController", "MAPopupViewController", "MALabel", "MAGradientView", "MAIndexView", "MASegmentedView", "MATextField", "MATextView", "MADatePicker", "MACycleScrollView", "MAAttributedLabel"]
    
    func setup() {
        title = "AmassingUI"
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 60, right: 0)
        tableView.separatorStyle = .none
        tableView.removeAutomaticallyAdjustsInsets()
        tableView.register(cellWithClass: ULeftTableViewCell.self)
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amassingUIs.count
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ULeftTableViewCell.self)
        cell.aView.text = amassingUIs[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = amassingUIs[indexPath.row]
        
        if value == "LenPopupViewController" {
            let vc = LenPopupViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if value == "TabTest" {
            print("TabTestTabTestTabTest")
            var hahViewVC = UIApplication.keyWindow()?.rootViewController
            guard let hjaVC = hahViewVC else { return }
            
            let sildVC = SidebarViewController()
            sildVC.transitioningDelegate = sildVC
            sildVC.modalPresentationStyle = .custom
            hjaVC.present(sildVC, animated: true)
        }
        
        if value == "MALabel" {
            let vc = MALabelViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if value == "MAButton" {
            let vc = MAButtonViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if value == "UICollectionViewWaterfallLayout" {
            let vc = MAWaterfallLayoutViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if value == "Font Libraries" {
            let vc = FontLibrariesViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if value == "MAGradientView" {
            let vc = MAGradientViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
       
        if value == "UICollectionViewLeftAlignedLayout" {
            let vc = MALeftAlignedLayoutViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if value == "MASearchView" {
            let vc = MASearchViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if value == "MAPageListViewController" {
//            let vc = MAPageListViewController()
//            navigationController?.pushViewController(vc, animated: true)
        }
        
        if value == "MAPopupViewController" {
//            let vc = MAPopupViewController()
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
}



/**
 var mabtn: MAButton!
 
 func setup1() {
     mabtn = MAButton()
     mabtn.imagePlacement = .left
     mabtn.contentHorizontalAlignment = .center
     mabtn.imageView.backgroundColor = .random()
     mabtn.imageFixedSize = CGSize.init(width: 30, height: 30)
     view.addSubview(mabtn)
     
     mabtn.snp.makeConstraints { make in
         make.width.equalTo(150)
         make.height.equalTo(60)
         make.center.equalToSuperview()
     }
     
     mabtn.setTitle("中国", for: .normal)
     mabtn.setTitle("美国", for: .selected)
     mabtn.isSelected = true
     mabtn.addTarget(self, action: #selector(didMAbtnClicked(sender:)))
     
     
     
     
     let uibtn = UIButton(type: .custom)
     uibtn.setTitle("normal", for: .normal)
     uibtn.setTitle("selected", for: .selected)
     uibtn.setTitle("highlighted", for: .highlighted)
     
     uibtn.setTitleColor(.black, for: .normal)
     uibtn.setBackgroundColor(.lightGray, forState: .normal)
     
     uibtn.setTitleColor(.white, for: .selected)
     uibtn.setBackgroundColor(.darkGray, forState: .selected)
     
     uibtn.setTitleColor(UIColor.debugColorRandom, for: .highlighted)
     uibtn.setBackgroundColor(.debugColorRandom, forState: .highlighted)
     
     view.addSubview(uibtn)
     
     uibtn.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(mabtn.snp.bottom).offset(30)
         make.width.equalTo(150)
         make.height.equalTo(60)
     }
     
     uibtn.addTarget(self, action: #selector(didclidked(_:)), for: .touchUpInside)
 }
 
 
 @objc func didclidked(_ sender: UIButton) {
     mabtn.isSelected = !mabtn.isSelected
     print("didclidkeddidclidked")
 }
 
 @objc func didMAbtnClicked(sender: MAButton) {
     print("调用成功了haha~~ \(sender.titleLabel.text)")
 }
 
*/


extension ViewController {
    
    func demo2() {
        contentView = GRayView()
        contentView.backgroundColor = .gray
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .blue
        btn.setTitle("next", for: .normal)
        contentView.addSubview(btn)
        
        btn.snp.makeConstraints { make in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.center.equalToSuperview()
        }
        
        btn.events.addAction(for: .touchUpInside) { [weak self] sender in
            
            print("移动动画")
            self?.updateLy()
        }
        
        pupupView = YellowView()
        pupupView.backgroundColor = .yellow
        contentView.addSubview(pupupView)
        
        let half = UIScreen.main.bounds.size.height * 0.5
        pupupView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(ceil(half))
        }
        
        coverView = CoverView()
        coverView.ignoredView = btn
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        coverView.addTapGesture { tap in
            print("点击了cover")
        }
    }
    
    func updateLy() {
        pupupView.setNeedsLayout()
        pupupView.snp.updateConstraints { make in
            make.centerY.equalToSuperview()
        }
        UIView.animate(withDuration: 1.5, delay: 0) {
            self.pupupView.superview?.layoutIfNeeded()
        }
    }
    
    func testDemo() {
        self.title = "RxSwift"
        let arr = ["A", "b", "c", "d", "e", "f", "g"]
        let res = arr.firstElements(of: 2)
        print("res is: \(res)")
        let las = arr.lastElements(of: 2)
        print("las is: \(las)")
        
        _ = las.element(safe: 5, default: "")
        
        _ = las.element(safe: 5) ?? ""
        
        let date = Date()
        
        let day = date.component(.day)
        print(" day is: \(day)")
        
        let stringDate = "2022-07-04 16:30"
        let date2 = Date.make(string: stringDate, format: "yyyy-MM-dd HH:mm")!
        let since = date.since(date2, in: .weekOfYear)
        print("since is: \(since)")
        
        let newDate = date2.adjust(.minute, offset: 30)
        print("newDate is: \(newDate.toString())")
        
        print("system is: \(newDate.toString(dateStyle: .medium, timeStyle: .short))")
        
        let value1 = date2.describeTimePassed()
        let value2 = Date().describeTimePassedShort()
        print("value1 is: \(value1)")
        print("value2 is: \(value2)")
        
        let valus1 = date2.describeWeekday(.chineseShort)
        let valus2 = Date().describeWeekday(.chinese)
        print("valus is: \(valus1)")
        print("valus2 is: \(valus2)")
        
        
        let doubleValue: Double = 78298.968
//        let doubleValue = 0.135
        
        let testValue1 = doubleValue.rmbCapitalizedValue()
        print("testValue1 is: \(testValue1)")
        
        let testValue2 = doubleValue.stringValue(.currency)
        print("testValue2===> is: \(testValue2)")
//        print("deleteLastCharacter===> is: \(testValue2.deleteFirstCharacter() ?? "")")
//        print("deleteLastCharacter===> is: \(testValue2.substringTake(to: 2))")
        
        
        let _ = testValue1.contains("", caseSensitive: true)
        let res7 = String.random(of: 11)
        print("res7 is: \(res7)")
        
        
        let mutableAttrib = NSMutableAttributedString.init()
        mutableAttrib.font(.systemFont(ofSize: 9))
        
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("", for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.setTitle("next", for: .normal)
        view.addSubview(button)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.top.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
        button.backgroundColor = .random(.cooler)
        
        let pan = UIPanGestureRecognizer()
        pan.maximumNumberOfTouches = 4
        

        button.setBackgroundColor(.red, forState: .normal)
        
        
                
        
    
        
        let style = ANToastStyle()
        style.textAlignment = .center
        style.contentEdgeInsets = UIEdgeInsets(top: 12, left: 35, bottom: 18, right: 35)
        style.backgroundColor = .white
        style.textColor = .black
        style.animationOptions = .transform(scale: 0.75)
//        style.imageTintColor = .red
        style.animateDuration = 0.25
        style.alwaysOnlyOneToast = true
        ANToastManager.shared.style = style
        ANToastManager.shared.placement = .top
        
        let sdds = UIApplication.keyWindow()
        print("keyWindow is: \(sdds)")
        
        button.events.addAction(for: .touchUpInside) { sender in
            
//            sender.showIndicatorText("加载中...", style: .medium, color: .white)
            
//            self.view.pk.showToast(message: "保存成功\n请到「我的-笔记」页面查看")
            self.view.pk.showToast(message: "保存成功\n请到「我的-笔记」页面查看", image: UIImage(named: "toast_success"))
            
            DispatchQueue.asyncAfter(delay: 2) {
                sender.hideIndicator()
            }
        }
        
        
        let xyView = UIImageView()
        xyView.backgroundColor = .gray
        xyView.image = UIImage(named: "img_1")
        view.addSubview(xyView)
        
   
//        xyView.snp.makeConstraints { make in
//            make.edges.equalTo(dsView)
//        }

//        let bzpath = UIBezierPath.init()
//        bzpath.move(to: CGPoint(x: gW, y: 0))
//        bzpath.addLine(to: CGPoint(x: 0, y: 0))
//        bzpath.addLine(to: CGPoint(x: 0, y: gH))
////        bzpath.addLine(to: CGPoint(x: gW, y: gH))
////        bzpath.addArc(withCenter: CGPoint(x: 50, y: 20), radius: 40, startAngle: 0, endAngle: .pi * 2, clockwise: true)
//
//        let control1 = CGPoint(x: gW - gH / 2 , y: gH)
//        let control2 = CGPoint(x: gW, y: ceil(gH / 2))
//        bzpath.addCurve(to: CGPoint(x: 200, y: 0), controlPoint1: control1, controlPoint2: control2)
////        bzpath.close()
////        bzpath.addRect(CGRect(x: 0, y: 0, width: 50, height: 100))
//        dsView.gradientPath = bzpath.cgPath
//
        
        
        
        
        
//        let centers = CGPoint(x: gW / 2, y: gH / 2)
//        let pa1 = UIBezierPath()
//        pa1.addArc(withCenter: .zero, radius: 1, startAngle: 0, endAngle: .pi * 2, clockwise: true)
//        dsView.gradientPath = pa1.cgPath
//
//        let pa2 = UIBezierPath()
//
//        pa2.addArc(withCenter: .zero, radius: gRect.maxRadius() * 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
//        DispatchQueue.asyncAfter(delay: 2) {
//            dsView.gradientPath = pa2.cgPath
//        }
        
//        let shaperLayer = ANShapeLayer()
//        shaperLayer.backgroundColor = UIColor.red.cgColor
//        shaperLayer.fillColor = UIColor.yellow.cgColor
//        xyView.layer.addSublayer(shaperLayer)
        
//        let shpath = UIBezierPath()
//        shpath.addArc(withCenter: centers, radius: gRect.maxRadius(), startAngle: 0, endAngle: .pi * 2, clockwise: true)
//        shaperLayer.path = shpath.cgPath
        
    }
    

    
    
    @objc func prefsClicked(sender: UIButton) {
//        UIApplication.open(link: UIApplication.openSettingsURLString)
//        UIAlertController.show(message: "skdfjs深刻的福利就是打开房间", isVibrate: true)
    }
}

//
class ULeftTableViewCell: LentoBaseTableViewCell {

    var gradientView: MAGradientView!
    var aView: MALabel!

    override func commonInitialization() {
        gradientView = MAGradientView.init()
        gradientView.gradientClolors = [UIColor.appBlue(0.5), .appBlue(0.1)]
        gradientView.gradientDirection = .leftToRight
//        gradientView.layer.cornerRadius = 2
//        gradientView.layer.masksToBounds = true
        contentView.addSubview(gradientView)
        
        aView = MALabel()
        aView.contentEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 40)
        aView.font = .gillSans(19)
        aView.textColor = .appBlue()
        contentView.addSubview(aView)
    }

    override func layoutInitialization() {
        gradientView.snp.makeConstraints { make in
            make.left.equalTo(aView)
            make.right.equalTo(aView)
            make.bottom.equalTo(aView)
            make.height.equalTo(1/UIScreen.main.scale)
        }
        
        aView.pk.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
        }
    }
}
//
//
//class ULeftHeaderView: UITableViewHeaderFooterView {
//
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = UIColor.pk.random()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


/**
 稻子熟了，农民们拿着镰刀，开着机车在稻田中来回穿梭。北方的深秋草木凋零，走在街巷，满眼都是肃杀之景。偶起秋风，吹落满地枯枝残叶；偶落秋雨，更是平添凄冷之情。第一次来成都时也是秋天。这里的深秋，让人丝毫感受不到北方秋季那样凄冷。城中静静盛开的芙蓉花，让天府之国散发出一种沉稳典雅又不失活泼灵动的独特气质。朴素的松树，此时也在发中拨上几枝棕色的簪子，其他树便更不用说了，枝上红色、淡黄色与绿色混合在一起，令人一看到，便不认为秋是寂寥的。石榴点缀在绿叶之中，让人仿佛回到了春。
 */


class GRayView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("hitTest==> GRayViewGRayViewGRayView")
        return super.hitTest(point, with: event)
    }
}

class ChildView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("hitTest==> ChildView")
        return super.hitTest(point, with: event)
    }
}

class CoverView: LentoBaseView {
    
    
    var childView: ChildView!
    
    override func commonInitialization() {
        childView = ChildView()
        childView.backgroundColor = .cyan
        addSubview(childView)
        childView.addTapGesture { tap in
            print("点击了childView")
        }
    }
    
    override func layoutInitialization() {
        childView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-200)
        }
    }
    
    weak var ignoredView: UIView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("hitTest====> CoverView")
        guard let aView = ignoredView else {
            return super.hitTest(point, with: event)
        }

//        /// 方法一：转换点 - 将当前触摸点转换到目标视图上，判断该点是否在目标区域内
//        let igPoint = self.convert(point, to: aView)
//        if aView.point(inside: igPoint, with: event) {
//            return aView
//        } else {
//            return super.hitTest(point, with: event)
//        }

        /// 方法二：转换rect - 将目标视图的frame转换到当前视图上，判断触摸点是否在目标区域
        let igRect = aView.superview!.convert(aView.frame, to: self)
        if igRect.contains(point) {
            return aView
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

class YellowView: LentoBaseView {
    
    var closeView: UIButton!
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if closeView.frame.contains(point) {
            return true
        }
        return super.point(inside: point, with: event)
    }
    
    override func commonInitialization() {
        closeView = UIButton(type: .custom)
        closeView.backgroundColor = .red
        closeView.layer.cornerRadius = 15
        closeView.layer.masksToBounds = true
        addSubview(closeView)
        closeView.events.addAction(for: .touchUpInside) { sender in
            print("点击了关闭")
        }
    }
    
    override func layoutInitialization() {
        closeView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(-30)
//            make.right.equalToSuperview()
//            make.top.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
}
