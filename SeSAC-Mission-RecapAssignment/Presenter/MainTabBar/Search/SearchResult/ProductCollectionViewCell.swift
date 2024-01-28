//
//  ProductCollectionViewCell.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/22/24.
//

import UIKit
import Kingfisher
import SnapKit

final class ProductCollectionViewCell: CodeBaseCollectionViewCell {
  
  // MARK: - UI
  private let productImageView = UIImageView().configured {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 15
    $0.contentMode = .scaleAspectFill
  }
  
  let likeButton = UIButton().configured { button in
    button.configuration = .filled().configured {
      $0.baseForegroundColor = .raBackground
      $0.baseBackgroundColor = .raText
      $0.cornerStyle = .capsule
    }
  }
  
  private let mallNameLabel = UILabel().configured {
    $0.font = RADesign.Font.caption.font
    $0.textColor = .gray
  }
  
  private let titleLabel = UILabel().configured {
    $0.font = RADesign.Font.caption.font
    $0.textColor = .raText
    $0.numberOfLines = 2
  }
  
  private let priceLabel = UILabel().configured {
    $0.font = RADesign.Font.plainBold.font
    $0.textColor = .raText
  }
  
  
  // MARK: - Method
  override func setHierarchy() {
    contentView.addSubviews(
      productImageView,
      likeButton,
      mallNameLabel,
      titleLabel,
      priceLabel
    )
  }
  
  override func setConstraint() {
    productImageView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(productImageView.snp.width)
    }
    
    likeButton.snp.makeConstraints {
      $0.bottom.trailing.equalTo(productImageView).inset(8)
      $0.size.equalTo(productImageView.snp.size).multipliedBy(0.2)
    }
    
    mallNameLabel.snp.makeConstraints {
      $0.top.equalTo(productImageView.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(8)
      $0.height.equalTo(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(mallNameLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(8)
      $0.bottom.equalTo(priceLabel.snp.top).offset(-8)
    }
    
    priceLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(8)
      $0.bottom.greaterThanOrEqualTo(contentView.safeAreaLayoutGuide).offset(-8)
    }
  }
  
  func setData(product: Product, tag: Int) {
    let likeImage = User.default.likes.contains(product.productID)
    ? RADesign.Image.likeFill.image
    : RADesign.Image.like.image
    
    productImageView.kf.setImage(with: product.url)
    mallNameLabel.text = product.mallName
    titleLabel.text = product.title.asMarkdownRedneredAttributeString?.string
    priceLabel.text = product.lprice.formatted
    likeButton.setImage(likeImage, for: .normal)
    likeButton.tag = tag
  }
}

@available(iOS 17.0, *)
#Preview {
  let cell = ProductCollectionViewCell()
  cell.setData(product: .init(productID: "", title: "상품명\n\n상품명", mallName: "상점명", lprice: 4000, image: ""), tag: 0)
  
  return cell
}
