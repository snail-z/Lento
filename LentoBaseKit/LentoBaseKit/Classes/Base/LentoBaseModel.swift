//
//  LentoBaseModel.swift
//  Lento
//
//  Created by zhang on 2022/10/22.
//

import UIKit
import ObjectMapper

open class LentoBaseModel: Mappable {

    public init() {}
    required public init?(map: ObjectMapper.Map) {}
    open func mapping(map: ObjectMapper.Map) {}
}
