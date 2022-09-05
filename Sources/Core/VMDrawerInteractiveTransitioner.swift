//
//  VMDrawerInteractiveTransitioner.swift
//  Jongdari
//
//  Created by max on 2022/9/5.
//

#if canImport(UIKit)

import UIKit

internal class VMDrawerInteractiveTransitioner: UIPercentDrivenInteractiveTransition {

  internal let transitionType: VMDrawerTransitioner.TransitionType
  
  internal var isInteracting: Bool = true
  
  internal init(transitionType: VMDrawerTransitioner.TransitionType) {
    self.transitionType = transitionType
    
    super.init()
    
    NotificationCenter.default.addObserver(self, selector: #selector(tapMask(_:)), name: VMDrawerMaskView.tapMask, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(panMask(_:)), name: VMDrawerMaskView.panMask, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: VMDrawerMaskView.tapMask, object: nil)
    NotificationCenter.default.removeObserver(self, name: VMDrawerMaskView.panMask, object: nil)
  }
  
  @objc private func tapMask(_ notification: Notification) {
    
  }
  
  @objc private func panMask(_ notification: Notification) {
    
  }
}

#endif
