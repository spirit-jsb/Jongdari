//
//  Update.swift
//  Jongdari
//
//  Created by max on 2022/9/7.
//

#if canImport(Foundation) && canImport(CoreGraphics) && canImport(UIKit)

import Foundation
import CoreGraphics
import UIKit.UIGeometry

protocol Update {
  
}

extension Update where Self: Any {
  
  @inlinable
  func update(_ block: (inout Self) throws -> Void) rethrows -> Self {
    var copy = self
    
    try block(&copy)
    
    return copy
  }
  
  @inlinable
  func `do`(_ block: (Self) throws -> Void) rethrows {
    try block(self)
  }
}

extension Update where Self: AnyObject {
  
  @inlinable
  func update(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    
    return self
  }
}

extension NSObject: Update {  }

extension Array: Update {  }
extension Dictionary: Update {  }
extension Set: Update {  }

extension JSONDecoder: Update {  }
extension JSONEncoder: Update {  }

extension CGPoint: Update {  }
extension CGSize: Update {  }
extension CGRect: Update {  }
extension CGVector: Update {  }

extension UIOffset: Update {  }
extension UIEdgeInsets: Update {  }

extension UIRectEdge: Update {  }

#endif
