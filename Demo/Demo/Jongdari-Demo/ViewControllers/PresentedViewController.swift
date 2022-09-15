//
//  PresentedViewController.swift
//  Jongdari-Demo
//
//  Created by max on 2022/9/14.
//

import UIKit
import Koinu

class PresentedViewController: UIViewController {
  
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
    
    self.navigationItem.title = "Presented from drawer"
    
    if #available(iOS 13.0, *) {
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(tapDismiss(_:)))
    }
    
    if #available(iOS 13.0, *) {
      self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
    }
    if #available(iOS 13.0, *) {
      self.navigationController?.navigationBar.standardAppearance = self.appearance
      self.navigationController?.navigationBar.scrollEdgeAppearance = self.appearance
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @objc private func tapDismiss(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
}
