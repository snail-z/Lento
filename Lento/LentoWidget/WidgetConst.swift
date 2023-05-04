//
//  WidgetConst.swift
//  LentoWidgetExtension
//
//  Created by zhang on 2023/4/13.
//

import SwiftUI
import WidgetKit

struct Const {
    static let placeholder = Color("CommonPlaceholderColor")
    static let lightBackground = LinearGradient(gradient: Gradient(colors: [Color(hex: 0xE2E2E2), Color(hex: 0xFFFFFF)]), startPoint: .top, endPoint: .bottom)
    static let darkBackground = LinearGradient(gradient: Gradient(colors: [Color(hex: 0x363636), Color(hex: 0x595959)]), startPoint: .top, endPoint: .bottom)
}

struct WidgetName {
    static let search = "xx搜索"
    static let study = "xxx"
    static let notes = "创建笔记"
}

struct Util {

    static func widgetURL(_ URLString: String, widgetName: String) -> URL {
        let url = URL(string: URLString)!
        return url.appendingQueryParameters(["source": "widget", "widgetName": widgetName])
    }
}
