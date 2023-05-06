//
//  MARulerStyle.swift
//  MARulerView
//
//  Created by zhang on 2023/5/5.
//

import UIKit

public class MARulerStyle: NSObject {
    
    static var `default` = MARulerStyle()
    
    /// 刻度尺线条颜色
    public var lineColor: UIColor = .black
    
    /// 刻度之间的距离 (涉及位置的准确性，尽量不带小数)
    public var spacing: CGFloat = 25
    
    /// 刻度的宽度
    public var lineWidth: CGFloat = 1
    
    /// 长刻度的长度
    public var longLineDistance: CGFloat = 30
    
    /// 短刻度的长度
    public var shortLineDistance: CGFloat = 20
    
    /// 刻度尺文字字体
    public var indicatorFont: UIFont = .systemFont(ofSize: 12)
    
    /// 刻度尺文字颜色
    public var indicatorTextColor: UIColor = .black
    
    /// 刻度尺文字背景色
    public var indicatorBackgroundColor: UIColor = .clear
    
    /// 刻度文字与刻度尺水平线间距
    public var indicatorTopPadding: CGFloat = 6
    
    /// 刻度文字底部间距
    public var indicatorBottomPadding: CGFloat = .zero
    
    /// 刻度指示文字大小
    public var indicatorSize = CGSize(width: 26, height: 12)
    
    /// 刻度尺最小值
    public var minValue: Int = 0
    
    /// 刻度尺最大值
    public var maxValue: Int = 100
    
    /// 刻度尺精度 (能被1整除的效果会比较好)
    public var accuracy: CGFloat = 1
    
    /// 滚动内边距，默认nil将使用UIEdgeInsets(top: 0, left: 父视图bounds.width/2, bottom: 0, right: bounds.width/2)
    public var scrollContentInset: UIEdgeInsets? = nil
}
