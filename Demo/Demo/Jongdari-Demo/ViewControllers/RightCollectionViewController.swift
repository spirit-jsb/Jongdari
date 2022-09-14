//
//  RightCollectionViewController.swift
//  Jongdari-Demo
//
//  Created by max on 2022/9/13.
//

import UIKit
import Koinu

class RightCollectionViewController: UICollectionViewController {
  
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
    
    self.vm.presentFromDrawer(presentedNavigationController, animated: true, closeDrawer: false, completion: nil)
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

extension RightCollectionViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.examples.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.examples[section].count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JongdariCell", for: indexPath) as! RightCollectionViewCell
    
    let example = self.examples[indexPath.section][indexPath.row]
    
    cell.textLabel.text = example.titleText
    cell.textLabel.font = UIFont.systemFont(ofSize: 17.0)
    if #available(iOS 13.0, *) {
      cell.textLabel.textColor = UIColor(dynamicProvider: { $0.userInterfaceStyle == .light ? UIColor.black : UIColor.white })
    }
    else {
      cell.textLabel.textColor = UIColor.black
    }
    cell.textLabel.textAlignment = .center
    
    return cell
  }
}

extension RightCollectionViewController {
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let example = self.examples[indexPath.section][indexPath.row]
    
    self.perform(example.selector)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      collectionView.deselectItem(at: indexPath, animated: true)
    }
  }
}

extension RightCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width - 8.0 * 2.0, height: 44.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 8.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return .zero
  }
}
