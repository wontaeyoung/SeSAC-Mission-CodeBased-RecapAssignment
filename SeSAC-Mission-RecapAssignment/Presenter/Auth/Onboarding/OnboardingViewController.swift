//
//  OnboardingViewController.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/19/24.
//

import UIKit
import SnapKit

final class OnboardingViewController: CodeBaseViewController, Navigatable {
  
  // MARK: - UI
  private let titleImageView = UIImageView().configured { $0.image = .sesacShopping }
  private let onboardingImageView = UIImageView().configured { $0.image = .onboarding }
  private let startButton = PrimaryButton(text: "시작하기", font: RADesign.Font.primaryTitle.font)
  
  
  // MARK: - Property
  private let viewModel: OnboardingViewModel
  
  
  // MARK: - Initializer
  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(titleImageView, onboardingImageView, startButton)
  }
  
  override func setAttribute() {
    navigationItem.backButtonTitle = ""
    startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
  }
  
  override func setConstraint() {
    
    onboardingImageView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(60)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(onboardingImageView.snp.width)
    }
  }
}

extension OnboardingViewController {
  
  @objc private func startButtonTapped(_ sender: UIButton) {
    viewModel.showNicknameSettingViewController()
  }
}
