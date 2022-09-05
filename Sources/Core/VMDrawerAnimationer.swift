//
//  VMDrawerAnimationer.swift
//  Jongdari
//
//  Created by max on 2022/9/5.
//

#if canImport(UIKit)

import UIKit

public class VMDrawerAnimationer: NSObject {
  
  public enum AnimationType {
    case `default`
    case mask
  }
  
  internal let transitionType: VMDrawerTransitioner.TransitionType
  
  internal let animationType: VMDrawerAnimationer.AnimationType
  
  internal let configuration: VMDrawerAnimationConfiguration
  
  private static let screenWidth = UIScreen.main.bounds.width
  
  private lazy var _maskView = VMDrawerMaskView()
  
  private var _fromSubviews: [UIView] = []
  
  internal init(transitionType: VMDrawerTransitioner.TransitionType, animationType: VMDrawerAnimationer.AnimationType, configuration: VMDrawerAnimationConfiguration) {
    self.transitionType = transitionType
    
    self.animationType = animationType
    
    self.configuration = configuration
  }
  
  private func _showTransition(using transitionContext: UIViewControllerContextTransitioning) {
    switch self.animationType {
      case .default:
        self._defaultTransitionAnimation(using: transitionContext)
      case .mask:
        self._maskTransitionAnimation(using: transitionContext)
    }
  }
  
  private func _hiddenTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    if !(toViewController is UINavigationController) {
      for toSubview in toViewController.view.subviews {
        if !self._fromSubviews.contains(toSubview) {
          toSubview.removeFromSuperview()
        }
      }
    }
    
    let duration = self.transitionDuration(using: transitionContext)
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [.calculationModeLinear]) {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
        fromViewController.view.transform = .identity
        toViewController.view.transform = .identity
        
        self._maskView.alpha = 0.0
      }
    } completion: { (_) in
      let transitionWasCancelled = transitionContext.transitionWasCancelled
      
      if !transitionWasCancelled {
        self._maskView.removeFromSuperview()
        
        self._fromSubviews = []
      }
      
      transitionContext.completeTransition(!transitionWasCancelled)
    }
  }
  
  private func _defaultTransitionAnimation(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    self._maskView.frame = fromViewController.view.bounds
    
    fromViewController.view.addSubview(self._maskView)
    
    let containerView = transitionContext.containerView
    
    let direction = self.configuration.direction
    let distanceMultiplier = self.configuration.distanceMultiplier
    let scale = self.configuration.scale
    let maskAlpha = self.configuration.maskAlpha
    
    let toX: CGFloat = direction == .left ? -(distanceMultiplier / 2.0) * VMDrawerAnimationer.screenWidth : (1.0 - (distanceMultiplier / 2.0)) * VMDrawerAnimationer.screenWidth
    toViewController.view.frame = CGRect(x: toX, y: 0.0, width: containerView.frame.width, height: containerView.frame.height)
    
    containerView.addSubview(fromViewController.view)
    containerView.addSubview(toViewController.view)
    
    let fromTranslationX = (distanceMultiplier - ((1.0 - scale) / 2.0)) * VMDrawerAnimationer.screenWidth
    let fromTransform1 = CGAffineTransform(scaleX: scale, y: scale)
    let fromTransform2 = CGAffineTransform(translationX: fromTranslationX, y: 0.0)
    let fromTransform = fromTransform1.concatenating(fromTransform2)
    
    let toTranslationX = direction == .left ? (distanceMultiplier / 2.0) * VMDrawerAnimationer.screenWidth : -((distanceMultiplier / 2.0) * VMDrawerAnimationer.screenWidth) + containerView.frame.width
    let toTransform = CGAffineTransform(translationX: toTranslationX, y: 0.0)
    
    let duration = self.transitionDuration(using: transitionContext)
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: []) {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
        fromViewController.view.transform = fromTransform
        toViewController.view.transform = toTransform
        
        self._maskView.alpha = maskAlpha
      }
    } completion: { (_) in
      let transitionWasCancelled = transitionContext.transitionWasCancelled
      
      if !transitionWasCancelled {
        self._maskView.isUserInteractionEnabled = true
        
        self._fromSubviews = fromViewController.view.subviews
        
        containerView.addSubview(fromViewController.view)
      }
      else {
        self._maskView.removeFromSuperview()
      }
      
      transitionContext.completeTransition(!transitionWasCancelled)
    }
  }
  
  private func _maskTransitionAnimation(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    self._maskView.frame = fromViewController.view.bounds
    
    fromViewController.view.addSubview(self._maskView)
    
    let containerView = transitionContext.containerView
    
    let direction = self.configuration.direction
    let distanceMultiplier = self.configuration.distanceMultiplier
    let maskAlpha = self.configuration.maskAlpha
    
    let toX: CGFloat = direction == .left ? -(distanceMultiplier) * VMDrawerAnimationer.screenWidth : VMDrawerAnimationer.screenWidth
    toViewController.view.frame = CGRect(x: toX, y: 0.0, width: distanceMultiplier * VMDrawerAnimationer.screenWidth, height: containerView.frame.height)
    
    containerView.addSubview(fromViewController.view)
    containerView.addSubview(toViewController.view)
    
    let toTranslationX = (direction == .left ? distanceMultiplier : -(distanceMultiplier)) * VMDrawerAnimationer.screenWidth
    let toTransform = CGAffineTransform(translationX: toTranslationX, y: 0.0)
    
    let duration = self.transitionDuration(using: transitionContext)
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: []) {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
        toViewController.view.transform = toTransform
        
        self._maskView.alpha = maskAlpha
      }
    } completion: { (_) in
      let transitionWasCancelled = transitionContext.transitionWasCancelled
      
      if !transitionWasCancelled {
        self._maskView.isUserInteractionEnabled = true
        
        self._fromSubviews = fromViewController.view.subviews
        
        containerView.addSubview(fromViewController.view)
        containerView.bringSubviewToFront(toViewController.view)
      }
      else {
        self._maskView.removeFromSuperview()
      }
      
      transitionContext.completeTransition(!transitionWasCancelled)
    }
  }
}

extension VMDrawerAnimationer: UIViewControllerAnimatedTransitioning {
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.configuration.duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    switch self.transitionType {
      case .show:
        self._showTransition(using: transitionContext)
      case .hidden:
        self._hiddenTransition(using: transitionContext)
    }
  }
}

#endif
