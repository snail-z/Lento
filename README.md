# DawnTransition

[![CI Status](https://img.shields.io/travis/snail-z/DawnTransition.svg?style=flat)](https://travis-ci.org/snail-z/DawnTransition)
[![Version](https://img.shields.io/cocoapods/v/DawnTransition.svg?style=flat)](https://cocoapods.org/pods/DawnTransition)
[![License](https://img.shields.io/cocoapods/l/DawnTransition.svg?style=flat)](https://cocoapods.org/pods/DawnTransition)
[![Platform](https://img.shields.io/cocoapods/p/DawnTransition.svg?style=flat)](https://cocoapods.org/pods/DawnTransition)



DawnTransition mainly solves the problem of gesture interaction in view controller transition animation. And supports custom transition animation effects

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Requires iOS11.0 or later

- Requires Automatic Reference Counting (ARC)

## Installation

DawnTransition is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DawnTransition'
```

## Usage

1. UINavigationController transitioning：

   ```swift
   let vc = TestViewController()
   vc.dawn.isNavigationEnabled = true
   vc.dawn.navigationAnimationType = .pageIn(direction: .left)
   self.navigationController?.pushViewController(vc, animated: true)
   ```

   `isNavigationEnabled`

   `navigationAnimationType`

2. UIModalViewController transitioning:

   ```swift
   let vc = TestViewController()
   vc.dawn.isModalEnabled = true
   vc.dawn.modalAnimationType = .pageIn(direction: .left)
   self.present(vc, animated: true)
   ```

   `isModalEnabled`

   `modalAnimationType`

## Author

snail-z, haozhang0770@163.com

## License

DawnTransition is available under the MIT license. See the LICENSE file for more info.
