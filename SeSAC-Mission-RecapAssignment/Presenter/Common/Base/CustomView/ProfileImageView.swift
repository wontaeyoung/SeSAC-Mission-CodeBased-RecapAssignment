//
//  ProfileImageView.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/29/24.
//

import UIKit
import SnapKit

final class ProfileImageView: UIImageView {
  
  private var isSelected: Bool
  private var hasPhotoIcon: Bool
  
  init(isSelected: Bool = false, hasPhotoIcon: Bool = false) {
    self.isSelected = isSelected
    self.hasPhotoIcon = hasPhotoIcon
    
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    configureUI()
    
    if hasPhotoIcon {
      overlayPhotoIcon()
    }
  }
  
  private func configureUI() {
    self.configure {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = $0.frame.width / 2
      
      if isSelected {
        $0.layer.borderColor = UIColor.accent.cgColor
        $0.layer.borderWidth = 4
      }
    }
  }
  
  private func overlayPhotoIcon() {
    let cameraIcon = UIImageView().configured {
      $0.image = UIImage(systemName: "camera.circle")
      $0.tintColor = .raText
      $0.backgroundColor = .accent
    }
    
    addSubview(cameraIcon)
    
    cameraIcon.snp.makeConstraints {
      $0.trailing.bottom.equalToSuperview()
      $0.size.equalTo(30)
    }
    
    cameraIcon.layer.cornerRadius = cameraIcon.frame.width / 2
  }
}
