//
//  MALeftAlignedData.swift
//  Lento
//
//  Created by zhang on 2022/10/22.
//

import UIKit
import LentoBaseKit
import ObjectMapper

struct MALeftAlignedData {
    
    static func JsonData() -> [String: Any] {
        guard let values = LentoFeedUtility.bundle?.contentsOfFile(named: "CityList") as? [String: Any] else { return [:] }
        return values["content"] as? [String: Any] ?? [:]
    }
    
    static func dataGroups(from listItem: MALeftAlignedListItem?, historyCache: MAHistoryCache) -> [MALeftAlignedGroup] {
        var groups = [MALeftAlignedGroup]()
        if let value = dataGroup1() {
            groups.append(value)
        }
        if let value = dataGroup2(with: historyCache) {
            groups.append(value)
        }
        if let value = dataGroup3(with: listItem) {
            groups.append(value)
        }
        if let values = dataGroup4(with: listItem) {
            groups.append(contentsOf: values)
        }
        return groups
    }
    
    static func indexTitles(with groups: [MALeftAlignedGroup]?) -> [String]? {
        let titles = groups?.compactMap({ group in
            switch group.type {
            case .location: return "定"
            default: return group.title?.firstCharacter
            }
        })
        return titles
    }
    
    static func dataGroup1() -> MALeftAlignedGroup? {
        var group = MALeftAlignedGroup(type: .location)
        group.title = "当前定位"
        group.items = [MALeftAlignedItem()]
        return group
    }
    
    static func dataGroup2(with historyCache: MAHistoryCache) -> MALeftAlignedGroup? {
        guard let objects = historyCache.storageValues else { return nil }
        let items = objects.map { MALeftAlignedItem.create(with: $0) }
        guard !items.isEmpty else { return nil }
        var group = MALeftAlignedGroup(type: .histories)
        group.title = "历史选择"
        group.subtitle = "清除全部"
        group.items = items
        return group
    }
    
    static func dataGroup3(with listItem: MALeftAlignedListItem?) -> MALeftAlignedGroup? {
        guard let list = listItem?.hotCityList, !list.isEmpty else { return nil }
        var group = MALeftAlignedGroup(type: .hotList)
        group.title = "热门城市"
        group.items = list
        return group
    }
    
    static func dataGroup4(with listItem: MALeftAlignedListItem?) -> [MALeftAlignedGroup]? {
        guard let list = listItem?.allCityList, !list.isEmpty else { return nil }
        let items = list.sorted { $0.letter?.compare($1.letter ?? "") == .orderedAscending }
        let groups = items.catalogues { $0.letter } map: { aKey, values in
            var group = MALeftAlignedGroup(type: .normalList)
            group.title = aKey
            group.items = values
            return group
        }
        return groups
    }
}

struct MALeftAlignedGroup {
    
    init(type: GroupType) {
        self.type = type
    }
    
    enum GroupType {
        case none, location, histories, hotList, normalList
    }
    
    private(set) var type: GroupType = .none
    public var title: String?
    public var subtitle: String?
    public var items: [MALeftAlignedItem]?
}

class MALeftAlignedListItem: LentoBaseModel {
    
    var allCityList: [MALeftAlignedItem]?
    var hotCityList: [MALeftAlignedItem]?

    override func mapping(map: Map) {
        allCityList <- map["allCityList"]
        hotCityList <- map["hotCityList"]
    }
}

class MALeftAlignedItem: LentoBaseModel {
    
    var cityId: Int?
    var cityName: String?
    var letter: String?
    var hot: String?
    
    override func mapping(map: Map) {
        cityId <- map["cityId"]
        cityName <- map["cityName"]
        letter <- map["letter"]
        hot <- map["hot"]
    }
}

extension MALeftAlignedItem: MAHistoryCacheAble {
    
    var historyParameters: [String : Any]? {
        return ["id": cityId ?? 0,
                "name": cityName ?? ""]
    }
    
    var historyIdentifier: String? {
        return cityId?.toString()
    }
    
    static func create(with historyParameters: [String : Any]?) -> MALeftAlignedItem {
        let item = MALeftAlignedItem()
        item.cityId = historyParameters?["id"] as? Int
        item.cityName = historyParameters?["name"] as? String
        return item
    }
}
