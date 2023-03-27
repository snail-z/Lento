//
//  MAWaterfallLayoutViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/19.
//

import UIKit
import AmassingUI
import LentoBaseKit

extension MAWaterfallLayoutViewController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            let trands = MAWaterfallPushTransion()
            return trands
        default:
            return nil
        }
    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}

public class MAWaterfallLayoutViewController: LentoBaseViewController {

    var currentImageView: UIImageView!
    
    var dataList: [String]?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        
        
        let names = ["public-domain-images-free-stock-photos-high-quality-resolution-downloads-public-domain-archive-10", "1666772689346.jpg", "001"]
        var temps = [String]()
        for _ in 0...20 {
            let name = names[names.randomIndex]
            temps.append(name)
        }
        dataList = temps
        collectionView.reloadData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private var collectionView: UICollectionView!
    
    private func setup() {
        let layout = UICollectionViewWaterfallLayout.init()
        layout.columnCount = 2;
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellWithClass: MAWaterfallCell.self)
        view.addSubview(collectionView)
    }
    
    func layout() {
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

extension MAWaterfallLayoutViewController: UICollectionViewDelegateWaterfallLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let name = dataList![indexPath.item]
        let image = UIImage(named: name)
        return image?.size ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension MAWaterfallLayoutViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MAWaterfallCell.self, for: indexPath)
        let name = dataList![indexPath.item]
        cell.imageView.image = UIImage.init(named: name)
        return cell
    }
}

extension MAWaterfallLayoutViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let size: CGSize
        if indexPath.item.isOdd {
            size = CGSize(width: 100, height: 150)
        } else {
            size = CGSize(width: 100, height: 190)
        }
        print("size is: \(size)")
        
        let cell = collectionView.cellForItem(at: indexPath) as! MAWaterfallCell
        currentImageView = cell.imageView
        
        self.navigationController?.delegate = self
        let vc = MAWaterfallDetailViewController()
        vc.ccimage = currentImageView.image
        navigationController?.pushViewController(vc, animated: true)
    }
}
