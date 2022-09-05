//
//  VMDrawerMaskView.swift
//  Jongdari
//
//  Created by max on 2022/9/5.
//

#if canImport(UIKit)

import UIKit

internal class VMDrawerMaskView: UIView {
  
  internal override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    self.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
    self.alpha = 0.0
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMask(_:)))
    tapGesture.numberOfTapsRequired = 1
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panMask(_:)))
    
    self.addGestureRecognizer(tapGesture)
    self.addGestureRecognizer(panGesture)
  }
  
  internal required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  @objc private func tapMask(_ gesture: UIGestureRecognizer) {
    NotificationCenter.default.post(name: VMDrawerMaskView.tapMask, object: nil)
  }
  
  @objc private func panMask(_ gesture: UIGestureRecognizer) {
    NotificationCenter.default.post(name: VMDrawerMaskView.panMask, object: nil)
  }
}

extension VMDrawerMaskView {
  
  static let tapMask: Notification.Name = {
    var notificationName = (Bundle.main.bundleIdentifier ?? "com.max.jian.Jongdari").appending(".")
    notificationName.append("tap.mask")
    
    return .init(rawValue: notificationName)
  }()
  
  static let panMask: Notification.Name = {
    var notificationName = (Bundle.main.bundleIdentifier ?? "com.max.jian.Jongdari").appending(".")
    notificationName.append("pan.mask")
    
    return .init(rawValue: notificationName)
  }()
}

#endif
