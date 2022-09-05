//
//  VMDrawerTransitioner.swift
//  Jongdari
//
//  Created by max on 2022/9/5.
//

#if canImport(UIKit)

import UIKit

internal class VMDrawerTransitioner: NSObject {
  
  internal enum TransitionType {
    case show
    case hidden
  }
  
  internal var animationType: VMDrawerAnimationer.AnimationType! {
    willSet {
      
    }
  }
  
  internal var showInteractiveTransitioner: VMDrawerInteractiveTransitioner!
  internal var hiddenInteractiveTransitioner: VMDrawerInteractiveTransitioner!
  
  internal var configuration: VMDrawerAnimationConfiguration
  
  internal init(configuration: VMDrawerAnimationConfiguration) {
    self.configuration = configuration
  }
}

extension VMDrawerTransitioner: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return VMDrawerAnimationer(transitionType: .show, animationType: self.animationType, configuration: self.configuration)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return VMDrawerAnimationer(transitionType: .hidden, animationType: self.animationType, configuration: self.configuration)
  }
  
  func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return self.showInteractiveTransitioner.isInteracting ? self.showInteractiveTransitioner : nil
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return self.hiddenInteractiveTransitioner.isInteracting ? self.hiddenInteractiveTransitioner : nil
  }
}

#endif
