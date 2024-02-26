//
//  SearchResultViewModel.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/22/24.
//

import Foundation
import Alamofire

final class SearchResultViewModel: ViewModel {
  
  // MARK: - Property
  weak var coordinator: SearchCoordinator?
  var apiContainer = APIContainer()
  let searchKeyword: String
  
  var numberOfItems: Int {
    return products.current.count
  }
  
  // MARK: - Input event
  let sortButtonTapEvent: Observable<Int?> = Observable(nil)
  let likeButtonTapEvent: Observable<Int?> = Observable(nil)
  let productCellTapEvent: Observable<IndexPath?> = Observable(nil)
  let prefetchItemsEvent: Observable<[IndexPath]?> = Observable(nil)
  
  // MARK: - Output Event
  let products: Observable<[Product]> = .init([])
  let currentSortType: Observable<NaverAPIEndpoint.Sort> = .init(.sim)
  let totalResultCount: Observable<Int?> = Observable(nil)
  
  // MARK: - Initializer
  init(coordinator: SearchCoordinator, searchKeyword: String) {
    self.coordinator = coordinator
    self.searchKeyword = searchKeyword
    
    callRequest()
    transform()
  }
  
  private func transform() {
    sortButtonTapEvent.bind { [weak self] sortTag in
      guard let self else { return }
      guard let sortTag else { return }
      let sort: NaverAPIEndpoint.Sort = .allCases[sortTag]
      guard sort != currentSortType.current else { return }
      
      currentSortType.set(sort)
      apiContainer.resetPage()
      resetProducts()
      callRequest()
    }
    
    likeButtonTapEvent.bind { [weak self] row in
      guard let self else { return }
      guard let row else { return }
      
      let productID: String = products.current[row].productID
      User.default.toggleLike(productID: productID)
    }
    
    productCellTapEvent.bind { [weak self] indexPath in
      guard let self else { return }
      guard let indexPath else { return }
      
      let product = productAt(indexPath)
      showProductDetailViewController(product: product)
    }
    
    prefetchItemsEvent.bind { [weak self] indexPaths in
      guard let self else { return }
      guard let indexPaths else { return }
      guard !apiContainer.isEnd else { return }
      
      indexPaths.forEach { [weak self] path in
        guard let self else { return }
        
        if path.row + 1 == products.current.count {
          callRequest()
        }
      }
    }
  }
  
  private func resetProducts() {
    products.value.removeAll()
  }
  
  // MARK: - Method
  func showProductDetailViewController(product: Product) {
    coordinator?.showProductDetailViewController(product: product)
  }
  
  func productAt(_ indexPath: IndexPath) -> Product {
    return products.current[indexPath.row]
  }
}

extension SearchResultViewModel {
  struct APIContainer {
    let display: Int = 30
    var page: Int = 0
    var total: Int = 30
    
    var start: Int {
      return display * (page - 1) + 1
    }
    
    var isEnd: Bool {
      return start > self.total
    }
    
    mutating func increasePage() {
      page += 1
    }
    
    mutating func resetPage() {
      page = 0
    }
  }
  
  func callRequest() -> Void {
    apiContainer.increasePage()
    
    /// total을 초과하는 start에서 API Call을 시도하면 response total 값이 0으로 반환되어서, 결과뷰의 total count 라벨도 0으로 변하는 문제 수정
    guard !apiContainer.isEnd else { return }
    
    let endPoint = NaverAPIEndpoint.shop(
      query: searchKeyword,
      display: apiContainer.display,
      start: apiContainer.start,
      sort: currentSortType.current
    )
    
    let apiRequest = APIRequest(scheme: .https, host: .naverOpenAPI, endpoint: endPoint)
    let headers: HTTPHeaders = [
      APIKey.Naver.clientID.key: APIKey.Naver.clientID.value,
      APIKey.Naver.clientSecret.key: APIKey.Naver.clientSecret.value,
    ]
    
    do {
      try HTTPClient.shared.callRequest(
        apiRequest,
        modelType: ResponseDTO.self,
        headers: headers,
        method: .get
      ) { [weak self] result in
        guard let self else { return }
        
        switch result {
          case .success(let success):
            let newProducts: [Product] = success.items.map { $0.asModel }
            
            apiContainer.total = success.total
            totalResultCount.set(success.total)
            products.value.append(contentsOf: newProducts)
            
          case .failure(let failure):
            let apiError: APIError = HTTPClient.handleAFError(failure)
            
            coordinator?.handle(error: apiError)
        }
      }
    } catch {
      
      coordinator?.handle(error: error)
    }
  }
}
