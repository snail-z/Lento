//
//  MADebugMenuConfig.swift
//  Lento
//
//  Created by zhang on 2023/3/16.
//

import UIKit

enum MADebugClassType: String {
    
    case none = "MADebugBaseViewController"
    case info = "MADebugInfoViewController"
    case sandbox = "MADebugSandboxViewController"
    case network = "MADebugNetworkController"
}

fileprivate func DebugClassFromString(_ className: String) -> AnyClass! {
    if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
        let classStringName = appName + "." + className
        return NSClassFromString(classStringName)
    }
    return nil;
}

extension UIViewController {
    
    func jump(_ item: MADebugMenuItem) {
        if let aClass = DebugClassFromString(item.next.rawValue) {
            let vc = (aClass as! UIViewController.Type).init()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class MADebugMenuItem: NSObject {
    
    var icon: String?
    var desc: String?
    var next: MADebugClassType = .none
    var tapped: ((_ sender: UIViewController) -> Void)?
    
    var short: String {
        if let value = icon, !value.isBlank {
            return value
        }
        return desc?.firstCharacter ?? ""
    }
}

class MADebugMenuConfig: NSObject {

    static func menuItems() -> [MADebugMenuItem]? {
        var dataItems = [MADebugMenuItem]()
        
        let item1 = MADebugMenuItem()
        item1.desc = "基本信息"
        item1.icon = "息"
        item1.next = .info
        item1.tapped = { $0.jump(item1) }
        dataItems.append(item1)
        
        let item2 = MADebugMenuItem()
        item2.desc = "文件浏览"
        item2.next = .sandbox
        item2.tapped = { $0.jump(item2) }
        dataItems.append(item2)
        
        let item3 = MADebugMenuItem()
        item3.desc = "清理缓存"
        item3.icon = "缓"
        dataItems.append(item3)
        
        let item4 = MADebugMenuItem()
        item4.desc = "网络日志"
        item4.next = .network
        item4.tapped = { $0.jump(item4) }
        dataItems.append(item4)
        
        let item5 = MADebugMenuItem()
        item5.desc = "Tap日志"
        dataItems.append(item5)
        
        let item6 = MADebugMenuItem()
        item6.desc = "页面日志"
        dataItems.append(item6)
        
        let item10 = MADebugMenuItem()
        item10.desc = "崩溃日志"
        dataItems.append(item10)
        
        let item7 = MADebugMenuItem()
        item7.desc = "方法耗时"
        dataItems.append(item7)
        
        let item8 = MADebugMenuItem()
        item8.desc = "内存泄露"
        dataItems.append(item8)
        
        let item9 = MADebugMenuItem()
        item9.desc = "Performance"
        dataItems.append(item9)
        
        let itemM1 = MADebugMenuItem()
        itemM1.desc = "Token调试"
        dataItems.append(itemM1)
        
        let itemMM = MADebugMenuItem()
        itemMM.desc = "模拟定位"
        itemMM.icon = "定"
        dataItems.append(itemMM)
        
        let itemM2 = MADebugMenuItem()
        itemM2.desc = "切换环境"
        dataItems.append(itemM2)
        
        let itemK1 = MADebugMenuItem()
        itemK1.desc = "颜色检查"
        itemK1.icon = "色"
        dataItems.append(itemK1)
        
        let itemK2 = MADebugMenuItem()
        itemK2.desc = "对齐卡尺"
        itemK2.icon = "尺"
        dataItems.append(itemK2)
        
        return dataItems
    }
}
