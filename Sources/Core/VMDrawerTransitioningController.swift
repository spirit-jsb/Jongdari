//
//  VMDrawerTransitioningController.swift
//  Jongdari
//
//  Created by max on 2022/9/6.
//

#if canImport(UIKit)

import UIKit

internal class VMDrawerTransitioningController: NSObject {
  
  internal enum TransitioningType {
    case open
    case close
  }
  
  internal var animationConfiguration: VMDrawerAnimationConfiguration! {
    willSet {
      self._openInteractiveTransition.animationConfiguration = newValue
      self._closeInteractiveTransition.animationConfiguration = newValue
    }
  }
  
  internal var transitionHandler: TransitionHandler? {
    willSet {
      self._openInteractiveTransition.transitionHandler = newValue
    }
  }
  
  internal var presentationController: VMDrawerPresentationController?
  
  private lazy var _openInteractiveTransition: VMDrawerInteractiveTransition = .init(transitionType: .open)
  private lazy var _closeInteractiveTransition: VMDrawerInteractiveTransition = .init(transitionType: .close)
  
  deinit {
#if DEBUG
    print("\(type(of: self)) \(#function)")
#endif
  }
  
  internal func registerGesture(_ gestureType: VMDrawerAnimationConfiguration.TransitionGestureType, on viewController: UIViewController) {
    switch gestureType {
      case .edge:
        let leftEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture(_:)))
        leftEdgePanGesture.edges = .left
        
        viewController.view.addGestureRecognizer(leftEdgePanGesture)
        
        let rightEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePanGesture(_:)))
        rightEdgePanGesture.edges = .right
        
        viewController.view.addGestureRecognizer(rightEdgePanGesture)
      case .fullScreen:
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        
        viewController.view.addGestureRecognizer(panGesture)
    }
  }
  
  @objc private func handleEdgePanGesture(_ edgePanGesture: UIScreenEdgePanGestureRecognizer) {
    self._openInteractiveTransition.handleOpenGesture(edgePanGesture)
  }
  
  @objc private func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
    self._openInteractiveTransition.handleOpenGesture(panGesture)
  }
}

extension VMDrawerTransitioningController: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animatedTransitioningController = VMDrawerAnimatedTransitioningController(transitionType: .open, animationConfiguration: self.animationConfiguration)
    animatedTransitioningController.presentationController = self.presentationController
    
    return animatedTransitioningController
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animatedTransitioningController = VMDrawerAnimatedTransitioningController(transitionType: .close, animationConfiguration: self.animationConfiguration)
    animatedTransitioningController.presentationController = self.presentationController
    
    return animatedTransitioningController
  }
  
  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return self._openInteractiveTransition.isInteracting ? self._openInteractiveTransition : nil
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return self._closeInteractiveTransition.isInteracting ? self._closeInteractiveTransition : nil
  }
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let presentationController = VMDrawerPresentationController(presentedViewController: presented, presenting: presenting, source: source, animationConfiguration: self.animationConfiguration)
    
    presentationController.dismissHandlerWhenUsingPanGesture.delegate(on: self) { (weakSelf, panGesture) in
      weakSelf._closeInteractiveTransition.handleCloseGesture(panGesture, presenting: presenting ?? source)
    }
    
    self.presentationController = presentationController
    
    return presentationController
  }
}

#endif
