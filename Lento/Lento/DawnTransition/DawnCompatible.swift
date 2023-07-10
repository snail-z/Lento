//
//  DawnCompatible.swift
//  DawnTransition
//
//  Created by zhang on 2022/6/9.
//

import Foundation

public protocol DawnCompatible {
    
    associatedtype CompatibleType
    var dawn: DawnExtension<CompatibleType> { get set }
}

public extension DawnCompatible {
    
    var dawn: DawnExtension<Self> {
        get { return DawnExtension(self) }
        // swiftlint:disable unused_setter_value
        set { }
    }
}

public class DawnExtension<Base> {
    
    public let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
