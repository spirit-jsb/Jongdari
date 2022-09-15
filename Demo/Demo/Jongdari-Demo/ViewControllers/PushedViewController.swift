//
//  PushedViewController.swift
//  Jongdari-Demo
//
//  Created by max on 2022/9/14.
//

import UIKit
import Koinu

@available(iOS 13.0, *)
class CustomNavigationBar: UINavigationBar {
  
  override func draw(_ rect: CGRect) {
    UIColor.white.setFill()
    UIColor.systemIndigo.setStroke()
    
    let path  = UIBezierPath(rect: rect)
    path.lineWidth = 4.0
    path.fill()
    path.stroke()
  }
}

class PushedViewController: UITableViewController {
  
  @available(iOS 13.0, *)
  lazy var appearance: UINavigationBarAppearance = {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    
    appearance.backgroundColor = UIColor.white
    
    appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]
    
    return appearance
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Pushed from drawer"
    
    if #available(iOS 13.0, *) {
      self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
    }
    if #available(iOS 13.0, *) {
      self.navigationController?.navigationBar.standardAppearance = self.appearance
      self.navigationController?.navigationBar.scrollEdgeAppearance = self.appearance
    }
  }
  
  override var navigationBarClass: AnyClass? {
    if #available(iOS 13.0, *) {
      return CustomNavigationBar.self
    }
    else {
      return nil
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension PushedViewController {
  
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    let velocityPoint = scrollView.panGestureRecognizer.velocity(in: scrollView)
    
    if velocityPoint.y > 120.0 {
      self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    else if velocityPoint.y < -120.0 {
      self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
  }
}
