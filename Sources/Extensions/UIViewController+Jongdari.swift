//
//  UIViewController+Jongdari.swift
//  Jongdari
//
//  Created by max on 2022/9/5.
//

#if canImport(UIKit)

import UIKit

extension JongdariWrapper where Base: UIViewController {
  
  public typealias AnimationConfigurationBuilder = (inout VMDrawerAnimationConfiguration) -> VMDrawerAnimationConfiguration
  
  public func `open`(_ viewController: UIViewController?, animationConfigurationBuilder: AnimationConfigurationBuilder? = nil) {
    guard let viewController = viewController else {
      return
    }
    
    var animationConfiguration = VMDrawerAnimationConfiguration.default()
    
    if let builder = animationConfigurationBuilder {
      animationConfiguration = builder(&animationConfiguration)
    }
    
    var transitioningController = self.base.transitioningController
    if transitioningController == nil {
      transitioningController = VMDrawerTransitioningController()
      
      self.base.transitioningController = transitioningController
    }
    
    transitioningController!.animationConfiguration = animationConfiguration
    
    viewController.transitioningController = transitioningController
    
    viewController.modalPresentationStyle = .custom
    viewController.transitioningDelegate = transitioningController
    
    self.base.present(viewController, animated: true, completion: nil)
  }
  
  public func registerOpenDrawerGesture(_ gestureType: VMDrawerAnimationConfiguration.TransitionGestureType, maximumDraggingPercent: CGFloat? = nil, transitionHandler: @escaping TransitionHandler) {
    var animationConfiguration = VMDrawerAnimationConfiguration.default()
    
    if let maximumDraggingPercent = maximumDraggingPercent {
      animationConfiguration = animationConfiguration.update {
        $0.maximumDraggingPercent = maximumDraggingPercent
      }
    }
    
    var transitioningController = self.base.transitioningController
    if transitioningController == nil {
      transitioningController = VMDrawerTransitioningController()
      
      self.base.transitioningController = transitioningController
    }
    
    transitioningController!.animationConfiguration = animationConfiguration
    transitioningController!.transitionHandler = transitionHandler
    
    self.base.transitioningController = transitioningController
    
    self.base.transitioningDelegate = transitioningController
    
    self.base.isRegisterGesture = true
    
    transitioningController!.registerGesture(gestureType, on: self.base)
  }
  
  public func pushViewControllerFromDrawer(_ viewController: UIViewController, animated: Bool) {
    let presentingViewController = self.base.presentingViewController
    
    let presentingNavigationController = presentingViewController as? UINavigationController ?? presentingViewController?.navigationController ?? (presentingViewController as? UITabBarController)?.selectedViewController as? UINavigationController
    
    let presentingNavigationTransition = CATransition()
    presentingNavigationTransition.type = .push
    presentingNavigationTransition.subtype = self.base.transitioningController?.animationConfiguration.direction == .left ? .fromLeft : .fromRight
    
    presentingNavigationTransition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    
    presentingNavigationTransition.duration = 0.2
    
    presentingNavigationController?.view.layer.add(presentingNavigationTransition, forKey: nil)
    
    self.base.dismiss(animated: true, completion: nil)
    presentingNavigationController?.pushViewController(viewController, animated: false)
  }
  
  public func presentFromDrawer(_ viewController: UIViewController, animated: Bool, closeDrawer: Bool, completion: (() -> Void)? = nil) {
    if closeDrawer {
      let presentingViewController = self.base.presentingViewController
      
      self.base.dismiss(animated: true) {
        presentingViewController?.present(viewController, animated: animated, completion: completion)
      }
    }
    else {
      viewController.modalPresentationStyle = .overFullScreen
      self.base.present(viewController, animated: animated, completion: completion)
    }
  }
}

private var transitioningControllerKey: Void?
private var isRegisterGestureKey: Void?

extension UIViewController {
  
  var transitioningController: VMDrawerTransitioningController? {
    get {
      return getAssociatedObject(self, &transitioningControllerKey)
    }
    set {
      setRetainedAssociatedObject(self, &transitioningControllerKey, newValue)
    }
  }
  
  var isRegisterGesture: Bool {
    get {
      return getAssociatedObject(self, &isRegisterGestureKey) ?? false
    }
    set {
      setRetainedAssociatedObject(self, &isRegisterGestureKey, newValue)
    }
  }
}

#endif
