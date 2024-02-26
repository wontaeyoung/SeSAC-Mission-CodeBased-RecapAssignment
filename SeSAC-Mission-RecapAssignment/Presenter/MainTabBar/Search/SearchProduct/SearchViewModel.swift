//
//  SearchViewModel.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/21/24.
//

import Foundation

final class SearchViewModel: ViewModel {
  
  // MARK: - Property
  weak var coordinator: SearchCoordinator?
  var numberOfRows: Int {
    return recentSearches.current.count
  }
  
  var isKeywordsEmpty: Bool {
    return recentSearches.value.isEmpty
  }
  
  // MARK: - Event
  var recentSearches: Observable<[String]> = Observable(User.default.recentSearches)
  var deleteAllButtonTapEvent: Observable<Void?> = Observable(nil)
  var deleteRowButtonTapEvent: Observable<Int?> = Observable(nil)
  var searchButtonTapEvent: Observable<String?> = Observable(nil)
  var searchKeywordCellTapEvent: Observable<IndexPath?> = Observable(nil)
  
  init(coordinator: SearchCoordinator) {
    self.coordinator = coordinator
    transform()
  }
  
  private func transform() {
    deleteAllButtonTapEvent.bind { _ in
      self.showDeleteAllAlert {
        User.default.recentSearches.removeAll()
        self.fetchRecentSearches()
      }
    }
    
    deleteRowButtonTapEvent.bind { row in
      guard let row else { return }
      
      User.default.recentSearches.remove(at: row)
      self.fetchRecentSearches()
    }
    
    searchButtonTapEvent.bind { keyword in
      guard let keyword else { return }
      
      self.search(keyword)
    }
    
    searchKeywordCellTapEvent.bind { [weak self] indexPath in
      guard let self else { return }
      guard let indexPath else { return }
      
      let keyword = keywordAt(indexPath)
      search(keyword)
    }
  }
  
  private func fetchRecentSearches() {
    recentSearches.set(User.default.recentSearches)
  }
  
  private func search(_ keyword: String) {
    User.default.addNewSearchKeyword(keyword)
    fetchRecentSearches()
    showSearchResultViewController(keyword: keyword)
  }
  
  func keywordAt(_ indexPath: IndexPath) -> String {
    return recentSearches.current[indexPath.row]
  }
  
  func showSearchResultViewController(keyword: String) {
    coordinator?.showSearchResultViewController(keyword: keyword)
  }
  
  func showDeleteAllAlert(completion: @escaping () -> Void) {
    coordinator?.showDeleteAllAlert(completion: completion)
  }
}
