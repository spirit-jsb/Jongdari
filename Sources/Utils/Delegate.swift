//
//  Delegate.swift
//  Jongdari
//
//  Created by max on 2022/9/7.
//

#if canImport(Foundation)

import Foundation

internal protocol OptionalProtocol {
  
  static var _createNil: Self { get }
}

internal class Delegate<Input, Output> {
  
  private var _block: ((Input) -> Output?)?
  
  internal init() {
    
  }
  
  internal func delegate<T: AnyObject>(on target: T, block: ((T, Input) -> Output)?) {
    self._block = { [weak target] (input) -> Output? in
      guard let target = target else {
        return nil
      }
      
      return block?(target, input)
    }
  }
  
  internal func call(_ input: Input) -> Output? {
    return self._block?(input)
  }
  
  internal func callAsFunction(_ input: Input) -> Output? {
    return self.call(input)
  }
}

extension Optional: OptionalProtocol {
  
  internal static var _createNil: Optional<Wrapped> {
    return nil
  }
}

extension Delegate where Input == Void {
  
  internal func call() -> Output? {
    return self.call(())
  }
  
  internal func callAsFunction() -> Output? {
    return self.call()
  }
}

extension Delegate where Input == Void, Output: OptionalProtocol {
  
  internal func call() -> Output {
    return self.call(())
  }
  
  internal func callAsFunction() -> Output {
    return self.call()
  }
}

extension Delegate where Output: OptionalProtocol {
  
  internal func call(_ input: Input) -> Output {
    if let result = self._block?(input) {
      return result
    }
    else {
      return Output._createNil
    }
  }
  
  internal func callAsFunction(_ input: Input) -> Output {
    return self.call(input)
  }
}

#endif
