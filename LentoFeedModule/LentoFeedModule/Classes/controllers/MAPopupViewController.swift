//
//  MAPopupViewController.swift
//  Lento
//
//  Created by zhang on 2022/11/7.
//

import UIKit
import LentoBaseKit

@objc protocol MADeleteTableViewPanProxy {

    @objc optional func panGesterDidPan(_ sender: UIPanGestureRecognizer)
}

class MkUIPanGestureRecognizer: UIPanGestureRecognizer {}

class MADeleteTableView: UITableView, UIGestureRecognizerDelegate {
    
    weak var panProxy: MADeleteTableViewPanProxy?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupCommon()
    }
    
    var mkPan: MkUIPanGestureRecognizer!
    
    func setupCommon() {
        mkPan = MkUIPanGestureRecognizer.init(target: self, action: #selector(panGesterDidPan(_:)))
        mkPan.delegate = self
        addGestureRecognizer(mkPan)
    }

    @objc func panGesterDidPan(_ sender: UIPanGestureRecognizer) {
        panProxy?.panGesterDidPan?(sender)
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isMember(of: MkUIPanGestureRecognizer.self) {
            let gesture:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let velocity = gesture.velocity(in: self)
            if velocity.x < 0 {
                if abs(velocity.x) > abs(velocity.y) {
                    return true
                }
            }
            return false
        }
        return true
    }
}

class MAPopupViewController: LentoBaseViewController, MADeleteTableViewPanProxy {

    var tableView: MADeleteTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = MADeleteTableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.panProxy = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.alwaysBounceVertical = true
        tableView.bounces = true
        tableView.removeAutomaticallyAdjustsInsets()
        tableView.fixSectionHeaderTopPadding()
        tableView.backgroundColor = .cyan
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    var beginPoint: CGPoint = .zero
    var fakeView: UIView?
    var deleteView: UILabel?
    
    var beginLOcaion: CGPoint = .zero
    var lastCell: UITableViewCell?
    
    
    func panGesterDidPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            beginPoint = sender.translation(in: self.tableView)
            
            let inPoint = sender.location(in: self.tableView)
            print("===> beginInPoint is: \(inPoint)")
            guard let indexPath = self.tableView.indexPathForRow(at: inPoint) else { return }
            if let cell = self.tableView.cellForRow(at: indexPath) as? CEHuaTableViewCell {
                
                if let fake = fakeView {
                    let cetenp =  CGPoint(x: self.tableView.centerX, y: fake.centerY)
                    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.06) {
                        fake.center = cetenp
                    } completion: { _ in
                        fake.removeFromSuperview()
                        self.lastCell?.contentView.isHidden = false
                    }
                }
        
                if let value = cell.contentView.snapshotView(afterScreenUpdates: false) {
                    cell.contentView.isHidden = true
                    cell.addSubview(value)
                    fakeView = value
                    beginLOcaion = cell.contentView.center
                    fakeView?.center = beginLOcaion
                    
                    deleteView = UILabel()
                    deleteView!.backgroundColor = .red
                    deleteView!.text = "删除"
                    deleteView?.textAlignment = .center
                    deleteView?.font = .appFont(18)
                    deleteView!.textColor = .white
                    fakeView?.addSubview(deleteView!)
                    deleteView?.size = CGSize(width: 150, height: cell.bounds.height)
                    deleteView?.origin.x = cell.bounds.width
                    
                    
                    lastCell = cell
                }
            }
        case .changed:
            let p = sender.translation(in: self.tableView)
//            let isLeft = (p.x - beginPoint.x < 0)
//            print("===> isLeft is: \(isLeft)")
            print("===> p is: \(p)")
            
            if let fakeV = fakeView {
                var cetenp =  CGPoint(x: self.tableView.centerX, y: beginLOcaion.y)
                cetenp.x = self.tableView.centerX + (p.x)
                fakeV.center = cetenp
            }
        case .ended:
            if let fakeV = fakeView {
                var cetenp =  CGPoint(x: self.tableView.centerX, y: beginLOcaion.y)
                cetenp.x = self.tableView.centerX - 150
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.06) {
                    fakeV.center = cetenp
                } completion: { _ in
                    
                }
            }
        default: // cancel
            /// 复原
            break
        }
    }
}

extension MAPopupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CEHuaTableViewCell.cellForTableView(tableView)
        let title = "\(indexPath.row)-滑动删除的Cell"
        cell.dataUpdates2(title, index: indexPath.row)
        cell.contentView.backgroundColor = .colorF5F5F5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("page1 didSelectRowAt===> \(indexPath.row)")
    }
}

extension MAPopupViewController: UITableViewDelegate {

}

//extension MAPopupViewController {
//    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//    
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "删除"
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        print("==> editingStyleeditingStyleeditingStyleeditingStyle")
//    }
////
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let action = UITableViewRowAction.init(style: .default, title: "删了") { sender, idxPath in
//
//        }
//
//        if indexPath.row.isOdd {
//            return nil
//        }
//        return [action]
//    }
//    
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "是多少"
//    }
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let tual = UIContextualAction.init(style: .destructive, title: "删除") { sender, aView, esp in
//            print("点击了--=-=-")
//        }
//        let swipe = UISwipeActionsConfiguration.init(actions: [tual])
//        swipe.performsFirstActionWithFullSwipe = false
//        return swipe
//    }
//    
//    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return true
//    }
//}




























//        let ex1VC = MAExpmale1ViewController()
//        ex1VC.view.backgroundColor = .red.withAlphaComponent(0.5)
//        addChild(ex1VC)
//        view.addSubview(ex1VC.view)
//        ex1VC.didMove(toParent: self)
//        self.view.window?.addSubview(ex1VC.view)
class MAExpmale1ViewController: LentoBaseViewController {
    
    deinit {
        print("MAExpmale1ViewController====> deinit")
    }
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    
        imageView = UIImageView()
        imageView.backgroundColor = .random(.fairy)
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(300)
            make.center.equalToSuperview()
        }
    }
}
