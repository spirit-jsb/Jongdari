//
//  ViewController.swift
//  Jongdari-Demo
//
//  Created by max on 2022/9/5.
//

import UIKit
import Jongdari

struct JongdariExample {
  
  let titleText: String?
  let selector: Selector?
}

class ViewController: UITableViewController {
  
  var examples = [[JongdariExample]]()
  
  @available(iOS 13.0, *)
  lazy var appearance: UINavigationBarAppearance = {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    
    appearance.backgroundColor = UIColor.white
    
    appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]
    appearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 34.0, weight: .bold), .foregroundColor: UIColor.systemIndigo]
    
    return appearance
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.examples = [
      [
        JongdariExample(titleText: "Open drawer from left using default animation", selector: #selector(openDrawerFromLeftUsingDefaultAnimation)),
        JongdariExample(titleText: "Open drawer from left using zoom animation", selector: #selector(openDrawerFromLeftUsingZoomAnimation)),
        JongdariExample(titleText: "Open drawer from left using mask animation", selector: #selector(openDrawerFromLeftUsingMaskAnimation))
      ],
      [
        JongdariExample(titleText: "Open drawer from right using default animation", selector: #selector(openDrawerFromRightUsingDefaultAnimation)),
        JongdariExample(titleText: "Open drawer from right using default animation", selector: #selector(openDrawerFromRightUsingZoomAnimation)),
        JongdariExample(titleText: "Open drawer from right using default animation", selector: #selector(openDrawerFromRightUsingMaskAnimation))
      ]
    ]
    
    self.navigationItem.title = "Jongdari"
    
    if #available(iOS 11.0, *) {
      self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    if #available(iOS 13.0, *) {
      self.navigationController?.navigationBar.standardAppearance = self.appearance
      self.navigationController?.navigationBar.scrollEdgeAppearance = self.appearance
    }
    
    self.vm.registerOpenDrawerGesture(.edge) { (direction) in
      switch direction {
        case .left:
          self.openDrawerFromLeftUsingZoomAnimation()
        case .right:
          self.openDrawerFromRightUsingMaskAnimation()
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @objc func openDrawerFromLeftUsingDefaultAnimation() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let leftTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftTableViewController")
    
    self.vm.open(leftTableViewController) { (animationConfiguration) in
      animationConfiguration.direction = .left
      animationConfiguration.animationType = .default
      
      return animationConfiguration
    }
  }
  
  @objc func openDrawerFromLeftUsingZoomAnimation() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let leftTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftTableViewController")
    
    self.vm.open(leftTableViewController) { (animationConfiguration) in
      animationConfiguration.direction = .left
      animationConfiguration.animationType = .zoom
      
      return animationConfiguration
    }
  }
  
  @objc func openDrawerFromLeftUsingMaskAnimation() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let leftTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftTableViewController")
    
    self.vm.open(leftTableViewController) { (animationConfiguration) in
      animationConfiguration.direction = .left
      animationConfiguration.animationType = .mask
      
      return animationConfiguration
    }
  }
  
  @objc func openDrawerFromRightUsingDefaultAnimation() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let rightCollectionViewController = mainStoryboard.instantiateViewController(withIdentifier: "RightCollectionViewController")
    
    self.vm.open(rightCollectionViewController) { (animationConfiguration) in
      animationConfiguration.direction = .right
      animationConfiguration.animationType = .default
      
      return animationConfiguration
    }
  }
  
  @objc func openDrawerFromRightUsingZoomAnimation() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let rightCollectionViewController = mainStoryboard.instantiateViewController(withIdentifier: "RightCollectionViewController")
    
    self.vm.open(rightCollectionViewController) { (animationConfiguration) in
      animationConfiguration.direction = .right
      animationConfiguration.animationType = .zoom
      
      return animationConfiguration
    }
  }
  
  @objc func openDrawerFromRightUsingMaskAnimation() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let rightCollectionViewController = mainStoryboard.instantiateViewController(withIdentifier: "RightCollectionViewController")
    
    self.vm.open(rightCollectionViewController) { (animationConfiguration) in
      animationConfiguration.direction = .right
      animationConfiguration.animationType = .mask
      
      return animationConfiguration
    }
  }
}

extension ViewController {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return self.examples.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.examples[section].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "JongdariCell", for: indexPath)
    
    let example = self.examples[indexPath.section][indexPath.row]
    
    if #available(iOS 14.0, *) {
      var contentConfiguration = cell.defaultContentConfiguration()
      
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      
      contentConfiguration.attributedText = example.titleText.flatMap { NSAttributedString(string: $0, attributes: [.font: UIFont.systemFont(ofSize: 17.0), .paragraphStyle: paragraphStyle, .foregroundColor: UIColor(dynamicProvider: { $0.userInterfaceStyle == .light ? UIColor.black : UIColor.white })]) }
      
      cell.contentConfiguration = contentConfiguration
    }
    else {
      cell.textLabel?.text = example.titleText
      cell.textLabel?.font = UIFont.systemFont(ofSize: 17.0)
      if #available(iOS 13.0, *) {
        cell.textLabel?.textColor = UIColor(dynamicProvider: { $0.userInterfaceStyle == .light ? UIColor.black : UIColor.white })
      }
      else {
        cell.textLabel?.textColor = UIColor.black
      }
      cell.textLabel?.textAlignment = .center
    }
    
    return cell
  }
}

extension ViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let example = self.examples[indexPath.section][indexPath.row]
    
    self.perform(example.selector)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
}
