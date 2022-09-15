//
//  Runtime.swift
//  Jongdari
//
//  Created by max on 2022/9/7.
//

#if canImport(Foundation)

import Foundation

internal func getAssociatedObject<Value>(_  object: Any, _ key: UnsafeRawPointer) -> Value? {
  return objc_getAssociatedObject(object, key) as? Value
}

internal func setRetainedAssociatedObject<Value>(_ object: Any, _ key: UnsafeRawPointer, _ value: Value) {
  objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

#endif
