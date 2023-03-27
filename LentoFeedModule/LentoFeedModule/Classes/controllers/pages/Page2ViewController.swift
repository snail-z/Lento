//
//  Page2ViewController.swift
//  Lento
//
//  Created by zhang on 2022/11/4.
//

import UIKit
import LentoBaseKit

extension Page2ViewController: PageViewControllerMustProxy {
    
    var pTableView: UIScrollView {
        return tableView
    }
}

class Page2ViewController: LentoBaseViewController {

    public weak var delegate: PageViewControllerContentChangedDelegate?
    
    var tableView: ListTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .brown
        
        tableView = ListTableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
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
            make.top.bottom.equalToSuperview()
        }
        
        tableView.addObserver(self, forKeyPath: "contentSize", context: nil)
        tableView.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentSize" else { return }
        print("page2变化了=======>\(tableView.contentSize)")
        delegate?.contentSizeChanged?(tableView.contentSize, sender: self)
    }
}

extension Page2ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FontLibrariesCell.cellForTableView(tableView)
        let title = "\(indexPath.row)-page222222改革"
        cell.dataUpdates2(title, index: indexPath.row)
        cell.contentView.backgroundColor = .colorF5F5F5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("page1 didSelectRowAt===> \(indexPath.row)")
    }
}

extension Page2ViewController: UITableViewDelegate {
    
}
