//
//  SearchTableViewCell.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/21/24.
//

import UIKit
import SnapKit

final class SearchTableViewCell: CodeBaseTableViewCell {

  
  // MARK: - UI
  private let searchIconImageView = UIImageView().configured {
    $0.image = RADesign.Image.search.image
    $0.tintColor = .raText
  }
  
  private let searchKeywordLabel = UILabel().configured {
    $0.font = RADesign.Font.plain.font
    $0.textColor = .raText
  }
  
  private let deleteButton = UIButton().configured { button in
    button.configuration = .plain().configured {
      $0.image = RADesign.Image.delete.image
      $0.baseForegroundColor = .gray
    }
  }
  
  
  // MARK: - Property
  var deleteRowAction: (() -> Void)?
  
  
  // MARK: - Method
  override func setHierarchy() {
    contentView.addSubviews(searchIconImageView, searchKeywordLabel, deleteButton)
  }
  
  override func setAttribute() {
    deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
  }
  
  override func setConstraint() {
    searchIconImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(searchIconImageView.snp.height)
    }
    
    searchKeywordLabel.snp.makeConstraints {
      $0.leading.equalTo(searchIconImageView.snp.trailing).offset(10)
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(deleteButton.snp.leading)
    }
    
    deleteButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-10)
      $0.centerY.equalToSuperview()
    }
  }
  
  func setData(text: String, tag: Int, completion: @escaping () -> Void) {
    searchKeywordLabel.text = text
    deleteButton.tag = tag
    deleteRowAction = completion
  }
  
  @objc private func deleteButtonTapped(_ sender: UIButton) {
    User.default.recentSearches.remove(at: sender.tag)
    deleteRowAction?()
  }
}

@available(iOS 17.0, *)
#Preview {
  SearchTableViewCell()
}

