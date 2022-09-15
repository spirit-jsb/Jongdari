//
//  VMDrawerAnimationConfiguration.swift
//  Jongdari
//
//  Created by max on 2022/9/5.
//

#if canImport(UIKit)

import UIKit

public struct VMDrawerAnimationConfiguration: Update {
  
  public enum TransitionDirection {
    case left
    case right
  }
  
  public enum TransitionGestureType {
    case edge
    case fullScreen
  }
  
  public enum AnimationType {
    case `default`
    case zoom
    case mask
  }
  
  public var direction: TransitionDirection
  public var animationType: AnimationType
  
  public var openDuration: TimeInterval
  public var closeDuration: TimeInterval
  
  public var distanceMultiplier: CGFloat
  
  public var maximumDraggingPercent: CGFloat
  
  public var scaleFactor: CGFloat
  
  public var maskOpacity: CGFloat
  
  internal var distance: CGFloat {
    return self.distanceMultiplier * UIScreen.main.bounds.width
  }
  
  internal init(
    direction: TransitionDirection = .left,
    animationType: AnimationType = .default,
    openDuration: TimeInterval = 0.3,
    closeDuration: TimeInterval = 0.3,
    distanceMultiplier: CGFloat = 0.75,
    maximumDraggingPercent: CGFloat = 0.45,
    scaleFactor: CGFloat = 0.8,
    maskOpacity: CGFloat = 0.4
  ) {
    self.direction = direction
    self.animationType = animationType
    
    self.openDuration = openDuration
    self.closeDuration = closeDuration
    
    self.distanceMultiplier = distanceMultiplier
    
    self.maximumDraggingPercent = maximumDraggingPercent
    
    self.scaleFactor = scaleFactor
    
    self.maskOpacity = maskOpacity
  }
  
  public static func `default`() -> VMDrawerAnimationConfiguration {
    return .init()
  }
}

#endif
