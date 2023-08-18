# DawnTransition

[![CI Status](https://img.shields.io/travis/snail-z/DawnTransition.svg?style=flat)](https://travis-ci.org/snail-z/DawnTransition)
[![Version](https://img.shields.io/cocoapods/v/DawnTransition.svg?style=flat)](https://cocoapods.org/pods/DawnTransition)
[![License](https://img.shields.io/cocoapods/l/DawnTransition.svg?style=flat)](https://cocoapods.org/pods/DawnTransition)
[![Platform](https://img.shields.io/cocoapods/p/DawnTransition.svg?style=flat)](https://cocoapods.org/pods/DawnTransition)



[DawnTransition](https://github.com/snail-z/DawnTransition)主要解决转场动画中的手势交互问题。例如转场手势与TableView滚动手势优先级、响应策略等问题。目前常见的转场库对手势体验做得都不够细腻，之前使用 [Hero](https://github.com/HeroTransitions/Hero) 做转场，虽然功能强大动画丰富，但手势交互这块处理的不够平滑，外部也无法对手势自定义设置与修改，为了解决这些问题，借鉴 [Hero](https://github.com/HeroTransitions/Hero) 思路实现了一套新的转场控制，处理了不同场景下的手势转场问题，[DawnTransition](https://github.com/snail-z/DawnTransition)几乎与系统体验一致的侧滑效果；并且内置了交叉溶解、神奇移动、扩散缩放等动画效果，使用简洁成本低，可下载demo体验。

## Usage

1. UINavigationController 导航控制器转场：

   ```swift
   let vc = Push2ViewController()
   vc.dawn.isNavigationEnabled = true
   vc.dawn.transitionAnimationType = .selectBy(presenting: .fade, dismissing: .push(direction: .up))
   self.navigationController?.pushViewController(vc, animated: true)
   ```

   启用`isNavigationEnabled` 设置为true；

   设置`transitionAnimationType`转场动画类型；

   完成以上两个配置，即可为你的视图控制器实现转场动画；

   <img src="https://github.com/snail-z/DawnTransition/blob/master/Preview/pagein.gif?raw=true" width="220px"/> 

2. UIModalViewController 模态控制器转场:

   ```swift
   let vc = TestViewController()
   vc.dawn.isModalEnabled = true
   vc.dawn.transitionAnimationType = .pageIn(direction: .up)
   self.present(vc, animated: true)
   ```

   启用`isModalEnabled` 设置为true；

   同样设置`transitionAnimationType`转场动画类型；

   设置后模态跳转便支持了转场动画；

   <img src="https://github.com/snail-z/DawnTransition/blob/master/Preview/zoom.gif?raw=true" width="220px"/> 

3. 基于`DawnTransition`内置动画类型的自定义转场：

   ```swift
   public protocol DawnCustomTransitionCapable {
       
       /// 自定义视图状态
       func dawnModifierStagePresenting() -> DawnModifierStage
       func dawnModifierStageDismissing() -> DawnModifierStage
       
       /// 自定义转场配置
       func dawnAnimationConfigurationPresenting() -> DawnAnimationConfiguration
       func dawnAnimationConfigurationDismissing() -> DawnAnimationConfiguration
   }
   ```

   实现以上两个方法，可以自定义转场前转场后不同状态`DawnModifierStage`，以及转场动画曲线，时长等属性配置`DawnAnimationConfiguration`；然后设置`transitionCapable` 如下：

   ```swift
   let vc = LagerImageController()
   vc.ccimage = model.takeImage()
   vc.dawn.isModalEnabled = true // 启动模态转场
   let pathway = DawnAnimateDissolve(sourceView: cell.contentView)
   pathway.duration = 0.375
   vc.dawn.transitionCapable = pathway //设置自定转场动画
   self.present(vc, animated: true, completion: nil)
   ```

   <img src="https://github.com/snail-z/DawnTransition/blob/master/Preview/flow2.gif?raw=true" width="220px"/> 

4. 自定义转场动画：

   1.  实现以下方法并返回`.customizing`则完全由外部自定义动画

   ```swift
   typealias DawnSign = DawnTransitionCapableSign
   typealias DawnContext = (container: UIView, 
                            fromViewController: UIViewController, 
                            toViewController: UIViewController)
   
   func dawnTransitionPresenting(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign
   func dawnTransitionDismissing(context: DawnContext, complete: @escaping ((Bool) -> Void)) -> DawnSign
   ```

   <img src="https://github.com/snail-z/DawnTransition/blob/master/Preview/shffein.gif?raw=true" width="220px"/> 

   例如想实现上图中扩散收缩效果，只需要实现`DawnCustomTransitionCapable`协议

   ```swift
   let vc = DescIMGViewController(descItem: takeDescIMGModel())
   vc.dawn.isModalEnabled = true
   vc.dawn.transitionCapable = DawnAnimateDiffuse(diffuseOut: roundBtn, diffuseIn: roundBtn)
   self.present(vc, animated: true)
   ```

5. 交互手势`DawnPanGestureRecognizer`：

   ```swift
   let pan = DawnPanGestureRecognizer(driver: self, type: .dismiss) { [weak self] in
   		guard let `self` = self else { return }
   		self.dismiss(animated: true)
   }
   pan.isRecognizeWhenEdges = false
   pan.recognizeDirection = .leftToRight
   view.dawn.addPanGestureRecognizer(pan)
   ```

   和使用系统拖动手势一样，初始化配置后，添加到目标视图即可；

   `isRecognizeWhenEdges`: 该属性设置为true只能在屏幕边缘识别手势，若设为false则全屏幕可识别；

   `recognizeDirection`: 手势响应方向，例如只在水平方向，从左往右拖动手势时响应转场交互则设置为：

   ```swift
   panGesture.recognizeDirection = .leftToRight // 仅识别水平方向、从左往右拖动
   ```

   <img src="https://github.com/snail-z/DawnTransition/blob/master/Preview/toady1.gif?raw=true" width="220px"/> 

6. 自定义手势，类似苹果商店Today效果 `DawnTodayGestureRecognizer`：

   <img src="https://github.com/snail-z/DawnTransition/blob/master/Preview/today2.gif?raw=true" width="220px"/> 

   ```swift
   public class DawnTodayGestureRecognizer: DawnPanGestureRecognizer {
   
       /// 拖动到达缩放边界是否自动转场
       public var shouldAutoDissmiss = true
       
       /// 拖动缩放到达的最小比例，取值范围(0-1]
       public var zoomScale: CGFloat = 0.8
       
       /// 拖动缩放系数，该值越大缩放越快，取值范围(0-1]
       public var zoomFactor: CGFloat = 0.8
       
       /// 拖动中页面圆角变化最大值
       public var zoomMaxRadius: CGFloat = 20
       
       /// 需要追踪的UIScrollView，用于解决手势冲突
       public weak var trackScrollView: UIScrollView?
   }
   ```

## Requirements

- Requires iOS11.0 or later

- Requires Automatic Reference Counting (ARC)

## Installation

DawnTransition is available through [CocoaPods](https://cocoapods.org/). To install it, simply add the following line to your Podfile:

```ruby
pod 'DawnTransition'
```

## Author

snail-z, haozhang0770@163.com

## License

DawnTransition is available under the MIT license. See the LICENSE file for more info.
