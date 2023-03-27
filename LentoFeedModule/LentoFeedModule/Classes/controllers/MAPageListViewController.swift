//
//  MAPageListViewController.swift
//  Lento
//
//  Created by zhang on 2022/10/31.
//

import UIKit
import LentoBaseKit

class FakeUIScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

class ListTableView: UITableView, UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

extension MAPageListViewController {
    
    struct Const {
        static let stikHeight: CGFloat = 200
        static let redHeight: CGFloat = 50
    }
}

class MAPageListViewController: LentoBaseViewController {

    var pageController: TJPageController!
    private var childControllers: [LentoBaseViewController]!
    var sizeKeyValues = [Int: CGSize]()
    var offsetKeyValues = [Int: CGPoint]()
    
    var redView: UIView!
    var topVew: UIView!
    var fakeScrollView: FakeUIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let page1VC = Page1ViewController()
        page1VC.view.tag = 0
        page1VC.delegate = self
        let page2VC = Page2ViewController()
        page2VC.view.tag = 1
        page2VC.delegate = self
        childControllers = [page1VC, page2VC]
        
        fakeScrollView = FakeUIScrollView()
        fakeScrollView.delegate = self
        fakeScrollView.showsVerticalScrollIndicator = false
        fakeScrollView.removeAutomaticallyAdjustsInsets()
        fakeScrollView.backgroundColor = .purple
        view.addSubview(fakeScrollView)
        
        topVew = UIView()
        topVew.backgroundColor = .yellow
        fakeScrollView.addSubview(topVew)
        
        redView = UIView()
        redView.backgroundColor = .red
        topVew.addSubview(redView)
        
        pageController = TJPageController()
        pageController.dataSource = self
        pageController.delegate = self
        pageController.scrollEnabled = true
        pageController.allowBounces = false
        addChild(pageController)
        fakeScrollView.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        
        setupLayout()
    }
    
    func setupLayout() {
        let top: CGFloat = 0
        let frame = CGRect(x: 0, y: 0, width: view.width, height: view.height - top - UIScreen.totalNavHeight - 0)
        fakeScrollView.frame = frame
        
        var topFrmae = frame
        topFrmae.size.height = Const.stikHeight
        topFrmae.origin.x = 0
        topFrmae.origin.y = .zero
        topVew.frame = topFrmae
        
        var pageFrame = frame
        pageFrame.origin.y = Const.stikHeight
        pageFrame.size.height = frame.height - Const.redHeight
        pageController.view.frame = pageFrame
        
        var redFrame = topFrmae
        redFrame.size.height = Const.redHeight
        redFrame.origin.x = .zero
        redFrame.origin.y = topFrmae.height - Const.redHeight
        redView.frame = redFrame
    }
}

extension MAPageListViewController: TJPageControllerDataSource {
    
    func numberOfPages(in pageController: TJPageController) -> Int {
        return childControllers.count
    }
    
    func pageController(_ pageController: TJPageController, pageAt index: Int) -> UIViewController {
        return childControllers[index]
    }
}

extension MAPageListViewController: TJPageControllerDelegate {
    
    func pageController(_ pageController: TJPageController, didUpdateTransition progress: CGFloat) {
//        print("didUpdateTransition===> \(progress)")
    }
    
    func pageControllerDidEndTransition(_ pageController: TJPageController) {
        let valu = sizeKeyValues[pageController.displayedIndex]
        UpdateFakeContentSize(valu ?? .zero)
        /// 调整offset
        if let ofsdfs = offsetKeyValues[pageController.displayedIndex] {
            fakeScrollView.setContentOffset(ofsdfs, animated: false)
        }
    }
    
    func pageControllerWillStartTransition(_ pageController: TJPageController) {
        print("pageControllerWillStartTransition")
        offsetKeyValues.updateValue(fakeScrollView.contentOffset, forKey: pageController.displayedIndex)
    }
}

extension MAPageListViewController: PageViewControllerContentChangedDelegate {
    
    func UpdateFakeContentSize(_ size: CGSize) {
        DispatchQueue.asyncAfter(delay: 0.1) {
            let height = size.height + Const.stikHeight
            self.fakeScrollView.contentSize = CGSize(width: self.fakeScrollView.width, height: height)
        }
    }
    
    func contentSizeChanged(_ contentSize: CGSize, sender: UIViewController) {
        print(" sender.view.tag=======>\( sender.view.tag)")
        print("变化了=======>\(contentSize)")
        sizeKeyValues.updateValue(contentSize, forKey: sender.view.tag)
        UpdateFakeContentSize(contentSize)
    }
}

extension MAPageListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let stikHeight = Const.stikHeight - Const.redHeight
        let offset = fakeScrollView.contentOffset
        print("scrollViewDidScroll offset===> \(offset)")
        
        var pageFrame = fakeScrollView.frame
        pageFrame.size.height = fakeScrollView.frame.height - Const.redHeight
        pageFrame.origin.y = stikHeight
        if offset.y > stikHeight {
            pageFrame.origin.y = offset.y + Const.redHeight
        } else {
            pageFrame.origin.y = stikHeight + Const.redHeight
        }
        pageController.view.frame = pageFrame
        
        let page1VC = pageController.displayedViewController as? PageViewControllerMustProxy
        if offset.y < stikHeight {
            page1VC?.pTableView.contentOffset = .zero
        } else {
            var listOffset = offset
            listOffset.y -= stikHeight
            page1VC?.pTableView.contentOffset = listOffset
        }

        var topFrmae = fakeScrollView.frame
        topFrmae.size.height = stikHeight
        topFrmae.origin.x = 0
        if offset.y <= 0 {
            topFrmae.origin.y = .zero
        } else {
            if offset.y < stikHeight {
                topFrmae.origin.y = .zero
            } else {
                topFrmae.origin.y = offset.y - stikHeight
            }
        }
        topVew.frame = topFrmae
    }
}
