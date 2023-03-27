//
//  NetworkAdapter.swift
//  Lento
//
//  Created by corgi on 2022/8/19.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

/// 模拟网络层
public class NetworkAdapter: NSObject {

    
    public func loadNextPage() -> Observable<String> {
        let adapter = NetworkAdapter.init()
    
        let sd = adapter.rx.request(api: 9).map { sdk -> String in
            return sdk+"s123456+ABCK"
        } .asObservable() .catch { errors -> Observable<String> in
            
            return Observable.just("errors")
        }
        return sd
        
    }
}

public extension Reactive where Base: NetworkAdapter {
    
    
    func request(api: Int) -> Single<String> {
        return Single.create { single in
            let isK = true
            if isK {
                single(.success("多抓鱼6666666"))
            } else {
                let error = NSError.init(domain: "", code: 5)
//                single(.error(error))
            }
            let cancellableToken: Cancellable?
            return Disposables.create {
//                cancellableToken?.cancel()
            }
        }
    }
    
    func moyaReq() -> Single<[String: Any]> {
        
        return Single<[String: Any]>.create { single in
            
//            let pr = MoyaProvider.init()
            
            
            
            return Disposables.create {
                
            }
        }
    }
}

