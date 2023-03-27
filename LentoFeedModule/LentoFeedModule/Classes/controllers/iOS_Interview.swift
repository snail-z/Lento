//
//  iOS_Interview.swift
//  Lento
//
//  Created by zhang on 2023/3/6.
//

/**
 基础：
 1. 对setNeedsLayout ,layoutIfNeeded,setNeedsDisplay, layoutSubviews，drawRect的理解?
 2. UIView和CALayer区别?
 3. iOS事件传递、响应链的理解? - 使用场景
 4. 分类和类扩展的区别? 分类能否添加属性?
 6. 什么是野指针? 怎么造成的？如何检测？
 7. 开发中导致Crash的原因有哪些？
 8. NSString类型为什么要用copy修饰 ？
 9. 如何手动触发一个value的KVO?
 10. 你接触到的项目，哪些场景运用到了线程安全？
 11. 在使用 WKWedView 时遇到过哪些问题？
 12. 程序卡顿的原因? 界面卡顿的原因? 使用哪些检测工具？
 
 底层进阶：
 1. weak属性？
 2. iOS中block 捕获外部局部变量实际上发生了什么？__block 中又做了什么？
 
 Swift：
 1. class和结构体struct有什么区别?
 2. 值类型和引用类型？
 3. 存储属性和计算属性?
 4. inout关键字有什么作用?
 
 常用开发框架：(第三方) OC/swift
 1. 网络：AFNetworking/Moya
 2. 图片异步缓存：SDWebimage/Kingfisher
 3. 转模型解析：MJExtension、YYModel/ObjectMapper
 4. 布局：Masonry/SnapKit
 5. 导航栏控制：KMNavigationBarTransition、或利用转场动画控制、或隐藏系统导航栏自定义维护等
 6. UI分栏、分段、分页：JXPagingView、JXSegmentedView （很强大很实用）
 7. UICollectionViewLayout自定义布局：如瀑布流<https://github.com/chiahsien/CHTCollectionViewWaterfallLayout> 左对齐布局、自定义间距等
 8. 流布局、复杂多样、卡片样式代码解耦：IGListKit
 9. 骨架屏：SkeletonView
 10. UI解决方案 <https://qmuiteam.com/ios> 包括不限于UI换肤、各种自定义UI小控件等
 11. 动态模版跨端解决方案：GaiaX<https://youku-gaiax.github.io/> 或 Tangram<http://tangram.pingguohe.net/docs/basic-concept/history>
 12. 键盘管理：IQKeyboardManager/IQKeyboardManagerSwift
 13. 主流数据库：FMDB（轻量、一般app）、Realm（中大型app）或苹果系统方案：CoreData-对应的第三方库：MagicRecord
 14. 富文本排版：YYText、TTTAttributedLabel
 15. WKWebView与JS交互：WKWebViewJavascriptBridge
 16. 组件解耦：MJRouter（下发URL跳转。一般借鉴造轮子，不到300行代码，主要是思路）、CTMediator（Target-Action方式，为某业务组件提供开口）
 17. 短视频、沉浸式、滤镜剪辑等解决方案：火山引擎-视频点播<https://www.volcengine.com/docs/4/65775>  火山引擎包括不限于：集成增长分析、AB测试、性能监控、文字识别等
 18. 直播：IJKPlayer
 19. 内存泄露检测：苹果自带工具Instrument-leaks 或第三方库：MLeaksFinder、FBRetainCycleDetector（可处理大部分问题）
 20. 响应式：RxSwift (解耦控制请求数据block回调这种传统操作等)
 
 - 另外还有图片选择器、图片预览、循环滚动、拉下刷新加载、Popup弹窗、搜索页面等开源组件，都有成熟稳定的解决方案
 
 高级文章篇：
 1. AMP性能统计大致思路：<https://www.cnblogs.com/qiyer/p/14707040.html>
 2. 性能优化OOM大致思路：<https://www.infoq.cn/article/ox7u3ymwiwzamt1vgm7m>
 
 - 项目：
 1. 常见崩溃
    数组越界、调用未未实现方法、线程竞争、
 1. 做过哪些优化?
 */









/*
谢谢您今天给我的这次机会
Thank you for giving me the opportunity to be interviewed for this position today.

我是AAA, 在BBB领域有CCC工作经验
I'm AAA, have an extensive work experience in the BBB field for CCC years.

如果你学校/专业 特别出色的话可以加上
I graduated from DDD University in EEE.
My major is FFF.

在研究了岗位需求后, 我的技能、素质和资格都很满足这个职位
Having studied the job description, I am confident that I have the skills, the qualities and the qualifications needed to excel in this role.

我学习很快. 我能很好的解决问题, 同时也可以管理好大量的工作。
I am a faster learner. I posscess excellent problem-solving capabilities and I can manager a significant workload.

我过去的工作成绩非常出色 (引出后面例子)
I have an impressive track record of achievement.

举例说明你个人的产品, 工作经验等, 如果跟职位产品很符合, 也描述下, 但是留意不要说的太全, 给面试官提问的空间 (结合自身)
For example, ...... XXX IOS App, I developed is very popular with users ......

很感谢参加这次面试, 如果我可以得到这个机会, 我相信你能很快的看到投资的回报
I really appreciate the chance of joining this interview, if you hire me in this position, I believe you will quickly see a positive return on your investment.
 
外企不要过于谦虚, 内容不要太low即可。同时记得留一些陷阱, 将面试官引导你的节奏当中, 后面的面试就会顺利很多。
*/
