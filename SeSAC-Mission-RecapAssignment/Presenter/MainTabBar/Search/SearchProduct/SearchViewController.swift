//
//  SearchViewController.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/21/24.
//

import UIKit
import SnapKit

final class SearchViewController: CodeBaseViewController, Navigatable {
  
  // MARK: - UI
  private lazy var searchBar = UISearchBar().configured {
    $0.placeholder = "브랜드, 상품, 프로필, 태그 등"
    $0.barTintColor = .clear
    $0.tintColor = .accent
    $0.searchTextField.textColor = .raText
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.spellCheckingType = .no
    $0.delegate = self
  }
  
  private let emptyImageView = UIImageView().configured {
    $0.image = .empty
    $0.contentMode = .scaleAspectFit
  }
  
  private let emptyLabel = UILabel().configured {
    $0.text = "최근 검색어가 없어요"
    $0.font = RADesign.Font.plainBold.font
    $0.textColor = .raText
    $0.textAlignment = .center
  }
  
  private let recentSearchLabel = UILabel().configured {
    $0.text = "최근 검색"
    $0.font = RADesign.Font.plainBold.font
    $0.textColor = .raText
  }
  
  private let deleteAllButton = UIButton().configured { button in
    button.configuration = .plain().configured {
      $0.baseForegroundColor = .accent
    }
    .titleAttributed(with: "모두 지우기", font: RADesign.Font.plainBold.font)
  }
  
  private lazy var recentSearchTableView = UITableView().configured {
    $0.backgroundColor = .clear
    $0.delegate = self
    $0.dataSource = self
    $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
  }
  
  private lazy var emptyView: [UIView] = [emptyImageView, emptyLabel]
  private lazy var searchKeywordView: [UIView] = [recentSearchLabel, deleteAllButton, recentSearchTableView]
  
  
  // MARK: - Property
  private let viewModel: SearchViewModel
  
  
  // MARK: - Initializer
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      searchBar,
      emptyImageView, emptyLabel,
      recentSearchLabel, deleteAllButton, recentSearchTableView
    )
  }
  
  override func setAttribute() {
    navigationItem.title = User.default.nickname + "님의 새싹쇼핑"
    navigationItem.backButtonTitle = ""
    
    deleteAllButton.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
    hideViewBy()
  }
  
  override func setConstraint() {
    
    searchBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
    }
    
    emptyImageView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.height.equalTo(emptyImageView.snp.width).multipliedBy(0.6)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImageView.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(emptyImageView.snp.width)
    }
    
    recentSearchLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.centerY.equalTo(deleteAllButton)
    }
    
    deleteAllButton.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom).offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    recentSearchTableView.snp.makeConstraints {
      $0.top.equalTo(deleteAllButton.snp.bottom).offset(10)
      $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    viewModel.recentSearches.bind { [weak self] _ in
      guard let self else { return }
      hideViewBy()
      recentSearchTableView.reloadData()
    }
  }
  
  private func hideViewBy() {
    searchKeywordView.forEach { $0.isHidden = viewModel.isKeywordsEmpty }
    emptyView.forEach { $0.isHidden = !viewModel.isKeywordsEmpty }
  }
  
  @objc private func deleteAllButtonTapped() {
    viewModel.deleteAllButtonTapEvent.set(())
  }
}

extension SearchViewController: TableConfigurable {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
    let row: Int = indexPath.row
    let keyword: String = viewModel.keywordAt(indexPath)
    
    cell.selectionStyle = .none
    cell.setData(text: keyword, tag: row) { [weak self] in
      guard let self else { return }
      viewModel.deleteRowButtonTapEvent.set(row)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.searchKeywordCellTapEvent.set(indexPath)
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.searchButtonTapEvent.set(searchBar.text)
    view.endEditing(true)
  }
  
  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if range.location == .zero, text == " " {
      return false
    }
    
    return true
  }
}
