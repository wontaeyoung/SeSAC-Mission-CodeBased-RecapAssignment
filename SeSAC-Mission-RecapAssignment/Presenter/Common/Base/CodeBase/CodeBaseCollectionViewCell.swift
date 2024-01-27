//
//  CodeBaseCollectionViewCell.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/27/24.
//

import UIKit

class CodeBaseCollectionViewCell: UICollectionViewCell {
  
  class var identifier: String {
    return String(describing: self)
  }
  
  @MainActor func setHierarchy() { }
  @MainActor func setAttribute() { }
  @MainActor func setConstraint() { }
  
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    setHierarchy()
    setAttribute()
    setConstraint()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
