//
//  DawnAnimationCard.swift
//  DawnTransition
//
//  Created by zhang on 2022/7/25.
//  Copyright (c) 2022 snail-z <haozhang0770@163.com> All rights reserved.
//

import UIKit

open class DawnAnimationCard: DawnAnimationTransform, DawnAnimationCapable {

    public func dawnAnimationPresentingAnimationType() -> DawnAnimationType {
        return .fade
    }

}
