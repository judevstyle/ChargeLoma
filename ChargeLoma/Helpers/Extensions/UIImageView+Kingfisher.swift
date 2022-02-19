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
    func setImageDefault(with urlImage: URL) {
        self.setImage(with: urlImage,
                      placeholder: UIImage(named: "placeholder"),
                      options: [
                        .loadDiskFileSynchronously,
                        .cacheOriginalImage,
                        .transition(.fade(0.10))],
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
    
    
    public func setImageMarker(url: URL) {
        DispatchQueue.global(qos: .background).async {
            do
            {
                let data = try Data.init(contentsOf: url)
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.image = image.jpeg(.low)
                    } else {
                        self.image = UIImage(named: "placeholder")
                    }
                }
            }
            catch {
                // error
            }
        }
    }
}


extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    
    func jpeg(_ quality: JPEGQuality) -> UIImage {
        if let jpgData = self.jpegData(compressionQuality: quality.rawValue),
           let pngData = UIImage(data: jpgData)?.pngData(),
            let image = UIImage(data: pngData) {
            return image
        } else {
            return UIImage(named: "placeholder")!
        }
    }
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    static func imageNamed(name: String, cache: Bool) -> UIImage? {
        if (cache) {
            return UIImage(named: name)
        }

        // Using NSString for stringByDeletingPathExtension
        let fullName = NSString(string: name)
        let fileName = fullName.deletingPathExtension
        let ext = fullName.pathExtension
        let resourcePath = Bundle.main.path(forResource: fileName, ofType: ext)

        if let path = resourcePath {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
    
}
