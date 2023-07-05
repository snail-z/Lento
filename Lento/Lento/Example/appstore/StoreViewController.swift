//
//  StoreViewController.swift
//  Lento
//
//  Created by zhang on 2023/6/30.
//

import UIKit

class StoreViewController: UIViewController {
    
    private var dataList = [StoreItemModel]()
    private var targetView: UIView?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = (UIScreen.main.bounds.width - 40)*1.22
        tableView.separatorStyle = .none
        tableView.register(StoreCell.self, forCellReuseIdentifier: StoreCell.description())
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        view.dawn.addPanGestureRecognizer(DawnPanGestureRecognizer(driver: self, type: .dismiss) { [weak self] in
            self?.dismiss(animated: true)
        })
    }

    var pathway: DawnAnimatePathway!
}

extension StoreViewController {
    private func setupData() {
        for i in 0...9 {
            let storeItem = StoreItemModel(title: "talk is cheap,\nshow me the code!", subTitle: "Hello World!", imageName: "image\(i)", content: "史蒂夫·乔布斯 [1]  （Steve Jobs，1955年2月24日—2011年10月5日 [2]  ），出生于美国加利福尼亚州旧金山，美国发明家、企业家、美国苹果公司联合创办人。 [3]\n\n1976年4月1日，乔布斯签署了一份合同，决定成立一家电脑公司。 [1]  1977年4月，乔布斯在美国第一次计算机展览会展示了苹果Ⅱ号样机。1997年苹果推出iMac，创新的外壳颜色透明设计使得产品大卖，并让苹果度过财政危机。 [4]  2011年8月24日，史蒂夫·乔布斯向苹果董事会提交辞职申请。 [5]\n\n乔布斯被认为是计算机业界与娱乐业界的标志性人物，他经历了苹果公司几十年的起落与兴衰，先后领导和推出了麦金塔计算机（Macintosh）、iMac、iPod、iPhone、iPad等风靡全球的电子产品，深刻地改变了现代通讯、娱乐、生活方式。乔布斯同时也是前Pixar动画公司的董事长及行政总裁。 [6]\n\n2011年10月5日，史蒂夫·乔布斯因患胰腺神经内分泌肿瘤 [7]  病逝，享年56岁。 [2] ")
            dataList.append(storeItem)
        }
        tableView.reloadData()
    }
    private func setupUI() {
        view.addSubview(tableView)
    }
}

extension StoreViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreCell.description(), for: indexPath)
        if let customCell = cell as? StoreCell {
            customCell.item = dataList[indexPath.section]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StoreCell else {
            return
        }
        targetView = cell.bgImageView
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                cell.layoutIfNeeded()
            }, completion: { (_) in
                let vc = StoreDetailViewController(storeItem: self.dataList[indexPath.section])
                vc.dawn.isTransitioningEnabled = true
                self.pathway = DawnAnimatePathway(source: self, target: vc)
                self.pathway.duration = 2.75
//                self.pathway.sourcePathwayView = cell.bgImageView.dawn.snapshotView()
//                self.pathway.sourceBGView = cell.bgImageView
                vc.dawn.transitionCapable = self.pathway
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            })
        }
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath) as! StoreCell
        UIView.animate(withDuration: 0.2) {
            cell.bgImageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.9, 0.9, 1)
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StoreCell else { return }
        UIView.animate(withDuration: 0.2) {
            cell.bgImageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
}

extension StoreViewController: DawnTransitioningAnimatePathway {
    
    func dawnAnimatePathwayView() -> UIView? {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StoreCell else {
            return nil
        }
        
        
//        DispatchQueue.main.async {
//            cell.layoutIfNeeded()
//        }
        
        
//        return cell.bgImageView
        return targetView
    }
}

extension StoreDetailViewController: DawnTransitioningAnimatePathway {
    
    func dawnAnimatePathwayView() -> UIView? {
        return view
    }
}
