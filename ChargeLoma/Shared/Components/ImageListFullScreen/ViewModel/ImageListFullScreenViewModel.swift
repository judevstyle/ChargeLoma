//
//  ImageListFullScreenViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 22/1/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol ImageListFullScreenProtocolInput {
    func setListImage(listImage: [String])
    func setSelectedIndex(index: Int?)
    func fetchListImage()
}

protocol ImageListFullScreenProtocolOutput: class {
    var didFetchListImageSuccess: (() -> Void)? { get set }
    
    func getCellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func getNumberOfItemsInSection() -> Int
    
    func getSelectedIndex() -> Int
}

protocol ImageListFullScreenProtocol: ImageListFullScreenProtocolInput, ImageListFullScreenProtocolOutput {
    var input: ImageListFullScreenProtocolInput { get }
    var output: ImageListFullScreenProtocolOutput { get }
}

class ImageListFullScreenViewModel: ImageListFullScreenProtocol, ImageListFullScreenProtocolOutput {
    
    var input: ImageListFullScreenProtocolInput { return self }
    var output: ImageListFullScreenProtocolOutput { return self }
    
    // MARK: - Properties
    private var ImageListFullScreenViewController: ImageListFullScreenViewController
    
    init(
        ImageListFullScreenViewController: ImageListFullScreenViewController
    ) {
        self.ImageListFullScreenViewController = ImageListFullScreenViewController
    }
    
    // MARK - Data-binding OutPut
    var didFetchListImageSuccess: (() -> Void)?
    
    fileprivate var listImage: [String] = []
    fileprivate var selectedIndex: Int?
    
    func fetchListImage() {
        didFetchListImageSuccess?()
    }
    
    func setListImage(listImage: [String]) {
        self.listImage = listImage
    }
    
    func getSelectedIndex() -> Int {
        return selectedIndex ?? 0
    }
    
    func setSelectedIndex(index: Int?) {
        self.selectedIndex = index
    }
    
    func getNumberOfItemsInSection() -> Int {
        return self.listImage.count
    }
    
    func getCellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageFullScreenCollectionViewCell.identifier, for: indexPath) as! ImageFullScreenCollectionViewCell
        cell.imageUrl = self.listImage[indexPath.item]
        return cell
    }
    
}
