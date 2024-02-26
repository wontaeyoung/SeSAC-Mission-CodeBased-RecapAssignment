//
//  SearchDetailViewController.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/22/24.
//

import UIKit
import WebKit
import SnapKit

final class ProductDetailViewController: CodeBaseViewController, Navigatable {
  
  // MARK: - UI
  private lazy var productWebView = WKWebView().configured {
    $0.navigationDelegate = self
  }
  
  private lazy var loadingIndicator = UIActivityIndicatorView().configured {
    $0.style = .large
    $0.center = view.center
    $0.hidesWhenStopped = true
  }
  
  
  // MARK: - Property
  let product: Product
  
  private var urlRequest: URLRequest {
    let endPoint: NaverAPIEndpoint = .shopDetail(productID: product.productID)
    let apiRequest = APIRequest(scheme: .https, host: .naverShopProductDetail, endpoint: endPoint)
    let url = apiRequest.components.url!
    
    return URLRequest(url: url)
  }
  
  
  // MARK: - Initializer
  init(product: Product) {
    self.product = product
    
    super.init()
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(productWebView, loadingIndicator)
  }
  
  override func setAttribute() {
    let isContains: Bool = User.default.likes.contains(product.productID)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: isContains ? RADesign.Image.likeFill.image : RADesign.Image.like.image,
      style: .plain,
      target: self,
      action: #selector(likeButtonTapped)
    )
    
    navigationItem.title = product.title.asMarkdownRedneredAttributeString?.string
    
    productWebView.load(urlRequest)
  }
  
  override func setConstraint() {
    productWebView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  
  // MARK: - Method
  @objc private func likeButtonTapped(_ sender: UIButton) {
    User.default.toggleLike(productID: product.productID)
    updateLikeImage()
  }
  
  private func updateLikeImage() {
    let isContains: Bool = User.default.likes.contains(product.productID)
    
    navigationItem.rightBarButtonItem?.image = isContains
    ? RADesign.Image.likeFill.image
    : RADesign.Image.like.image
  }
}

// MARK: - Loading Indicator
extension ProductDetailViewController {
  func startLoading() {
    loadingIndicator.startAnimating()
  }
  
  func stopLoading() {
    loadingIndicator.stopAnimating()
  }
}

// MARK: - WebView Delegate
extension ProductDetailViewController: WKNavigationDelegate {
  // 로드 시작 시
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    startLoading()
  }
  
  // 로드 완료 시
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    stopLoading()
  }
}
