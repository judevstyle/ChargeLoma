//
//  UIButton+Extension.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 8/1/2565 BE.
//

import Foundation
import UIKit

public extension UIButton {

    func alignTextBelow(spacing: CGFloat = 8.0) {
            guard let image = self.imageView?.image else {
                return
            }

            guard let titleLabel = self.titleLabel else {
                return
            }

            guard let titleText = titleLabel.text else {
                return
            }

            let titleSize = titleText.size(withAttributes: [
                NSAttributedString.Key.font: titleLabel.font as Any
            ])

            titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
        }

}
