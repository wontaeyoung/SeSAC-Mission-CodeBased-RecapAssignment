//
//  NicknameSettingViewController.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/20/24.
//

import UIKit
import SnapKit

final class NicknameSettingViewController: CodeBaseViewController, Navigatable {
  
  // MARK: - UI
  private let profileImageView = ProfileImageView(isSelected: true).configured {
    $0.image = User.default.profile.image
  }
  
  private let nicknameField = UITextField().configured {
    $0.placeholder = "닉네임을 입력해주세요 :)"
    $0.text = User.default.nickname
    $0.borderStyle = .none
    $0.textColor = .raText
    $0.backgroundColor = .clear
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.spellCheckingType = .no
  }
  
  private let hintLabel = UILabel().configured {
    $0.font = RADesign.Font.caption.font
    $0.textColor = .red
    $0.textAlignment = .left
    $0.numberOfLines = 2
  }
  
  private let finishButton = PrimaryButton(text: "완료", font: RADesign.Font.primaryTitle.font)
  
  // MARK: - Property
  private let viewModel: NicknameSettingViewModel
  private var isFinishButtonEnable: Bool = false {
    didSet {
      toggleFinishButton()
    }
  }
  
  // MARK: - Initializer
  init(viewModel: NicknameSettingViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  
  // MARK: - Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    profileImageView.image = User.default.profile.image
  }
  
  override func viewDidLayoutSubviews() {
    let underline = CALayer().configured { layer in
      layer.backgroundColor = UIColor.raText.cgColor
      layer.frame = CGRect(
        x: 0,
        y: nicknameField.frame.size.height,
        width: nicknameField.frame.size.width,
        height: 2
      )
    }
    
    nicknameField.layer.addSublayer(underline)
  }

  override func setHierarchy() {
    view.addSubviews(
      profileImageView,
      nicknameField,
      hintLabel,
      finishButton
    )
  }
  
  override func setAttribute() {
    self.finishableKeyboardEditing = true
    
    profileImageView.isUserInteractionEnabled = true
    profileImageView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
    )
    
    nicknameField.addTarget(self, action: #selector(textfieldDidChanged), for: .editingChanged)
    finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
    
    toggleFinishButton()
    textfieldDidChanged(nicknameField)
  }
  
  override func setConstraint() {
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(100)
    }
    
    nicknameField.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.height.equalTo(40)
    }
    
    hintLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameField.snp.bottom).offset(12)
      $0.horizontalEdges.equalToSuperview().inset(24)
      $0.height.equalTo(21)
    }
    
    finishButton.snp.makeConstraints {
      $0.top.equalTo(hintLabel.snp.bottom).offset(24)
      $0.horizontalEdges.equalToSuperview().inset(16)
    }
  }
  
  override func bind() {
    viewModel.outputHintText.bind {
      self.updateHintText($0)
    }
    
    viewModel.outputValidation.bind {
      self.changeHintColor(isValid: $0)
      self.changeFinishButtonEnabled(isValid: $0)
    }
  }
  
  // MARK: - Method
  func setNavigationTitle(with title: String) {
    self.navigationItem.title = title
    self.navigationItem.backButtonTitle = ""
  }
  
  @objc private func profileImageTapped() {
    viewModel.showProfileImageSttingViewController()
  }
  
  @objc private func finishButtonTapped(_ sender: UIButton) {
    viewModel.applyNickname(nicknameField.text!)
    viewModel.switchView()
  }
}

// MARK: - 닉네임 유효성
extension NicknameSettingViewController {
  @objc private func textfieldDidChanged(_ sender: UITextField) {
    viewModel.inputNickname.set(sender.text!)
  }
  
  private func updateHintText(_ text: String?) {
    hintLabel.text = text
  }
  
  private func changeHintColor(isValid: Bool) {
    hintLabel.textColor = isValid ? .accent : .red
  }
  
  private func changeFinishButtonEnabled(isValid: Bool) {
    isFinishButtonEnable = isValid
  }
  
  private func toggleFinishButton() {
    finishButton.isEnabled = isFinishButtonEnable
    finishButton.configuration?.configure {
      $0.baseBackgroundColor = isFinishButtonEnable ? .accent : .gray
    }
  }
}
