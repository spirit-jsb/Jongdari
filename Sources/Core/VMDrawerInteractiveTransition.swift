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
  
  internal var transitionHandler: TransitionHandler?
  
  internal var isInteracting: Bool = false
  
  internal init(transitionType: VMDrawerTransitioningController.TransitioningType) {
    self.transitionType = transitionType
  }
}

#endif
