//
//  MAHistoryCache.swift
//  Lento
//
//  Created by zhang on 2022/10/22.
//

import Foundation

/// todo - 线程安全

@objc public protocol MAHistoryCacheAble {
    
    /// 需要保存的数据
    @objc var historyParameters: [String: Any]? { get }

    /// 数据唯一标识
    @objc var historyIdentifier: String? { get }
}

public class MAHistoryCache {
    
    @objc public init(standardKey: String!, storageCount: Int = 10) {
        self.standardKey = standardKey
        self.storageCount = storageCount
    }
    
    /// 存储本地的Key
    @objc public private(set) var standardKey: String!
    
    /// 存储最大条数
    @objc public private(set) var storageCount: Int
    
    /// 获取历史数据
    @objc public var storageValues: [[String: Any]]? {
        let values: [[String: Any]]?
        if let objs = cacheObjects {
            values = objs
        } else {
            values = UserDefaults.standard.array(forKey: standardKey) as? [[String: Any]]
        }
        guard let _ = values else { return nil }
        for var element in values! {
            element.removeValue(forKey: MAHistoryCacheIdentifierKey)
        }
        return values
    }
    
    /// 保存数据
    @objc public func save(_ object: MAHistoryCacheAble) {
        guard let resKey = object.historyIdentifier else { return }
        /// 上锁
        guard var resValues = object.historyParameters else { return }
        resValues.updateValue(resKey, forKey: MAHistoryCacheIdentifierKey)
        
        var temps = [[String: Any]]()
        if let values = UserDefaults.standard.array(forKey: standardKey) as? [[String: Any]] {
            temps.append(contentsOf: values)
        }

        var hasKey = false, deleteIndex: Int = 0
        for (index, obj) in temps.enumerated() {
            guard obj[MAHistoryCacheIdentifierKey] as? String == resKey else { continue }
            deleteIndex = index
            hasKey = true
            break
        }
        
        if hasKey {
            // 1.有重复-直接替换到首位
            temps.remove(at: deleteIndex)
            temps.insert(resValues, at: 0)
        } else {
            // 2.没有重复-判断是否超出限制
            if temps.count < storageCount {
                // a. 未超出限制，直接插入新值
                temps.insert(resValues, at: 0)
            } else {
                // b. 超出限制，则删除最后一个，然后插入新值
                temps.removeLast()
                temps.insert(resValues, at: 0)
            }
        }
        cacheObjects = temps
        /// 解锁
        UserDefaults.standard.set(temps, forKey: standardKey)
    }
    
    /// 删除数据
    @objc public func remove(_ object: MAHistoryCacheAble) {
        return remove(withIdentifier: object.historyIdentifier)
    }
    
    /// 删除数据(根据唯一标识)
    @objc public func remove(withIdentifier identifier: String?) {
        guard let resKey = identifier else { return }
        guard var temps = UserDefaults.standard.array(forKey: standardKey) as? [[String: Any]] else { return }
        var hasKey = false, deleteIndex: Int = 0
        for (index, obj) in temps.enumerated() {
            guard obj[MAHistoryCacheIdentifierKey] as? String == resKey else { continue }
            deleteIndex = index
            hasKey = true
            break
        }
        guard hasKey else { return }
        temps.remove(at: deleteIndex)
        guard !temps.isEmpty else {
            return clear()
        }
        cacheObjects = temps
        UserDefaults.standard.set(temps, forKey: standardKey)
    }
    
    /// 清除全部数据
    @objc public func clear() {
        cacheObjects = nil
        UserDefaults.standard.removeObject(forKey: standardKey)
    }
    
    /// 过滤有效数据
    @objc public func filter(withValidObjects objects: [MAHistoryCacheAble]?) {
        return filter(withValidIdentifiers: objects?.compactMap { $0.historyIdentifier })
    }
    
    /// 过滤有效数据(根据唯一标识)
    @objc public func filter(withValidIdentifiers identifiers: [String]?) {
        guard let validIdentifiers = identifiers, !validIdentifiers.isEmpty else { return }
        var temps = [[String: Any]]()
        if let values = UserDefaults.standard.array(forKey: standardKey) as? [[String: Any]] {
            temps.append(contentsOf: values)
        }
        
        // a.查找出不在有效数据范围内的历史数据
        var deleteIndexset = IndexSet()
        for (index, obj) in temps.enumerated() {
            let aKey = obj[MAHistoryCacheIdentifierKey] as? String
            guard (validIdentifiers.contains { $0 == aKey }) else { continue }
            deleteIndexset.insert(index)
        }
        // b.根据索引删除失效的历史数据
        for index in deleteIndexset {
            temps.remove(at: index)
        }
        
        guard !temps.isEmpty else {
            return clear()
        }
        cacheObjects = temps
        UserDefaults.standard.set(temps, forKey: standardKey)
    }
    
    private var cacheObjects: [[String: Any]]?
    private let MAHistoryCacheIdentifierKey = "MAHistoryCacheIdentifierKey"
}
