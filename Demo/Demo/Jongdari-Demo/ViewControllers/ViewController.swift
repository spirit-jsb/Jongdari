//
//  ViewController.swift
//  Jongdari-Demo
//
//  Created by max on 2022/9/5.
//

import UIKit
import Jongdari

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
//    self.vm.registerOpenDrawerGesture(<#T##gestureType: VMDrawerAnimationConfiguration.TransitionGestureType##VMDrawerAnimationConfiguration.TransitionGestureType#>, maximumDraggingPercent: <#T##CGFloat?#>, transitionHandler: <#T##JongdariWrapper<ViewController>.TransitionHandler##JongdariWrapper<ViewController>.TransitionHandler##(VMDrawerAnimationConfiguration.TransitionDirection) -> Void#>)
    
    self.vm.open(UIViewController()) { (a) in
      a.openDuration = 10.0
      
      return a
    }
  }
  
  
}

