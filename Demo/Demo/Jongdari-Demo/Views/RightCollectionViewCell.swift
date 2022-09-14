//
//  RightCollectionViewCell.swift
//  Jongdari-Demo
//
//  Created by max on 2022/9/14.
//

import UIKit

class RightCollectionViewCell: UICollectionViewCell {
  
  lazy var textLabel = UILabel()
  
  private lazy var _topSeparatorView = UIView()
  private lazy var _bottomSeparatorView = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func awakeFromNib() {
    self.textLabel.translatesAutoresizingMaskIntoConstraints = false
    
    self._topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    self._topSeparatorView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    
    self._bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    self._bottomSeparatorView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    
    self.contentView.addSubview(self.textLabel)
    self.contentView.addSubview(self._topSeparatorView)
    self.contentView.addSubview(self._bottomSeparatorView)
    
    self.textLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
    self.textLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    
    self._topSeparatorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
    self._topSeparatorView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
    self._topSeparatorView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    self._topSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    
    self._bottomSeparatorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
    self._bottomSeparatorView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    self._bottomSeparatorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    self._bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    
    super.awakeFromNib()
  }
}
