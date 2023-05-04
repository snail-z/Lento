//
//  WidgetExtensions.swift
//  LentoWidgetExtension
//
//  Created by zhang on 2023/4/13.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension URL {

    /// 返回拼接参数后的URL
    ///
    ///        let url = URL(string: "https://google.com")!
    ///        let param = ["q": "Amassing Swift"]
    ///        url.appendingQueryParameters(params) -> "https://google.com?q=Amassing%20Swift"
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url!
    }
}
extension String {
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved)!
    }
}

extension CharacterSet {
    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}
