//
//  AliPageSnapshotCache.swift
//  Lento
//
//  Created by zhang on 2023/7/3.
//

import UIKit

public class AliPageSnapshotCache {

    /// 用于控制转换的共享单例对象
    public static var shared = AliPageSnapshotCache()

    public private(set) lazy var cacheImages: [UIImage] = {
        let imgs = [UIImage]()
        return imgs
    }()
    
    public func addImage(_ image: UIImage?) {
        guard let img = image else { return }
        cacheImages.append(img)
    }
    
    public func clearImages() {
        cacheImages.removeAll()
    }
}
