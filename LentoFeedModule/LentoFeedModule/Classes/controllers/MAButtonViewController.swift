//
//  MAButtonViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/18.
//

import UIKit
import AmassingUI
import LentoBaseKit

public class MAButtonViewController: LentoBaseViewController {
    
    var tableView: LentoTableView!
    
    var tagView: MATagContainerView!
    
    var stackView: UIStackView!
    var BGstackView: UIView!
    var bottomView: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackgroundColor(.white)
        self.navigationController?.navigationBar.insetsLayoutMarginsFromSafeArea = false
        
        tableView = LentoTableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.estimatedRowHeight = 60
        tableView.removeAutomaticallyAdjustsInsets()
//        tableView.backgroundColor = .cyan
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
}

extension MAButtonViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MAButtonTableViewCell.cellForTableView(tableView)
        cell.contentView.backgroundColor = .lightGray
        cell.dataUpdates(indexPath.row)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("page1 didSelectRowAt===> \(indexPath.row)")
        
//        let vc = MADebugMenuViewController()
//        let nvc = MADebugNavigationController.init(rootViewController: vc)
//        nvc.modalPresentationStyle = .fullScreen
//        self.present(nvc, animated: true)
    }
}

/// Data Access Object
extension MAButtonViewController: UITableViewDelegate {
    
    func test1() {
        let md = UIColor.hex(0x899999)
        view.backgroundColor = md
        
        view.disableInteraction(duration: 3)
    }
}



