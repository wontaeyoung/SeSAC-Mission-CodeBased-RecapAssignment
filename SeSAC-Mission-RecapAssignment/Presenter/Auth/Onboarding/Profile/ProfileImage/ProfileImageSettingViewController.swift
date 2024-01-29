//
//  ProfileImageSettingViewController.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/21/24.
//

import UIKit
import SnapKit

final class ProfileImageSettingViewController: CodeBaseViewController, Navigatable {
  
  // MARK: - UI
  private let currentProfileImageView = ProfileImageView(isSelected: true).configured {
    $0.image = User.default.profile.image
  }
  
  private lazy var profileImageCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: .init()
  )
    .configured {
      
      let cell = UINib(nibName: ProfileImageCollectionViewCell.identifier, bundle: nil)
      
      $0.backgroundColor = .clear
      $0.delegate = self
      $0.dataSource = self
      $0.register(cell, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
      $0.setLayout(count: 4, spacing: 16, heightBuffer: .zero)
    }
  
  
  // MARK: - Property
  private let viewModel: ProfileImageSettingViewModel
  
  
  // MARK: - Initializer
  init(viewModel: ProfileImageSettingViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(currentProfileImageView, profileImageCollectionView)
  }
  
  override func setConstraint() {
    currentProfileImageView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(150)
    }
    
    profileImageCollectionView.snp.makeConstraints {
      $0.top.equalTo(currentProfileImageView.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  
  // MARK: - Method
  func setNavigationTitle(with title: String) {
    self.navigationItem.title = title
  }
  
  private func updateProfileImage(with profile: User.Profile) {
    User.default.profile = profile
    currentProfileImageView.image = User.default.profile.image
    profileImageCollectionView.reloadData()
  }
}

extension ProfileImageSettingViewController: CollectionConfigurable {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return User.Profile.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let profile: User.Profile = .allCases[indexPath.row]
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ProfileImageCollectionViewCell.identifier,
      for: indexPath
    ) as! ProfileImageCollectionViewCell
    
    cell.profileImageView.image = profile.image
    
    if User.default.profile == profile {
      DesignSystemManager.configureSelectedImageView(cell.profileImageView)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    updateProfileImage(with: .allCases[indexPath.row])
  }
  
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) { }
}

@available(iOS 17, *)
#Preview {
  ProfileImageSettingViewController(
    viewModel: .init(coordinator: .init(.init()))
  )
}
