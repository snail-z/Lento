//
//  AlipageViewController.swift
//  Lento
//
//  Created by zhang on 2023/6/30.
//

import UIKit
import AmassingExtensions
import LentoBaseKit
import AmassingUI

class AlipageViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataList: [AlipageModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //手势监听器
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture(_:)))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        commonInitialization()
        dataUpdates()
    }
    
    func commonInitialization() {
        let layout = UICollectionViewWaterfallLayout.init()
        layout.columnCount = 2
        layout.minimumColumnSpacing = 15
        layout.minimumInteritemSpacing = 15
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 20, right: 0)
        collectionView.register(cellWithClass: AlipageCell.self)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func dataUpdates() {
        let imgs = AliPageSnapshotCache.shared.cacheImages
        print("imgs====> \(imgs)")
        
        collectionView.pk.beginLoading(text: "正在加载", offset: -150)
        DispatchQueue.asyncAfter(delay: 0.25) {
            self.collectionView.pk.endLoading()
            let array = imgs
            let values = array.map { s in
                return AlipageModel(tit: "title", imag: s)
            }
            self.dataList = values
            self.collectionView.reloadData()
        }
    }
    var targetView: UIView?
}

extension AlipageViewController: UICollectionViewDelegateWaterfallLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let model = dataList?[indexPath.item] else { return .zero }
        let image = model.takeImage()
        let equ = CGHorizontalEquantLayout1(count: 2, leadSpacing: 20, tailSpacing: 20)
        let eWidth = equ.equalWidthThatFits(20)
        let scale = image.size.width / image.size.height
        let eHeight = eWidth / scale
        return CGSize(width: eWidth, height: eHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
        let equ = CGHorizontalEquantLayout1(count: 2, leadSpacing: 20, tailSpacing: 20)
        return UIEdgeInsets(top: 0, left: equ.leadSpacing, bottom: 0, right: equ.tailSpacing)
    }
}

extension AlipageViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: AlipageCell.self, for: indexPath)
        cell.contentView.backgroundColor = .yellow
        cell.model = dataList?[indexPath.item]
        return cell
    }
}

extension AlipageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AlipageCell else { return }
        guard let model = dataList?[indexPath.item] else { return }
        targetView = cell.contentView
        let vc = AlipageLagerImageController()
        vc.ccimage = model.takeImage()
        vc.dawn.isTransitioningEnabled = true
        var pathway = DawnAnimatePathwayLarger(source: self, target: vc)
        pathway.duration = 0.275
        vc.dawn.transitionCapable = pathway
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension AlipageViewController: DawnTransitioningAnimatePathwayLarger {
    
    func dawnAnimatePathwayView() -> UIView? {
        return targetView
    }
}

extension AlipageLagerImageController: DawnTransitioningAnimatePathwayLarger {
    
    func dawnAnimatePathwayView() -> UIView? {
        return view
    }
}

extension AlipageViewController {
    
    @objc func edgePanGesture(_ gr: UIScreenEdgePanGestureRecognizer) {
        let translation = gr.translation(in: self.view).x
        let distance = translation / (view.bounds.width)
        switch gr.state {
        case .began:
            Dawn.shared.driven(dismissing: self)
            dismiss(animated: true)
        case .changed:
            Dawn.shared.update(distance)
        default:
            let velocity = gr.velocity(in: view)
            if ((translation + velocity.x) / view.bounds.width) > 0.5 {
                Dawn.shared.finish()
            } else {
                Dawn.shared.cancel()
            }
        }
    }
}
