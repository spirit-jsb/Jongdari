//
//  Jongdari.swift
//  Jongdari
//
//  Created by max on 2022/9/5.
//

#if canImport(UIKit)

import UIKit

public typealias TransitionHandler = (VMDrawerAnimationConfiguration.TransitionDirection) -> Void

public protocol JongdariCompatible {
  
}

public struct JongdariWrapper<Base> {
  
  public var base: Base
  
  public init(base: Base) {
    self.base = base
  }
}

extension JongdariCompatible {
  
  public var vm: JongdariWrapper<Self> {
    get {
      return JongdariWrapper(base: self)
    }
    set {
      
    }
  }
}

extension UIViewController: JongdariCompatible {
  
}

#endif
