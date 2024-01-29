//
//  ProfileImageCollectionViewCell.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/21/24.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: CodeBaseCollectionViewCell {
  
  // MARK: - UI
  let profileImageView = ProfileImageView()
  
  
  // MARK: - Life cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    profileImageView.layer.borderWidth = .zero
  }
  
  override func setHierarchy() {
    contentView.addSubview(profileImageView)
  }
  
  override func setConstraint() {
    profileImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
