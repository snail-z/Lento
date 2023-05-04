//
//  iOS_Interview2.swift
//  LentoFeedModule
//

/**
 Object-C：
 1. setNeedsLayout、layoutSubviews、layoutIfNeeded、setNeedsDisplay、drawRect的理解?
 2. UIView和CALayer区别？
 3. iOS事件传递、响应链的理解? 以及使用场景
 4. 如何手动触发一个value的KVO?
 5. 分类和类扩展的区别? 分类能否添加属性?
 6. NSString类型为什么要用copy修饰?
 7. Block为什么用copy修饰？
 8. 常用的设计模式有哪些？
 9. delegate和block的区别是什么?
 10. UIViewController的生命周期
 11. UIScrollView中使用Autolayout会出现什么问题?
 12. UITableView如何优化?
 
 Swift：
 1. class和结构体struct有什么区别?
 2. 值类型和引用类型？
 3. 存储属性和计算属性?
 4. inout关键字有什么作用?
 
 底层进阶：
 1. weak属性？
 2. iOS中block 捕获外部局部变量实际上发生了什么？__block 中又做了什么？
 
 项目：
 1. 项目中遇到过哪些问题(技术难点)、怎么解决优化的？
 2. 开发中导致Crash的原因有哪些，如何做防护的？
 3. 你接触到的项目，哪些场景运用到了线程安全？
 4. 说说你了解到第三方框架原理或底层知识？
 5. 一般开始做一个项目，你的架构是如何思考的？
 */



/** 12. UITableView如何优化?
 提前计算并缓存好高度(布局)，因为 heightForRowAtIndexPath:是调
 用最频繁的方法;
 异步绘制，遇到复杂界面，遇到性能瓶颈时，可能就是突破口;
 滑动时按需加载，这个在大量图片展示，网络加载的时候很管用! (SDWebImage 已经实现异步加载，配合这条性能杠杠的)。
 正确使用 reuseIdentifier 来重用 Cells
 尽量使所有的 view opaque，包括 Cell 自身
 尽量少用或不用透明图层
 如果 Cell 内现实的内容来自 web，使用异步加载，缓存请求结果
 减少 subviews 的数量
 在 heightForRowAtIndexPath:中尽量不使用 cellForRowAtIndexPath:， 如果你需要用到它，只用一次然后缓存结果
 尽量少用 addView 给 Cell 动态添加 View，可以初始化时就添加，然 后通过 hide 来控制是否显示
 */
