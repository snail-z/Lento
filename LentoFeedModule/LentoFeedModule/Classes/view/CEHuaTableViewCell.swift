//
//  CEHuaTableViewCell.swift
//  Lento
//
//  Created by zhang on 2022/11/17.
//

import UIKit

class CEHuaTableViewCell: FontLibrariesCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupCommon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var mkPan: MkUIPanGestureRecognizer!
    
    func setupCommon() {
        mkPan = MkUIPanGestureRecognizer.init(target: self, action: #selector(panGesterDidPan(_:)))
        mkPan.delegate = self
        contentView.addGestureRecognizer(mkPan)
    }
    
    var beginPoint: CGPoint = .zero
    
    @objc func panGesterDidPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            beginPoint = sender.translation(in: self)
        case .changed:
            let p = sender.translation(in: self)
            let isLeft = (p.x - beginPoint.x < 0)
            print("===> isLeft is: \(isLeft)")
            
            print("===> p is: \(p)")
            
        case .ended:
            break
        default: // cancel
            break
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer.isMember(of: MkUIPanGestureRecognizer.self) {
//            let gesture:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
//            let velocity = gesture.velocity(in: self)
//            if abs(velocity.x) > abs(velocity.y) {
//                return true
//            }
//        }
//        return false
//    }


//    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
}
