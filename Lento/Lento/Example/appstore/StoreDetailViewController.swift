//
//  StoreDetailViewController.swift
//  Lento
//
//  Created by zhang on 2023/6/30.
//

import UIKit

class StoreDetailViewController: UIViewController {
    
    var statusBarHidden = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    private var isDismiss = false
    
    private let storeItem: StoreItemModel
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = UIColor.white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        scrollView.isMultipleTouchEnabled = false
        scrollView.delaysContentTouches = true
//        scrollView.contentSize = CGSize(width: 200, height: self.view.height)
        return scrollView
    }()
    
    lazy var headerView: StoreDetailHeaderView = {
        let headerView = StoreDetailHeaderView(frame: CGRect.zero)
        headerView.item = self.storeItem
        headerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        return headerView
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = self.storeItem.content + self.storeItem.content
        label.backgroundColor = UIColor.white
        label.contentMode = .center
        label.font = .gillSans()
        return label
    }()
    
    init(storeItem: StoreItemModel) {
        self.storeItem = storeItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.orange
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        setupUI()
        
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGestureAction(_:)))
        
        edgePanGesture.edges = UIRectEdge.left
        view.addGestureRecognizer(edgePanGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        panGesture.require(toFail: edgePanGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    @objc private func closeButtonClick() {
        /// 当前页面截图
        let img = view.screenshots()
        let names = ["image0", "image1", "image2", "image3", "image4", "image5", "image6"]
        let img2 = UIImage(named: names[names.randomIndex])
        AliPageSnapshotCache.shared.addImage(img)
        AliPageSnapshotCache.shared.addImage(img2)
        self.dawn.transitionCapable = DawnAnimatePathwayChangeless()
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        
        view.layer.masksToBounds = true
        view.contentMode = .center
        
        view.addSubview(scrollView)
        view.addSubview(closeButton)
        scrollView.addSubview(headerView)
        scrollView.addSubview(contentLabel)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(64)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(36)
        }
        
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(headerView.snp.width).multipliedBy(1.34)
            make.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
            make.top.equalTo(headerView.snp.bottom).offset(30)
        }

    }

}

extension StoreDetailViewController {
 
    @objc private func  edgePanGestureAction(_ edgePanGesture: UIScreenEdgePanGestureRecognizer) {
        let progress = edgePanGesture.translation(in: view).x / view.bounds.width
        zoomWithProgress(progress, gesture: edgePanGesture)
        
    }
    
    @objc private func  panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        if scrollView.contentOffset.y > 0 && view.frame.size.width == UIScreen.main.bounds.width  {return}
        let progress = panGesture.translation(in: view).y / view.bounds.height
        zoomWithProgress(progress, gesture: panGesture)
    }

    private func zoomWithProgress(_ progress: CGFloat,gesture: UIGestureRecognizer) {
        let minScale: CGFloat = 0.83
        let scale = 1-progress*0.5
        if scale >= minScale {
            
            self.view.frame.size.width = UIScreen.main.bounds.width * scale
            self.view.frame.size.height = UIScreen.main.bounds.height * scale
            self.view.center = CGPoint(x: UIScreen.main.bounds.width*0.5, y: UIScreen.main.bounds.height*0.5)
            contentLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
            contentLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            let cornerRadius = (1.0-scale)/(1-minScale)*20
            self.view.layer.cornerRadius = cornerRadius
            
        }else {
            
            gesture.isEnabled = false
            isDismiss = true
            dismiss(animated: true, completion: nil)
            
            
            if isDismiss == false {
                
                isDismiss = true
                gesture.isEnabled = false
                self.view.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width*minScale, height: UIScreen.main.bounds.height*minScale)
                self.view.center = CGPoint(x: UIScreen.main.bounds.width*0.5, y: UIScreen.main.bounds.height*0.5)
                self.view.layoutIfNeeded()
                
                
                dismiss(animated: true) {
                    self.isDismiss = false
                }
            }
            return
        }
        
        switch gesture.state {
        case .began:
            break
        case .changed:
            break
        case .cancelled,.ended:
            if !isDismiss {
                print("CGAffineTransform.identity")
                UIView.animate(withDuration: 0.2) {
                    self.view.frame = UIScreen.main.bounds
                    self.contentLabel.transform = CGAffineTransform.identity
                }
            }else {
                print("dismiss")
                isDismiss = true
            }
        default:
            break
        }
    }
    
}


extension StoreDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if scrollView.contentOffset.y > .zero {
        } else {
            /// scrollView在顶部
            
        }
        
        if otherGestureRecognizer == scrollView.panGestureRecognizer {
            return true
        } else {
            return false
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        
        if gestureRecognizer == scrollView.panGestureRecognizer {
            return false
        } else {
            if let g = gestureRecognizer as? UIPanGestureRecognizer {
                let yvalue = g.velocity(in: view)
                
                print("yvalue=====> \(yvalue)")
                
                if yvalue.y < 0 {
                    return false
                }
            }
        }
        
        
        
        return true
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
}
