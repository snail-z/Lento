//
//  FeedViewController.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//

import UIKit
import IGListKit
import ReactorKit
import RxCocoa
import RxSwift
import RxViewController

//final class FeedReactor: Reactor {
//    lazy var initialState: State = {
//        var state = State()
//        return state
//    }()
//    
//    enum Action {
//        case loadCache
//    }
//    
//    enum Mutation {
//        case refreshCartNum(num: Int, url: String)
//        case freedClassGuide(show: Bool)
//        case batchUpdateStructure([String: [String: Any]])
//    }
//    
//    struct State {
//        var sessionId: String = "" // 猜你喜欢使用
//        var requestId: String = "" // 首页推荐模块使用
//        var lastPosition: Int = 0 // 透传
//    }
//    
//    func hs() {
//    
//        
//    }
//}



class FeedViewController: FeedBaseCollectionController {
    
    open var disposeBag = DisposeBag()
  
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        reactor = Reactor()
//
//        reactor = Reactor.init()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(nibName: nil, bundle: nil)
////        reactor = Reactor()
//
//
//
//    }
    
//    typealias Reactor = FeedReactor
//
//    func bind(reactor: Reactor) {
//
//    }
    
    func hahahtest() {
        
        self.rx.viewDidLoad
            .subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                print("调用了viewDidLoad")
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles = ["善良的空间上看到就分开了时间的手机发的是快乐的就放手离开家粉丝来的空间逢山开路打飞机撒地方看见",
                      "是独立开发建设的空间",
                      "中国速度🇨🇳良的开国速度🇨🇳良的开发建设看国速度🇨🇳良的开发建设看国速度🇨🇳良的开发建设看国速度🇨🇳良的开发建设看国速度🇨🇳良的开发建设看国速度🇨🇳良的开发建发建设看的风景开始的风景上课了"]
        var elements = [FeedModel]()
        for idx in 0...100 {
            let model = FeedModel()
            model.title = "title - \(idx)"
            
            model.content = titles.element(safe: titles.randomIndex, default: "")
            if idx % 2 != 0 {
                model.structureType = .feedAd
            } else {
                model.structureType = .fish
            }
            elements.append(model)
        }
        diffObjects = elements
        adapter.reloadData(completion: nil)
     
        
        let reactor = FeedReactor.init()
        
        hahahtest()
        
    }
}

extension FeedViewController {
    
    override func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let obj = object as? FeedModel  else {
            /// model类型未匹配，返回一个默认的 ListSectionController 防崩溃
            let lisec = ListSectionController()
            return lisec
        }
        let type = obj.structureType
        let section = takeSectionController(with: type)
        section.inset = UIEdgeInsets(top: 55, left: 0, bottom: 0, right: 0)
        return section;
    }
    
    private func takeSectionController(with type: StructureType) -> ListSectionController {
        switch type {
        case .feedAd:
            return FeedAdSectionController()
        case .fish:
            return FeedFishSectionController()
        case .none:
            return FeedAdSectionController()
        case .noMore:
            return FeedAdSectionController()
        }
    }
}

