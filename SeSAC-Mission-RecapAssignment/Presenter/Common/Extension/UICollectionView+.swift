//
//  UICollectionView+.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/27/24.
//

import UIKit

extension UICollectionView {
  func setLayout(
    count: Int,
    spacing: CGFloat,
    heightBuffer: CGFloat = .zero
  ) {
    
    let width: CGFloat =
    (UIScreen.main.bounds.width - (spacing * CGFloat(2 + count - 1)))
    / CGFloat(count)
    
    self.collectionViewLayout = UICollectionViewFlowLayout().configured {
      $0.itemSize = CGSize(width: width, height: width + heightBuffer)
      $0.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
      $0.minimumLineSpacing = spacing
      $0.minimumInteritemSpacing = spacing
    }
  }
}
