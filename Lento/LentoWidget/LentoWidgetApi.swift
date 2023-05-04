//
//  LentoWidgetApi.swift
//  Lento
//
//  Created by zhang on 2023/4/13.
//

import UIKit

struct LentoProductSummary: Hashable {
    var title: String = ""
    var imageUrl: String = ""
    var image: UIImage?
    var ddUrl: String = ""
    var tag: String = ""
    var productId: Int = 0
    var productType: Int = 0
    
    static let shaoheng: LentoProductSummary = {
        var model = LentoProductSummary()
        model.title = "xx头条"
        model.tag = "课程"
        model.image = UIImage(named: "Study_xx")
        model.ddUrl = "xxx"
        return model
    }()
    static let luoji: LentoProductSummary = {
        var model = LentoProductSummary()
        model.title = "xx思维"
        model.tag = "课程"
        model.image = UIImage(named: "Study_xx")
        model.ddUrl = "xx"
        return model
    }()
    
    func JumpURL() -> String {
        switch productType {
        case 2:
            return "哈哈哈"
        default:
            return ddUrl
        }
    }
}
    
struct LentoPlaceholder: Hashable {
    var name: String = "name"
    var trackinfo: String = "trackinfo"
}

struct ImageHelper {
    static func downloadImage(url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            let image: UIImage? = UIImage(data: data!)
            completion(.success(image!))
        }
        task.resume()
    }
}
