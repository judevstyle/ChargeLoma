//
//  UIImageView+Kingfisher.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 4/1/2565 BE.
//

import Foundation
import Kingfisher
import UIKit

extension KingfisherWrapper where Base : Kingfisher.KFCrossPlatformImageView {
    func setImageDefault(with urlImage: URL){
        self.setImage(with: urlImage,
                      placeholder: UIImage(named: "placeholder"),
                      options: [
                        .loadDiskFileSynchronously,
                        .cacheOriginalImage,
                        .transition(.fade(0.15))],
                      progressBlock: { receivedSize, totalSize in
                        
                      },
                      completionHandler: { result in
                        
                      })
    }
    
}

extension UIImageView {
    public func roundCornersImage(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    public func setPlaceholderImageView () {
        self.image = UIImage(named: "placeholder")
        self.contentMode = .scaleAspectFill
    }
}
