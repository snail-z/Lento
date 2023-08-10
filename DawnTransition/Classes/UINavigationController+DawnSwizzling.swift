//
//  UINavigationController+DawnMagic.swift
//  Lento
//
//  Created by zhang on 2022/7/19.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2022 snail-z <haozhang0770@163.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

internal extension Dawn {
    
    static func swizzlePushViewController() {
        DispatchQueue._dawn_once(token: "UINavigationController.Dawn.pushViewController") {
            _dawn_swizzle(selector: #selector(UINavigationController.pushViewController(_:animated:)),
                          with: #selector(UINavigationController.dawn_pushViewController(_:animated:)),
                          inClass: UINavigationController.self,
                          usingClass: UINavigationController.self)
        }
    }
    
    static func unSwizzlePushViewController() {
        DispatchQueue._dawn_removeOnce(token: "UINavigationController.Dawn.pushViewController") {
            _dawn_swizzle(selector: #selector(UINavigationController.dawn_pushViewController(_:animated:)),
                          with: #selector(UINavigationController.pushViewController(_:animated:)),
                          inClass: UINavigationController.self,
                          usingClass: UINavigationController.self)
        }
    }
    
    static func swizzlePopViewController() {
        DispatchQueue._dawn_once(token: "UINavigationController.Dawn.popViewController") {
            _dawn_swizzle(selector: #selector(UINavigationController.popViewController(animated:)),
                          with: #selector(UINavigationController.dawn_popViewController(animated:)),
                          inClass: UINavigationController.self,
                          usingClass: UINavigationController.self)
        }
    }

    static func unSwizzlePopViewController() {
        DispatchQueue._dawn_removeOnce(token: "UINavigationController.Dawn.popViewController") {
            _dawn_swizzle(selector: #selector(UINavigationController.dawn_popViewController(animated:)),
                          with: #selector(UINavigationController.popViewController(animated:)),
                          inClass: UINavigationController.self,
                          usingClass: UINavigationController.self)
        }
    }
}

internal extension UINavigationController {
    
    @objc func dawn_pushViewController(_ viewController: UIViewController, animated: Bool) {
        defer {
            dawnTransition(enabled: false)
        }
        if viewController.dawn.isNavigationEnabled {
            dawnTransition(enabled: true)
        }
        dawn_pushViewController(viewController, animated: animated)
    }
    
    @objc func dawn_popViewController(animated: Bool) -> UIViewController? {
        defer {
            dawnTransition(enabled: false)
        }
        if let top = topViewController, top.dawn.isNavigationEnabled {
            dawnTransition(enabled: true)
        }
        return dawn_popViewController(animated: animated)
    }
}

fileprivate var DawnPreviousNavigationControllerAssociatedKey: Void?

internal extension UINavigationController {
    
    func dawnTransition(enabled: Bool) {
        if enabled {
            self.transitioningDelegate = Dawn.shared
            self.dawnPrevNavigationDelegate = self.delegate
            self.delegate = Dawn.shared
        } else {
            self.transitioningDelegate = nil
            self.delegate = self.dawnPrevNavigationDelegate
        }
    }
    
    var dawnPrevNavigationDelegate: UINavigationControllerDelegate? {
        get {
            return objc_getAssociatedObject(self, &DawnPreviousNavigationControllerAssociatedKey) as? UINavigationControllerDelegate
        }
        set {
            objc_setAssociatedObject(self, &DawnPreviousNavigationControllerAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
