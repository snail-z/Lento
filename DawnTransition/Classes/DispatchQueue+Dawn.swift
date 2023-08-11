//
//  DispatchQueue+Dawn.swift
//  Lento
//
//  Created by zhang on 2022/7/20.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2022 snail-z <haozhang0770@163.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

internal extension DispatchQueue {
    
    private static var _dawn_onceTracker = [String]()

    class func _dawn_once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        guard !_dawn_onceTracker.contains(token) else { return }
        _dawn_onceTracker.append(token)
        block()
    }

    class func _dawn_removeOnce(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        guard let index = _dawn_onceTracker.firstIndex(of: token) else { return }
        _dawn_onceTracker.remove(at: index)
        block()
    }
}
