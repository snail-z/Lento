//
//  LentoFishViewController.swift
//  Lento
//
//  Created by corgi on 2022/9/9.
//

import UIKit
import JXPagingView
import JXSegmentedView

class LentoFishViewController: UIViewController, JXPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return 200
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return UIView()
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return 50
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return UIView()
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return 3
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        return BaseListViewController()
    }
    
    
    
    lazy var pagingView = preferredPagingView()
    
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView(
            frame: CGRect(x: 0, y: 0,
                          width: UIScreen.main.bounds.size.width,
                          height: CGFloat(50)))
        view.backgroundColor = UIColor.yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    
        
    }
}

extension LentoFishViewController {
    
    func preferredPagingView() -> JXPagingView {
        let pagingView = JXPagingListRefreshView(delegate: self)
        if #available(iOS 15.0, *) {
            if pagingView.mainTableView.responds(to: NSSelectorFromString("setSectionHeaderTopPadding:")) {
                pagingView.mainTableView.sectionHeaderTopPadding = .zero
            }
        }
        return pagingView
    }
}
