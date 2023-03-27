//
//  MALeftAlignedLayoutViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/21.
//

import UIKit
import AmassingUI
import LentoBaseKit

extension MALeftAlignedLayoutViewController {
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarTransparent(true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavBarTransparent(false)
    }
}

public class MALeftAlignedLayoutViewController: LentoBaseViewController {

    private var collectionView: UICollectionView!
    private var indexView: MAIndexView!
    private var dataList: [MALeftAlignedGroup]!
    private var isDragTriggered = false
    
    private lazy var historyCache: MAHistoryCache = {
        return MAHistoryCache(standardKey: className, storageCount: 5)
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        commonInitialization()
        layoutInitialization()
        dataUpdates()
    }
    
    func commonInitialization() {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.contentInset = UIEdgeInsets.make(bottom: 20)
        collectionView.register(headerWithClass: MALeftAlignedHeaderView.self)
        MALeftAlignedBaseCell.registerCells(with: collectionView)
        view.addSubview(collectionView)
        
        indexView = MAIndexView()
        indexView.addTarget(self, action: #selector(indexViewValueChanged(_:)), for: .valueChanged)
        view.addSubview(indexView)
        
        navigationBar.contentVeiw.gradientDirection = .topToBottom
        navigationBar.contentVeiw.gradientClolors = [.appBlue(0.2), .white.withAlphaComponent(0.2)]
        navigationBar.setBackgroudImage(UIImage(named: "lento_location_bgImage"))
        addNavigationBar(extendedLayout: 60, belowSubview: collectionView)
        
        let kvalue = UIScreen.totalNavHeight
        print("===> kvalue is: \(kvalue)")
//        collectionView.contentInset = UIEdgeInsets.make(top: UIScreen.totalNavHeight+100)
    }
    
    func layoutInitialization() {
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
//            make.top.equalToSuperview().offset(-UIScreen.totalNavHeight)
            make.height.equalToSuperview()
        }
        
        indexView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(22)
            make.centerY.equalToSuperview().offset(-10)
        }
    }
    
    func dataUpdates() {
        let listItem = MALeftAlignedListItem(JSON: MALeftAlignedData.JsonData())
        dataList = MALeftAlignedData.dataGroups(from: listItem, historyCache: historyCache)
        collectionView.reloadData()
        indexView.indexTitles = MALeftAlignedData.indexTitles(with: dataList)
        indexView.setIndex(0)
    }
}

extension MALeftAlignedLayoutViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: MALeftAlignedConst.headerReferenceHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return MALeftAlignedConst.minimumLineSpacing(with: dataList[section])
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return MALeftAlignedConst.itemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return MALeftAlignedConst.sectionInset(with: dataList[section])
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return MALeftAlignedConst.itemLayoutSize(with: dataList[indexPath.section], at: indexPath)
    }
}

extension MALeftAlignedLayoutViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList[section].items?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let headerView = collectionView.dequeueReusableHeader(withClass: MALeftAlignedHeaderView.self, for: indexPath)
        let group = dataList[indexPath.section]
        headerView.setTitle(group.title, subtitle: group.subtitle)
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let group = dataList[indexPath.section]
        let cell = MALeftAlignedBaseCell.dequeueCell(collectionView, type: group.type, for: indexPath)
        cell.item = group.items?[indexPath.item]
        return cell
    }
}

extension MALeftAlignedLayoutViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item =  dataList[indexPath.section].items?[indexPath.item] else { return }
        historyCache.save(item)
        navigationController?.popViewController(animated: true)
    }
}

extension MALeftAlignedLayoutViewController {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragTriggered = true
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDragTriggered = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("============>contentOffsety: \(scrollView.contentOffset.y)")
        
        let osetY = scrollView.contentOffset.y
        let offsetConst: CGFloat = 88*2+100
        
        
        if osetY < offsetConst { // 下拉
            let absValue = abs(osetY) - abs(offsetConst)
            print("下拉=====> \(absValue)")
            var p = scrollView.contentOffset
            p.y += absValue
//            collectionView.setContentOffset(p, animated: false)
        } else { //上提
            let absValue = abs(offsetConst) - abs(osetY)
            print("上提=====> \(absValue)")
        }
        
//        let originInset = UIEdgeInsets.make(top: UIScreen.totalNavHeight + 50)
//        let topfff = originInset.top -
        
//        let value = scrollView.contentOffset.y - originInset.top
//        print("============>value: \(value)")
        
        
//        var ressss = CGFloat(176 + 100) + scrollView.contentOffset.y
//        print("ressss is: \(ressss)")
//        if ressss < 40 {
//            ressss = 40
//        } else if ressss > -100 {
//            ressss = -100
//        }
//

//        if ressss > 0 {
//            if ressss > 150 { ressss = 150 }
//            collectionView.contentInset = UIEdgeInsets.make(top: 88+100-ressss)
//        } else {
//            collectionView.contentInset = UIEdgeInsets.make(top: UIScreen.totalNavHeight+100)
//        }
        
        
        
        
        
        
        guard isDragTriggered else { return }
        let p = scrollView.contentOffset
        guard let section = collectionView.verticallyLayoutSection(at: p) else { return }
        indexView.setIndex(section.intValue)
    }
    
    @objc func indexViewValueChanged(_ sender: MAIndexView) {
        isDragTriggered = false
        let indexPath = IndexPath(item: 0, section: sender.currentIndex)
        collectionView.scrollToVertically(indexPath, animated: false)
    }
}









