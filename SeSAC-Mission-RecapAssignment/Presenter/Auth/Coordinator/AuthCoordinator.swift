//
//  AuthCoordinator.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/19/24.
//

import UIKit

final class AuthCoordinator: SubCoordinator {
  
  // MARK: - Property
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  // MARK: - Intializer
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  // MARK: - Method
  func start() {
    showOnboardingViewController()
  }
}

extension AuthCoordinator {
  
  private func showOnboardingViewController() {
    let viewModel = OnboardingViewModel(coordinator: self)
    let viewController = OnboardingViewController(viewModel: viewModel)
    
    self.push(viewController, animation: false)
  }
  
  func showNicknameSettingViewController() {
    let viewModel = NicknameSettingViewModel(coordinator: self)
    let viewController = NicknameSettingViewController(viewModel: viewModel)
    viewController.setNavigationTitle(with: "프로필 설정")
    
    self.push(viewController)
  }
  
  func showProfileImageSttingViewController() {
    let viewModel = ProfileImageSettingViewModel(coordinator: self)
    let viewController = ProfileImageSettingViewController(viewModel: viewModel)
    viewController.setNavigationTitle(with: "프로필 수정")
    
    self.push(viewController)
  }
}
