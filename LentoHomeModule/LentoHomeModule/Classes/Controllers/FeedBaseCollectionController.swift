//
//  FeedBaseCollectionController.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//

import UIKit
import IGListKit

class FeedBaseCollectionController: UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        adapter.collectionView = collectionView
        view.addSubview(collectionView)
    }

    open override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }

    open lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        updater.delegate = self
        let adapter = ListAdapter(updater: updater, viewController: self)
        adapter.delegate = self
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        return adapter
    }()

    open lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout.init()
//        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 50)
        let layout = ListCollectionViewLayout(stickyHeaders: true, topContentInset: 0, stretchToEdge: false)
        let cololayout = ListCollectionViewLayout.init(stickyHeaders: true, topContentInset: 0, stretchToEdge: true)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    open lazy var emptyView: UIView = {
        let emptyView = UIView(frame: collectionView.bounds)
        emptyView.backgroundColor = UIColor.random(.granite)
        return emptyView
    }()

    open var diffObjects: [ListDiffable] = []
}

extension FeedBaseCollectionController: IGListAdapterDelegate {

    public func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
    }

    public func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
    }
}

extension FeedBaseCollectionController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

extension FeedBaseCollectionController: ListAdapterDataSource {

    open func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyView
    }

    open func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return diffObjects
    }

    open func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ListSectionController()
    }
}

extension FeedBaseCollectionController: ListAdapterUpdaterDelegate {

    public func listAdapterUpdater(_ listAdapterUpdater: ListAdapterUpdater, willPerformBatchUpdatesWith collectionView: UICollectionView) {
    }

    public func listAdapterUpdater(_ listAdapterUpdater: ListAdapterUpdater, didPerformBatchUpdates updates: ListBatchUpdateData, collectionView: UICollectionView) {
    }

    public func listAdapterUpdater(_ listAdapterUpdater: ListAdapterUpdater, willInsert indexPaths: [IndexPath], collectionView: UICollectionView) {
    }

    public func listAdapterUpdater(_ listAdapterUpdater: ListAdapterUpdater, willDelete indexPaths: [IndexPath], collectionView: UICollectionView) {
    }

    public func listAdapterUpdater(_ listAdapterUpdater: ListAdapterUpdater, willMoveFrom fromIndexPath: IndexPath, to toIndexPath: IndexPath, collectionView: UICollectionView) {
    }

    public func listAdapterUpdater(_ listAdapterUpdater: ListAdapterUpdater, willReload indexPaths: [IndexPath], collectionView: UICollectionView) {
    }

    public func listAdapterUpdater(_ listAdapterUpdater: ListAdapterUpdater, willReloadSections sections: IndexSet, collectionView: UICollectionView) {
    }

    public func listAdapterUpdater(_ listAdapterUpdater: ListAdapterUpdater, willReloadDataWith collectionView: UICollectionView) {
    }

    public func listAdapterUpdater(_ listAdapterUpdater: ListAdapterUpdater, didReloadDataWith collectionView: UICollectionView) {
        let alwaysBounceVertical = collectionView.backgroundView?.isHidden ?? true
        if alwaysBounceVertical != collectionView.alwaysBounceVertical {
            collectionView.alwaysBounceVertical = alwaysBounceVertical // 是否禁止下拉刷新
        }
    }

    public func listAdapterUpdater(_ listAdapterUpdater: ListAdapterUpdater, collectionView: UICollectionView, willCrashWith exception: NSException, from fromObjects: [Any]?, to toObjects: [Any]?, updates: ListBatchUpdateData) {
    }
}
