//
//  MASearchData.swift
//  Lento
//
//  Created by zhang on 2022/10/27.
//

import UIKit
import ObjectMapper
import LentoBaseKit

struct MASearchData {

    static func JsonData() -> [String: Any] {
        guard let values = LentoFeedUtility.bundle?.contentsOfFile(named: "Search1") as? [String: Any] else {
            return [:]
        }
        return values["content"] as? [String: Any] ?? [:]
    }

    static func dataGroups(from listItem: MASearchModel?, historyCache: MAHistoryCache) -> [MASearchGroup] {
        var groups = [MASearchGroup]()
        
        var group = MASearchGroup.init(type: .histories)
        group.title = "搜索历史"
        if let objects = historyCache.storageValues, !objects.isEmpty {
            let items = objects.map { MASearchHistoryItem.create($0) }
            group.historiesList = items
        }
        groups.append(group)
        
        if let list = listItem?.discoverList, !list.isEmpty {
            var group = MASearchGroup.init(type: .discover)
            group.title = "搜索发现"
            group.discoverList = list
            groups.append(group)
        }
        
        if let list = listItem?.topList, !list.isEmpty {
            var group = MASearchGroup.init(type: .topList)
            group.topList = list
            groups.append(group)
        }
        
        return groups
    }
}

struct MASearchGroup {
    
    init(type: GroupType) {
        self.type = type
    }
    
    enum GroupType {
        case none, histories, discover, topList
    }
    
    private(set) var type: GroupType = .none
    public var title: String?
    public var image: String?
    public var historiesList: [MASearchHistoryItem]?
    public var discoverList: [MASearchLeftItem]?
    public var topList: [MASearchTopListItem]?
    
    public var listCount: Int? {
        switch type {
        case .histories:
            guard let list = historiesList, !list.isEmpty else { return 1 }
            return list.count
        case .discover:
            return discoverList?.count
        case .topList:
            return 1
        default:
            return nil
        }
    }
}

class MASearchModel: LentoBaseModel {
    
    var discoverList: [MASearchLeftItem]?
    var topList: [MASearchTopListItem]?
    
    override func mapping(map: Map) {
        discoverList <- map["discover"]
        topList <- map["tops"]
    }
}

class MASearchHistoryItem: LentoBaseModel, MAHistoryCacheAble {
    
    var name: String?
    
    var historyParameters: [String : Any]? {
        return ["name": name ?? ""]
    }
    
    var historyIdentifier: String? {
        return name
    }
    
    static func create(_ historyParameters: [String : Any]?) -> MASearchHistoryItem {
        return create(historyParameters?["name"] as? String)
    }
    
    static func create(_ name: String?) -> MASearchHistoryItem {
        let item = MASearchHistoryItem()
        item.name = name
        return item
    }
}

class MASearchLeftItem: LentoBaseModel {
    
    var nId: Int?
    var name: String?
    var hot: String?
    
    override func mapping(map: Map) {
        nId <- map["nId"]
        name <- map["name"]
        hot <- map["hot"]
    }
}

class MASearchTopListItem: LentoBaseModel {

    public var style: Int?
    public var title: String?
    public var items: [MASearchTopItem]?
    
    override func mapping(map: Map) {
        style <- map["style"]
        title <- map["title"]
        items <- map["topList"]
    }
}

class MASearchTopItem: LentoBaseModel {
    
    public enum TrendType {
        case none, rise, fall
    }
    
    public var level: Int?
    public var name: String?
    public var trend: Int?
    
    public var trendType: TrendType {
        switch trend {
        case 1: return .rise
        case 2: return .fall
        default: return .none
        }
    }
    
    override func mapping(map: Map) {
        level <- map["level"]
        name <- map["name"]
        trend <- map["trend"]
    }
}
