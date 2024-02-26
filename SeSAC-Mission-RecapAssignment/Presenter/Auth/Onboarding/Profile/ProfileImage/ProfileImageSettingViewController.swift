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
      let cell = ProfileImageCollectionViewCell.self
      
      $0.backgroundColor = .clear
      $0.delegate = self
      $0.dataSource = self
      $0.register(cell, forCellWithReuseIdentifier: cell.identifier)
      $0.setLayout(count: 4, spacing: 16, heightBuffer: .zero)
    }
  
  
  // MARK: - Property
  private let viewModel: ProfileImageSettingViewModel
  
  
  // MARK: - Initializer
  init(viewModel: ProfileImageSettingViewModel) {
    self.viewModel = viewModel
    
    super.init()
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
  
  override func bind() {
    viewModel.currentProfile.bind { [weak self] in
      guard let self else { return }
      
      currentProfileImageView.image = $0.image
      profileImageCollectionView.reloadData()
    }
  }
  
  // MARK: - Method
  func setNavigationTitle(with title: String) {
    self.navigationItem.title = title
  }
}

extension ProfileImageSettingViewController: CollectionConfigurable {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.collectionCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ProfileImageCollectionViewCell.identifier,
      for: indexPath
    ) as! ProfileImageCollectionViewCell
    let profile = viewModel.profile(at: indexPath)
    
    cell.profileImageView.image = profile.image
    
    if viewModel.isCurrentProfile(at: indexPath) {
      cell.profileImageView.toggleSelected()
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.updateProfileImage(at: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) { }
}
