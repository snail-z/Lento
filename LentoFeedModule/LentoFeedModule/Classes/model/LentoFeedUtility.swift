//
//  LentoFeedUtility.swift
//  AmassingExtensions
//
//  Created by zhang on 2023/3/25.
//

import UIKit

class LentoFeedUtility {
    
    /// 当前bundle
    static var bundle: Bundle? {
        return Bundle(path: Bundle(for: LentoFeedUtility.self).path(forResource: "LentoFeedModule", ofType: "bundle") ?? "")
    }
}
