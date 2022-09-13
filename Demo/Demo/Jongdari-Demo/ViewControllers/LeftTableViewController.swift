//
//  LeftTableViewController.swift
//  Jongdari-Demo
//
//  Created by max on 2022/9/13.
//

import UIKit

class LeftTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
}

extension LeftTableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10.0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChoiwanCell", for: indexPath)
    
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
