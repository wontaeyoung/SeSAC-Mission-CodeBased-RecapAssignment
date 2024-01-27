//
//  UIButtonConfiguration+.swift
//  SeSAC-Mission-RecapAssignment
//
//  Created by 원태영 on 1/27/24.
//

import UIKit

extension UIButton.Configuration {
  enum InsetDirection {
    case horizontal
    case vertical
    case all
  }
  
  func titleAttributed(with text: String, font: UIFont) -> Self {
    return self.configured {
      let attributes: [NSAttributedString.Key: Any] = [.font: font]
      let attributedTitle = NSAttributedString(string: text, attributes: attributes)
      
      $0.attributedTitle = AttributedString(attributedTitle)
    }
  }
  
  func inset(by direction: InsetDirection, with value: CGFloat) -> Self {
    return self.configured {
      switch direction {
        case .horizontal:
          $0.contentInsets = NSDirectionalEdgeInsets(
            top: self.contentInsets.top,
            leading: value,
            bottom: self.contentInsets.bottom,
            trailing: value
          )
          
        case .vertical:
          $0.contentInsets = NSDirectionalEdgeInsets(
            top: value,
            leading: self.contentInsets.leading,
            bottom: value,
            trailing: self.contentInsets.trailing
          )
          
        case .all:
          $0.contentInsets = NSDirectionalEdgeInsets(top: value, leading: value, bottom: value, trailing: value)
      }
    }
  }
}

