//
//  SearchResultViewController.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/22/24.
//

import UIKit
import SnapKit

final class SearchResultViewController: CodeBaseViewController, Navigatable {
  
  // MARK: - UI
  private let resultCountLabel = UILabel().configured {
    $0.font = RADesign.Font.captionBold.font
    $0.textColor = .accent
  }
  
  private let sortButtons: [UIButton] = NaverAPIEndpoint.Sort.allCases.enumerated().map { index, sortCase in
    
    return UIButton().configured { button in
      button.tag = index
      button.configuration = .borderedProminent().configured {
        $0.title = sortCase.title
        $0.cornerStyle = .medium
        $0.buttonSize = .mini
        $0.background.strokeColor = .raText
        $0.background.strokeWidth = 1
      }
    }
  }
  
  private lazy var sortStackView = UIStackView().configured { stack in
    stack.axis = .horizontal
    stack.distribution = .fillProportionally
    stack.spacing = 4
    
    sortButtons.forEach {
      stack.addArrangedSubview($0)
    }
  }
  
  private lazy var productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).configured {
    let cell = ProductCollectionViewCell.self
    
    $0.backgroundColor = .clear
    $0.delegate = self
    $0.dataSource = self
    $0.prefetchDataSource = self
    $0.register(cell, forCellWithReuseIdentifier: cell.identifier)
    $0.setLayout(count: 2, spacing: 8, heightBuffer: 100)
  }
  
  private lazy var loadingIndicator = UIActivityIndicatorView().configured {
    $0.style = .large
    $0.center = view.center
    $0.hidesWhenStopped = true
    $0.startAnimating()
  }
  
  
  // MARK: - Property
  private let viewModel: SearchResultViewModel
  
  override func bind() {
    viewModel.products.bind { [weak self] _ in
      guard let self else { return }
      
      stopLoading()
      productCollectionView.reloadData()
    }
    
    viewModel.currentSortType.bind { [weak self] _ in
      guard let self else { return }
      
      configureSortButtons()
      startLoading()
    }
    
    viewModel.totalResultCount.bind { [weak self] count in
      guard let self else { return }
      guard let count else { return }
      
      resultCountLabel.text = "\(count.formatted) 개의 검색 결과"
    }
  }
  
  
  // MARK: - Initializer
  init(viewModel: SearchResultViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  
  // MARK: - Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    productCollectionView.reloadData()
  }
  
  override func setHierarchy() {
    view.addSubviews(
      resultCountLabel,
      sortStackView,
      productCollectionView,
      loadingIndicator
    )
  }
  
  override func setAttribute() {
    navigationItem.title = viewModel.searchKeyword
    navigationItem.backButtonTitle = ""
    
    sortButtons.forEach {
      $0.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    
    configureSortButtons()
  }
  
  override func setConstraint() {
    resultCountLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview().inset(8)
    }
    
    sortStackView.snp.makeConstraints {
      $0.top.equalTo(resultCountLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().inset(8)
      $0.trailing.greaterThanOrEqualToSuperview().offset(-8)
    }
    
    productCollectionView.snp.makeConstraints {
      $0.top.equalTo(sortStackView.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: - Method
  private func configureSortButtons() {
    sortButtons.forEach { button in
      let isSelected: Bool = viewModel.currentSortType.current.tag == button.tag
      
      button.configuration?.configure {
        $0.baseForegroundColor = isSelected ? .raBackground : .raText
        $0.baseBackgroundColor = isSelected ? .raText : .raBackground
      }
    }
  }
  
  @objc private func sortButtonTapped(_ sender: UIButton) {
    viewModel.sortButtonTapEvent.set(sender.tag)
  }
  
  @objc func likeButtonTapped(_ sender: UIButton) {
    viewModel.likeButtonTapEvent.set(sender.tag)

    let reloadAt = [IndexPath(row: sender.tag, section: 0)]
    productCollectionView.reloadItems(at: reloadAt)
  }
}

// MARK: - Loading Indicator
extension SearchResultViewController {
  func startLoading() {
    loadingIndicator.startAnimating()
  }
  
  func stopLoading() {
    loadingIndicator.stopAnimating()
  }
}

// MARK: - Collection View Delegate
extension SearchResultViewController: CollectionConfigurable {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItems
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ProductCollectionViewCell.identifier,
      for: indexPath
    ) as! ProductCollectionViewCell
    let product = viewModel.productAt(indexPath)
    
    cell.setData(product: product, tag: indexPath.row)
    cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.productCellTapEvent.set(indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) { 
    viewModel.prefetchItemsEvent.set(indexPaths)
  }
}
