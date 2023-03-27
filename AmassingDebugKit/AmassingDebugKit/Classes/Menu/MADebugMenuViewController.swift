//
//  MADebugMenuViewController.swift
//  Lento
//
//  Created by zhang on 2023/3/15.
//

import UIKit
import AmassingExtensions

public class MADebugMenuViewController: MADebugBaseViewController {

    var collectionView: UICollectionView!
    var dataList: [MADebugMenuItem]?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        commonInitialization()
        dataUpdates()
    }
    
    func commonInitialization() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .vertical
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(cellWithClass: MADebugMenuViewCell.self)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func dataUpdates() {
        dataList = MADebugMenuConfig.menuItems()
        collectionView.reloadData()
    }
}

extension MADebugMenuViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let inset = flowLayout.sectionInset
        let equant = CGHorizontalEquantLayout1(count: 3, leadSpacing: inset.left, tailSpacing: inset.right)
        let width = equant.equalWidthThatFits(flowLayout.minimumInteritemSpacing)
        return CGSize(width: width, height: width)
    }
}

extension MADebugMenuViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MADebugMenuViewCell.self, for: indexPath)
        cell.item = dataList?[indexPath.item]
        return cell
    }
}

extension MADebugMenuViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataList?[indexPath.item].tapped?(self)
    }
}
