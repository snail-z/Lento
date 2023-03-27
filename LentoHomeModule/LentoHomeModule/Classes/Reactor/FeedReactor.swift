//
//  FeedReactor.swift
//  Lento
//
//  Created by corgi on 2022/8/20.
//

import Foundation
import RxSwift
import LentoNetworkModule

final class FeedReactor {
    
    var network: NetworkAdapter = NetworkAdapter.init()
    
    
}

extension FeedReactor {
    
    func loadModule() -> Observable<String> {
        
        return network.loadNextPage()
        
//        return Observable.just("sd")
    }
}
