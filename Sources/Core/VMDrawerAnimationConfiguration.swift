//
//  VMDrawerAnimationConfiguration.swift
//  Jongdari
//
//  Created by max on 2022/9/5.
//

#if canImport(UIKit)

import UIKit

public struct VMDrawerAnimationConfiguration {
  
  public enum TransitionDirection {
    case left
    case right
  }
  
  public var direction: TransitionDirection
  
  public var duration: TimeInterval
  
  public var distanceMultiplier: CGFloat
  public var maximumDraggingMultiplier: CGFloat
  
  public var scale: CGFloat
  
  public var maskAlpha: CGFloat
  
  public init(direction: TransitionDirection, duration: TimeInterval, distanceMultiplier: CGFloat, maximumDraggingMultiplier: CGFloat, scale: CGFloat, maskAlpha: CGFloat) {
    self.direction = direction
    
    self.duration = duration
    
    self.distanceMultiplier = distanceMultiplier
    self.maximumDraggingMultiplier = maximumDraggingMultiplier
    
    self.scale = scale
    
    self.maskAlpha = maskAlpha
  }
  
  public static func `default`() -> VMDrawerAnimationConfiguration {
    return .init(direction: .left, duration: 0.25, distanceMultiplier: 0.75, maximumDraggingMultiplier: 0.45, scale: 1.0, maskAlpha: 0.4)
  }
}

#endif
