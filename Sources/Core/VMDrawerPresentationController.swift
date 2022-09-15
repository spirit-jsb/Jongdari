//
//  VMDrawerPresentationController.swift
//  Jongdari
//
//  Created by max on 2022/9/7.
//

#if canImport(UIKit)

import UIKit

internal class VMDrawerPresentationController: UIPresentationController {
  
  internal let sourceViewController: UIViewController
  internal let animationConfiguration: VMDrawerAnimationConfiguration
  
  internal var dismissHandlerWhenUsingPanGesture = Delegate<UIPanGestureRecognizer, Void>()
  
  private lazy var _dimmingView: VMDrawerDimmingView = .init()
  
  private var _isTransitioning: Bool = false
  
  private var _initialOrientation: UIDeviceOrientation?
  
  private var _superviewOfPresentingViewController: UIView?
  
  internal init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, source sourceViewController: UIViewController, animationConfiguration: VMDrawerAnimationConfiguration) {
    self.sourceViewController = sourceViewController
    self.animationConfiguration = animationConfiguration
    
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    
    self._initialOrientation = UIDevice.current.orientation
    
    self._dimmingView.tapGestureHandler.delegate(on: self) { (weakSelf, _) in
      weakSelf.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    self._dimmingView.panGestureHandler.delegate(on: self) { (weakSelf, panGesture) in
      weakSelf.dismissHandlerWhenUsingPanGesture.call(panGesture)
    }
  }
  
  deinit {
#if DEBUG
    print("\(type(of: self)) \(#function)")
#endif
  }
  
  internal override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = self.containerView else {
      return UIScreen.main.bounds
    }
    
    let boundsOfContainerView = containerView.bounds
    
    let direction = self.animationConfiguration.direction
    let distance = self.animationConfiguration.distance
    
    let xOfPresentedViewInContainerView: CGFloat
    switch direction {
      case .left:
        xOfPresentedViewInContainerView = 0.0
      case .right:
        xOfPresentedViewInContainerView = boundsOfContainerView.width - distance
    }
    
    return CGRect(x: xOfPresentedViewInContainerView, y: 0.0, width: distance, height: boundsOfContainerView.height)
  }
  
  internal override func containerViewWillLayoutSubviews() {
    guard !self._isTransitioning else {
      return
    }
    
    guard let containerView = self.containerView else {
      return
    }
    
    let boundsOfContainerView = containerView.bounds
    
    let newWidthWhenOrientationChanged = self._initialOrientation != UIDevice.current.orientation ? self.animationConfiguration.distanceMultiplier * boundsOfContainerView.width : self.animationConfiguration.distance
    self._adjustmentLayoutWhenOrientationChanged(with: newWidthWhenOrientationChanged)
    
    if let presentedView = self.presentedView {
      containerView.bringSubviewToFront(presentedView)
    }
  }
  
  internal override func presentationTransitionWillBegin() {
    self._isTransitioning = true
    
    switch self.animationConfiguration.animationType {
      case .`default`:
        self._presentationTransitionOfDefaultAnimationWillBegin()
      case .zoom:
        self._presentationTransitionOfZoomAnimationWillBegin()
      case .mask:
        self._presentationTransitionOfMaskAnimationWillBegin()
    }
  }
  
  internal override func presentationTransitionDidEnd(_ completed: Bool) {
    self._isTransitioning = false
    
    if !completed {
      self._endTransitionHandler()
    }
  }
  
  internal override func dismissalTransitionWillBegin() {
    self._isTransitioning = true
    
    switch self.animationConfiguration.animationType {
      case .`default`, .mask:
        self._transitionAnimationForDimmingView(0.0, dimmingTransform: nil)
      case .zoom:
        self._transitionAnimationForDimmingView(0.0, dimmingTransform: .identity)
    }
  }
  
  internal override func dismissalTransitionDidEnd(_ completed: Bool) {
    self._isTransitioning = false
    
    if completed {
      self._endTransitionHandler()
    }
  }
  
  internal func initialFrameOfPresentedViewInContainerView() -> CGRect {
    guard let containerView = self.containerView else {
      return UIScreen.main.bounds
    }
    
    let boundsOfContainerView = containerView.bounds
    
    let direction = self.animationConfiguration.direction
    let distance = self.animationConfiguration.distance
    
    let xOfPresentedView: CGFloat
    switch direction {
      case .left:
        xOfPresentedView = -(distance)
      case .right:
        xOfPresentedView = boundsOfContainerView.width
    }
    
    return CGRect(x: xOfPresentedView, y: 0.0, width: distance, height: boundsOfContainerView.height)
  }
  
  private func _adjustmentLayoutWhenOrientationChanged(with newWidth: CGFloat) {
    guard let containerView = self.containerView else {
      return
    }
    
    let boundsOfContainerView = containerView.bounds
    
    let direction = self.animationConfiguration.direction
    let animationType = self.animationConfiguration.animationType
    
    let xOfPresentedView: CGFloat
    switch direction {
      case .left:
        xOfPresentedView = 0.0
      case .right:
        xOfPresentedView = boundsOfContainerView.width - newWidth
    }
    
    self.presentedView?.frame = CGRect(x: xOfPresentedView, y: 0.0, width: newWidth, height: boundsOfContainerView.height)
    
    switch animationType {
      case .`default`:
        self.presentingViewController.view.transform = CGAffineTransform(translationX: direction == .left ? newWidth : -(newWidth), y: 0.0)
      case .zoom:
        let newHeight = self.animationConfiguration.scaleFactor * boundsOfContainerView.height
        let newY = (boundsOfContainerView.height - newHeight) / 2.0
        
        self.presentingViewController.view.frame = CGRect(x: direction == .left ? newWidth : -(newWidth), y: newY, width: boundsOfContainerView.width, height: newHeight)
        
        self._dimmingView.frame = CGRect(x: 0.0, y: newY, width: boundsOfContainerView.width, height: newHeight)
      case .mask:
        break
    }
  }
  
  private func _presentationTransitionOfDefaultAnimationWillBegin() {
    guard let containerView = self.containerView else {
      return
    }
    
    let boundsOfContainerView = containerView.bounds
    
    let dimmingOpacity = self.animationConfiguration.maskOpacity
    
    self._dimmingView.frame = boundsOfContainerView
    
    containerView.insertSubview(self._dimmingView, at: 0)
    
    self._transitionAnimationForDimmingView(dimmingOpacity, dimmingTransform: nil)
  }
  
  private func _presentationTransitionOfZoomAnimationWillBegin() {
    guard let containerView = self.containerView else {
      return
    }
    
    let boundsOfContainerView = containerView.bounds
    
    let dimmingOpacity = self.animationConfiguration.maskOpacity
    let dimmingTransform = CGAffineTransform(scaleX: 1.0, y: self.animationConfiguration.scaleFactor)
    
    self._superviewOfPresentingViewController = self.presentingViewController.view.superview
    
    self._dimmingView.frame = boundsOfContainerView
    
    containerView.addSubview(self._dimmingView)
    containerView.insertSubview(self.presentingViewController.view, belowSubview: self._dimmingView)
    
    self._transitionAnimationForDimmingView(dimmingOpacity, dimmingTransform: dimmingTransform)
  }
  
  private func _presentationTransitionOfMaskAnimationWillBegin() {
    self._presentationTransitionOfDefaultAnimationWillBegin()
  }
  
  private func _endTransitionHandler() {
    self._dimmingView.removeFromSuperview()
    
    if self._superviewOfPresentingViewController != nil {
      self._superviewOfPresentingViewController!.addSubview(self.presentingViewController.view)
    }
  }
  
  private func _transitionAnimationForDimmingView(_ dimmingOpacity: CGFloat, dimmingTransform: CGAffineTransform?) {
    if let presentedTransitionCoordinator = self.presentedViewController.transitionCoordinator {
      presentedTransitionCoordinator.animate(alongsideTransition: { (_) in
        self._dimmingView.alpha = dimmingOpacity
        
        if let dimmingTransform = dimmingTransform {
          self._dimmingView.transform = dimmingTransform
        }
      })
    }
    else {
      self._dimmingView.alpha = dimmingOpacity
      
      if let dimmingTransform = dimmingTransform {
        self._dimmingView.transform = dimmingTransform
      }
    }
  }
}

#endif
