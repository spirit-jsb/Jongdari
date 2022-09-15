//
//  LeftTableViewController.swift
//  Jongdari-Demo
//
//  Created by max on 2022/9/13.
//

import UIKit
import Koinu

class LeftTableViewController: UITableViewController {
  
  var examples = [[JongdariExample]]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.examples = [
      [
        JongdariExample(titleText: "Present viewController from drawer", selector: #selector(presentViewControllerFromDrawer)),
        JongdariExample(titleText: "Push viewController from drawer", selector: #selector(pushViewControllerFromDrawer)),
        JongdariExample(titleText: "Dismiss drawer", selector: #selector(dismissDrawer))
      ],
      [
        JongdariExample(titleText: "Present viewController from drawer", selector: #selector(presentViewControllerFromDrawer)),
        JongdariExample(titleText: "Push viewController from drawer", selector: #selector(pushViewControllerFromDrawer)),
        JongdariExample(titleText: "Dismiss drawer", selector: #selector(dismissDrawer))
      ]
    ]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @objc func presentViewControllerFromDrawer() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let presentedViewController = mainStoryboard.instantiateViewController(withIdentifier: "PresentedViewController")
    
    let presentedNavigationController = VMNavigationController(rootViewController: presentedViewController)
    
    self.vm.presentFromDrawer(presentedNavigationController, animated: true, closeDrawer: true, completion: nil)
  }
  
  @objc func pushViewControllerFromDrawer() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let pushedViewController = mainStoryboard.instantiateViewController(withIdentifier: "PushedViewController")
        
    self.vm.pushViewControllerFromDrawer(pushedViewController, animated: true)
  }
  
  @objc func dismissDrawer() {
    self.dismiss(animated: true, completion: nil)
  }
}

extension LeftTableViewController {
  
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

extension LeftTableViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let example = self.examples[indexPath.section][indexPath.row]
    
    self.perform(example.selector)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
}
