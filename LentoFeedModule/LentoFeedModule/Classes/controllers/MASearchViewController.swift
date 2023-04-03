//
//  MASearchViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/26.
//

import UIKit
import AmassingUI
import LentoBaseKit

extension MASearchViewController {
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarHidden(true, animated: animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.textField.becomeFirstResponder()
    }
}

public class MASearchViewController: LentoBaseViewController {

    private var searchBar: MASearchBar!
    private var collectionView: UICollectionView!
    private var dataList: [MASearchGroup]!
    
    private lazy var historyCache: MAHistoryCache = {
        return MAHistoryCache(standardKey: className, storageCount: 8)
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        commonInitialization()
        layoutInitialization()
        dataUpdates()
    }
    
    func commonInitialization() {
        let layout = UICollectionViewLeftAlignedLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        collectionView.register(headerWithClass: MASearchHeaderView.self)
        collectionView.register(cellWithClass: MASearchHistoriesEmptyCell.self)
        collectionView.register(cellWithClass: MASearchHistoriesCell.self)
        collectionView.register(cellWithClass: MASearchDiscoverCell.self)
        collectionView.register(cellWithClass: MASearchPagesCell.self)
        view.addSubview(collectionView)
        
        searchBar = MASearchBar()
        searchBar.cancelButton.addGestureRecognizer(UITapGestureRecognizer.action.gestureClosure({ [weak self] _ in
            self?.searchBar.textField.resignFirstResponder()
            self?.backToViewController()
        }))
        view.addSubview(searchBar)
        
        navigationBar.contentVeiw.backgroundColor = .white
        navigationBar.addShadow(radius: 6, opacity: 0.05)
        addNavigationBar(extendedLayout: 20, belowSubview: searchBar)
    }
    
    func layoutInitialization() {
        searchBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(navigationBar.snp.bottom).inset(6)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    func dataUpdates() {
        let item = MASearchModel(JSON: MASearchData.JsonData())
        dataList = MASearchData.dataGroups(from: item, historyCache: historyCache)
        collectionView.reloadData()
    }
}

extension MASearchViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return MASearchConst.headerReferenceSize(with: dataList[section])
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return MASearchConst.lineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return MASearchConst.itemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return MASearchConst.sectionInset(with: dataList[section])
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return MASearchConst.itemLayoutSize(with: dataList[indexPath.section], at: indexPath)
    }
}

extension MASearchViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList[section].listCount ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let headerView = collectionView.dequeueReusableHeader(withClass: MASearchHeaderView.self, for: indexPath)
        headerView.group = dataList[indexPath.section]
        headerView.delegate = self
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let group = dataList[indexPath.section]
        switch group.type {
        case .histories:
            guard let list = group.historiesList, !list.isEmpty else {
                let cell = collectionView.dequeueReusableCell(withClass: MASearchHistoriesEmptyCell.self, for: indexPath)
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withClass: MASearchHistoriesCell.self, for: indexPath)
            cell.item = group.historiesList?[indexPath.item]
            cell.itemIndex = indexPath.item
            cell.delegate = self
            return cell
        case .discover:
            let cell = collectionView.dequeueReusableCell(withClass: MASearchDiscoverCell.self, for: indexPath)
            cell.item = group.discoverList?[indexPath.item]
            cell.itemIndex = indexPath.item
            cell.delegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withClass: MASearchPagesCell.self, for: indexPath)
            cell.topItems = group.topList
            cell.delegate = self
            return cell
        }
    }
}

extension MASearchViewController {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.textField.resignFirstResponder()
    }
}

extension MASearchViewController: MASearchHistoriesCellDelegate, MASearchHeaderViewDelegate {
    
    func historiesCell(_ historiesCell: MASearchHistoriesCell, didSelectItemAt index: Int) {
        guard let item = historiesCell.item else { return }
        historyCache.save(item)
        dataUpdates()
        pushSearchResultViewController(with: item.name)
    }
    
    func historiesCell(_ historiesCell: MASearchHistoriesCell, didDeleteItemAt index: Int) {
        guard let item = historiesCell.item else { return }
        historyCache.remove(item)
        dataUpdates()
    }
    
    func headerViewDidClearHistories(_ headerView: MASearchHeaderView) {
        historyCache.clear()
        dataUpdates()
    }
}

extension MASearchViewController: MASearchDiscoverCellDelegate {
    
    func discoverCell(_ discoverCell: MASearchDiscoverCell, didSelectItemAt index: Int) {
        guard let item = discoverCell.item else { return }
        historyCache.save(MASearchHistoryItem.create(item.name))
        dataUpdates()
        pushSearchResultViewController(with: item.name)
    }
}

extension MASearchViewController: MASearchPagesCellDelegate {
    
    func pageCell(_ pageCell: MASearchPagesCell, didSelectItemAt indexPath: IndexPath) {
        guard let tops = pageCell.topItems else { return }
        let top = tops[indexPath.section]
        guard let item = top.items?[indexPath.item] else { return }
        historyCache.save(MASearchHistoryItem.create(item.name))
        dataUpdates()
        pushSearchResultViewController(with: item.name)
    }
    
    func pushSearchResultViewController(with name: String?) {
        let vc = MASearchListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
