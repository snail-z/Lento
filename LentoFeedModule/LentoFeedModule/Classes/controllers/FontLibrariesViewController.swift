//
//  FontLibrariesViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/19.
//

import UIKit
import AmassingUI
import LentoBaseKit

public class FontLibrariesViewController: LentoBaseViewController {

    var tableView: UITableView!
    var indexView: MAIndexView!
    var indexViewBubble: UILabel!
    var dataList: [FontLibrariesGroup]!
    var isDragTriggered = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        commonInitialization()
        dataUpdates()
        title = "点击复制字体"
    }
    
    func commonInitialization() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
//        tableView.estimatedRowHeight = 80
        tableView.sectionHeaderHeight = 30
        tableView.contentInset = UIEdgeInsets.make(bottom: 50)
        tableView.removeAutomaticallyAdjustsInsets()
        tableView.fixSectionHeaderTopPadding()
        view.addSubview(tableView)
        
        indexView = MAIndexView()
        indexView.dragEvents = self
        indexView.addTarget(self, action: #selector(indexViewValueChanged(_:)), for: .valueChanged)
        view.addSubview(indexView)
        
        indexViewBubble = UILabel()
        indexViewBubble.layer.cornerRadius = 2
        indexViewBubble.layer.masksToBounds = true
        indexViewBubble.backgroundColor = UIColor.black.withAlphaComponent(1)
        indexViewBubble.size = CGSize(width: 60, height: 60)
        indexViewBubble.textColor = .white
        indexViewBubble.font = .gillSans(32)
        indexViewBubble.textAlignment = .center
        indexViewBubble.alpha = 0
        view.addSubview(indexViewBubble)
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        indexView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(22)
            make.centerY.equalToSuperview().offset(-10)
        }
    }
    
    func dataUpdates() {
        dataList = FontLibrariesData.dataGroups()
        indexView.indexTitles = dataList.map { $0.letter }
        indexView.setIndex(0)
        tableView.reloadData()
        tableView.isEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        
//        tableView.setEditing(true, animated: true)
    }
}

extension FontLibrariesViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].familyNames.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aView = FontLibrariesHeaderView()
        aView.title = dataList[section].letter
        return aView
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FontLibrariesCell.cellForTableView(tableView)
        cell.title = dataList[indexPath.section].familyNames[indexPath.row]
        cell.hasLine = indexPath.row != dataList[indexPath.section].familyNames.count - 1
        return cell
    }
}

extension FontLibrariesViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // 这个方法第一次调用的时候 indexPath 为 nil
        if  let selectedRowIndexPath = tableView.indexPathForSelectedRow {
                // 去除上一次选中
            tableView.deselectRow(at: selectedRowIndexPath, animated: true)
        }
        return indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.setEditing(true, animated: true)
//        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//        let group = dataList[indexPath.section]
//        let name = group.familyNames[indexPath.row]
//        UIPasteboard.general.string = name
//        view.pk.showToast(message: "已拷贝字体到剪贴板", position: .center(offset: -80))
    }
}

extension FontLibrariesViewController: MAIndexViewDragEvents {
    
    public func indexView(_ indexView: MAIndexView, willBeginDragging position: CGPoint, index: Int) {
        self.indexView(indexView, didDragging: position, index: index)
        UIView.animate(withDuration: 0.25) {
            self.indexViewBubble.alpha = 1
        }
    }
    
    public func indexView(_ indexView: MAIndexView, didDragging position: CGPoint, index: Int) {
        let p = indexView.convert(position, to: view)
        indexViewBubble.center = CGPoint(x: view.centerX, y: p.y)
        indexViewBubble.text = indexView.indexTitles?.element(safe: index)
    }
    
    public func indexView(_ indexView: MAIndexView, didEndDraggingAtIndex: Int) {
        UIView.animate(withDuration: 0.25) {
            self.indexViewBubble.alpha = 0
        }
    }
}

extension FontLibrariesViewController {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragTriggered = true
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDragTriggered = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isDragTriggered else { return }
        var p = scrollView.contentOffset
        p.y += tableView.sectionHeaderHeight
        guard let indexPath = tableView.indexPathForRow(at: p) else { return }
        indexView.setIndex(indexPath.section)
    }
    
    @objc func indexViewValueChanged(_ sender: MAIndexView) {
        isDragTriggered = false
        let indexPath = IndexPath(row: 0, section: sender.currentIndex)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
}
