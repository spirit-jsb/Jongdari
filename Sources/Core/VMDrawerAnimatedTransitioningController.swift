//
//  VMDrawerAnimatedTransitioningController.swift
//  Jongdari
//
//  Created by max on 2022/9/6.
//

#if canImport(UIKit)

import UIKit

internal class VMDrawerAnimatedTransitioningController: NSObject {
  
  internal private(set) var transitionType: VMDrawerTransitioningController.TransitioningType
  internal var animationConfiguration: VMDrawerAnimationConfiguration
  
  internal var presentationController: VMDrawerPresentationController?
  
  internal init(transitionType: VMDrawerTransitioningController.TransitioningType, animationConfiguration: VMDrawerAnimationConfiguration) {
    self.transitionType = transitionType
    self.animationConfiguration = animationConfiguration
  }
  
  private func _open(using transitionContext: UIViewControllerContextTransitioning) {
    switch self.animationConfiguration.animationType {
      case .`default`:
        self._openByDefaultAnimation(using: transitionContext)
      case .zoom:
        self._openByZoomAnimation(using: transitionContext)
      case .mask:
        self._openByMaskAnimation(using: transitionContext)
    }
  }
  
  private func _close(using transitionContext: UIViewControllerContextTransitioning) {
    switch self.animationConfiguration.animationType {
      case .`default`:
        self._closeByDefaultAnimation(using: transitionContext)
      case .zoom:
        self._closeByZoomAnimation(using: transitionContext)
      case .mask:
        self._closeByMaskAnimation(using: transitionContext)
    }
  }
  
  private func _openByDefaultAnimation(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    guard let presentationController = self.presentationController else {
      return
    }
    
    let containerView = transitionContext.containerView
    
    let superviewOfFromView = fromViewController.view.superview
    
    let direction = self.animationConfiguration.direction
    let distance = self.animationConfiguration.distance
    
    let transformOfFromViewController = CGAffineTransform(translationX: direction == .left ? distance : -(distance), y: 0.0)
    
    let initialFrameOfToViewController = presentationController.initialFrameOfPresentedViewInContainerView()
    let finalFrameOfToViewController = transitionContext.finalFrame(for: toViewController)
    
    toViewController.view.frame = initialFrameOfToViewController
    
    containerView.addSubview(toViewController.view)
    
    let duration = self.transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
        fromViewController.view.transform = transformOfFromViewController
        toViewController.view.frame = finalFrameOfToViewController
      }
    }, completion: { (_) in
      superviewOfFromView?.addSubview(fromViewController.view)
      superviewOfFromView?.sendSubviewToBack(fromViewController.view)
      
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
  
  private func _openByZoomAnimation(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    guard let presentationController = self.presentationController else {
      return
    }
    
    let containerView = transitionContext.containerView
    
    let direction = self.animationConfiguration.direction
    let distance = self.animationConfiguration.distance
    
    let finalHeightOfFromeViewController = self.animationConfiguration.scaleFactor * containerView.bounds.height
    
    let finalXOfFromeViewController = direction == .left ? distance : -(distance)
    let finalYOfFromeViewController = (containerView.bounds.height - finalHeightOfFromeViewController) / 2.0
    
    let finalFrameOfFromeViewController = CGRect(x: finalXOfFromeViewController, y: finalYOfFromeViewController, width: containerView.bounds.width, height: finalHeightOfFromeViewController)
    
    let initialFrameOfToViewController = presentationController.initialFrameOfPresentedViewInContainerView()
    let finalFrameOfToViewController = transitionContext.finalFrame(for: toViewController)
    
    toViewController.view.frame = initialFrameOfToViewController
    
    containerView.addSubview(toViewController.view)
    
    let duration = self.transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
        fromViewController.view.frame = finalFrameOfFromeViewController
        toViewController.view.frame = finalFrameOfToViewController
      }
    }, completion: { (_) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
  
  private func _openByMaskAnimation(using transitionContext: UIViewControllerContextTransitioning) {
    guard let _ = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    guard let presentationController = self.presentationController else {
      return
    }
    
    let containerView = transitionContext.containerView
    
    let initialFrameOfToViewController = presentationController.initialFrameOfPresentedViewInContainerView()
    let finalFrameOfToViewController = transitionContext.finalFrame(for: toViewController)
    
    toViewController.view.frame = initialFrameOfToViewController
    
    containerView.addSubview(toViewController.view)
    
    let duration = self.transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
        toViewController.view.frame = finalFrameOfToViewController
      }
    }, completion: { (_) in
      let transitionWasCancelled = transitionContext.transitionWasCancelled
      
      if transitionWasCancelled {
        toViewController.view.removeFromSuperview()
      }
      
      transitionContext.completeTransition(!transitionWasCancelled)
    })
  }
  
  private func _closeByDefaultAnimation(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    guard let presentationController = self.presentationController else {
      return
    }
    
    let containerView = transitionContext.containerView
    
    let superviewOfToView = toViewController.view.superview
    
    let finalFrameOfFromViewController = presentationController.initialFrameOfPresentedViewInContainerView()
    
    containerView.addSubview(toViewController.view)
    containerView.sendSubviewToBack(toViewController.view)
    
    let duration = self.transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
        fromViewController.view.frame = finalFrameOfFromViewController
        toViewController.view.transform = .identity
      }
    }, completion: { (_) in
      superviewOfToView?.addSubview(toViewController.view)
      
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
  
  private func _closeByZoomAnimation(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    guard let presentationController = self.presentationController else {
      return
    }
    
    let finalFrameOfFromeViewController = presentationController.initialFrameOfPresentedViewInContainerView()
    
    let finalFrameOfToViewController = transitionContext.finalFrame(for: toViewController)
    
    let duration = self.transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
        fromViewController.view.frame = finalFrameOfFromeViewController
        toViewController.view.frame = finalFrameOfToViewController
      }
    }, completion: { (_) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
  
  private func _closeByMaskAnimation(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromViewController = transitionContext.viewController(forKey: .from), let _ = transitionContext.viewController(forKey: .to) else {
      return
    }
    
    guard let presentationController = self.presentationController else {
      return
    }
    
    let finalFrameOfFromeViewController = presentationController.initialFrameOfPresentedViewInContainerView()
    
    let duration = self.transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: [], animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
        fromViewController.view.frame = finalFrameOfFromeViewController
      }
    }, completion: { (_) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}

extension VMDrawerAnimatedTransitioningController: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    let transitionDuration: TimeInterval
    
    switch self.transitionType {
      case .open:
        transitionDuration = self.animationConfiguration.openDuration
      case .close:
        transitionDuration = self.animationConfiguration.closeDuration
    }
    
    return transitionDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    switch self.transitionType {
      case .open:
        self._open(using: transitionContext)
      case .close:
        self._close(using: transitionContext)
    }
  }
  
  func animationEnded(_ transitionCompleted: Bool) {
    if self.transitionType == .close && transitionCompleted {
      if self.presentationController != nil {
        let viewControllers = [self.presentationController!.presentingViewController,
                               self.presentationController!.presentedViewController,
                               self.presentationController!.sourceViewController]
        
        viewControllers.forEach {
          $0.transitioningController?.presentationController = nil
          
          if !$0.isRegisterGesture {
            $0.transitioningController = nil
          }
        }
      }
    }
  }
}

#endif
