//
//  VMDrawerInteractiveTransition.swift
//  Jongdari
//
//  Created by max on 2022/9/6.
//

#if canImport(UIKit)

import UIKit

internal class VMDrawerInteractiveTransition: UIPercentDrivenInteractiveTransition {
  
  internal let transitionType: VMDrawerTransitioningController.TransitioningType
  
  internal var animationConfiguration: VMDrawerAnimationConfiguration!
  internal var transitionHandler: TransitionHandler?
  
  internal private(set) var isInteracting: Bool = false
  
  private static let minimumPercentCompleteThreshold = 0.02
  private static let maximumPercentCompleteThreshold = 0.98
  
  private static let framesPerSecond: CGFloat = 60.0
  
  private var _percentComplete: CGFloat = 0.0
  
  private var _isDraggingComplete = false
  
  private var _framesPerDuration: CGFloat = 0.0
  
  private var _handlingInteractiveTransitionTimer: CADisplayLink? {
    didSet {
      if oldValue != self._handlingInteractiveTransitionTimer {
        self._handlingInteractiveTransitionTimer?.add(to: .current, forMode: .common)
      }
    }
  }
  
  internal init(transitionType: VMDrawerTransitioningController.TransitioningType) {
    self.transitionType = transitionType
  }
  
  deinit {
#if DEBUG
    print("\(type(of: self)) \(#function)")
#endif
  }
  
  internal func handleOpenGesture(_ panGesture: UIPanGestureRecognizer) {
    switch panGesture.state {
      case .began:
        panGesture.setTranslation(.zero, in: panGesture.view)
      case .changed:
        let translationX = panGesture.translation(in: panGesture.view).x
        
        guard translationX != .zero else {
          return
        }
        
        if self.isInteracting {
          let percentComplete = min(max(abs(translationX / self.animationConfiguration.distance), VMDrawerInteractiveTransition.minimumPercentCompleteThreshold), VMDrawerInteractiveTransition.maximumPercentCompleteThreshold)
          self.update(percentComplete)
          
          self._percentComplete = percentComplete
        }
        else {
          self.isInteracting = true
          
          self.animationConfiguration = self.animationConfiguration.update {
            $0.direction = translationX > 0.0 ? .left : .right
          }
          
          self.transitionHandler?(self.animationConfiguration.direction)
        }
      case .ended, .cancelled:
        self.isInteracting = false
        
        self._startHandleInteractiveTransitionAfterGestureEnded()
      default:
        break
    }
  }
  
  internal func handleCloseGesture(_ panGesture: UIPanGestureRecognizer, presenting: UIViewController) {
    switch panGesture.state {
      case .began:
        panGesture.setTranslation(.zero, in: panGesture.view)
      case .changed:
        let translationX = panGesture.translation(in: panGesture.view).x
        
        guard translationX != .zero else {
          return
        }
        
        if self.isInteracting {
          let percentComplete = min(max(abs(translationX / self.animationConfiguration.distance), VMDrawerInteractiveTransition.minimumPercentCompleteThreshold), VMDrawerInteractiveTransition.maximumPercentCompleteThreshold)
          self.update(percentComplete)
          
          self._percentComplete = percentComplete
        }
        else {
          self.isInteracting = true
          
          presenting.dismiss(animated: true, completion: nil)
        }
      case .ended, .cancelled:
        self.isInteracting = false
        
        self._startHandleInteractiveTransitionAfterGestureEnded()
      default:
        break
    }
  }
  
  private func _startHandleInteractiveTransitionAfterGestureEnded() {
    self._isDraggingComplete = self._percentComplete >= self.animationConfiguration.maximumDraggingPercent
    
    self._framesPerDuration = 1.0 / (self.duration * VMDrawerInteractiveTransition.framesPerSecond)
    
    if self._handlingInteractiveTransitionTimer == nil {
      self._handlingInteractiveTransitionTimer = CADisplayLink(target: self, selector: #selector(handleInteractiveTransition))
    }
  }
  
  private func _endHandleInteractiveTransition() {
    self._handlingInteractiveTransitionTimer?.invalidate()
    
    self._handlingInteractiveTransitionTimer = nil
  }
  
  @objc private func handleInteractiveTransition() {
    var percentComplete = self._percentComplete
    
    if self._isDraggingComplete {
      if percentComplete >= VMDrawerInteractiveTransition.maximumPercentCompleteThreshold {
        self._endHandleInteractiveTransition()
        
        self.finish()
      }
      else {
        percentComplete += self._framesPerDuration
      }
    }
    else {
      if percentComplete <= VMDrawerInteractiveTransition.minimumPercentCompleteThreshold {
        self._endHandleInteractiveTransition()
        
        self.cancel()
      }
      else {
        percentComplete -= self._framesPerDuration
      }
    }
    
    percentComplete = min(max(percentComplete, VMDrawerInteractiveTransition.minimumPercentCompleteThreshold), VMDrawerInteractiveTransition.maximumPercentCompleteThreshold)
    
    self.update(percentComplete)
    
    self._percentComplete = percentComplete
  }
}

#endif
