//
//  VMDrawerDimmingView.swift
//  Jongdari
//
//  Created by max on 2022/9/7.
//

#if canImport(UIKit)

import UIKit

internal class VMDrawerDimmingView: UIView {
  
  internal var tapGestureHandler = Delegate<UITapGestureRecognizer, Void>()
  internal var panGestureHandler = Delegate<UIPanGestureRecognizer, Void>()
  
  internal override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    self.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
    self.alpha = 0.0
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    self.addGestureRecognizer(tapGesture)
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    self.addGestureRecognizer(panGesture)
  }
  
  internal required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
#if DEBUG
    print("\(type(of: self)) \(#function)")
#endif
  }
  
  @objc private func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
    self.tapGestureHandler.call(tapGesture)
  }
  
  @objc private func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
    self.panGestureHandler.call(panGesture)
  }
}

#endif
