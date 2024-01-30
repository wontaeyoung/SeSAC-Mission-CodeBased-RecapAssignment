//
//  PrimaryButton.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/30/24.
//

import UIKit

final class PrimaryButton: UIButton {
  
  private let text: String
  private let font: UIFont
  private var image: UIImage?
  
  init(text: String, font: UIFont, image: UIImage? = nil) {
    self.text = text
    self.font = font
    self.image = image
    
    super.init(frame: .zero)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    configuration = .filled().configured {
      $0.baseForegroundColor = .raText
      $0.baseBackgroundColor = .accent
      $0.buttonSize = .large
      $0.cornerStyle = .medium
    }
    .titleAttributed(with: text, font: font)
  }
}
