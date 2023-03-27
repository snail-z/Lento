//
//  BaseListViewController.swift
//  Lento
//
//  Created by corgi on 2022/9/9.
//

import UIKit
import JXPagingView

class BaseListViewController: UIViewController {

    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}

extension BaseListViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return view
    }
    
    func listScrollView() -> UIScrollView {
        return UIScrollView()
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    
    
}
