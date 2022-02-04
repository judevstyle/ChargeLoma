//
//  CollectionViewImageGridViewModel.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 6/15/21.
//


import UIKit

protocol CollectionViewImageGridProtocolInput {
    func setList(images: [UIImage]?)
    func addListImage(image: UIImage, base64: String)
    func didSelectItem(indexPath: IndexPath)
    func setDelegate(delegate: CollectionViewImageGridDelegate)
}

protocol CollectionViewImageGridProtocolOutput: class {
    var didSetMenuSuccess: (() -> Void)? { get set }
    
    func getNumberOfCollection() -> Int
    func getItemViewCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

protocol CollectionViewImageGridProtocol: CollectionViewImageGridProtocolInput, CollectionViewImageGridProtocolOutput {
    var input: CollectionViewImageGridProtocolInput { get }
    var output: CollectionViewImageGridProtocolOutput { get }
}

class CollectionViewImageGridViewModel: CollectionViewImageGridProtocol, CollectionViewImageGridProtocolOutput {
    var input: CollectionViewImageGridProtocolInput { return self }
    var output: CollectionViewImageGridProtocolOutput { return self }
    
    // MARK: - Properties
    
    init(
    ) {
    }
    
    // MARK - Data-binding OutPut
    var didSetMenuSuccess: (() -> Void)?
    public weak var delegate: CollectionViewImageGridDelegate?
    fileprivate var listImage: [UIImage]? = []
    fileprivate var listImageBase64: [String]? = []
    
    func setDelegate(delegate: CollectionViewImageGridDelegate) {
        self.delegate = delegate
    }
    
    func setList(images: [UIImage]?) {
        listImage = images
        self.didSetMenuSuccess?()
        self.delegate?.imageListChangeAction(listBase64: self.listImageBase64)
    }
    
    func addListImage(image: UIImage, base64: String) {
        self.listImage?.append(image)
        self.listImageBase64?.append(base64)
        self.didSetMenuSuccess?()
        self.delegate?.imageListChangeAction(listBase64: self.listImageBase64)
    }
    
    func getNumberOfCollection() -> Int {
        guard let count = listImage?.count, count != 0 else { return 1 }
        return count + 1
    }
    
    func getItemViewCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Image1x1ChooseCollectionViewCell.identifier, for: indexPath) as! Image1x1ChooseCollectionViewCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Image1x1CollectionViewCell.identifier, for: indexPath) as! Image1x1CollectionViewCell
            cell.delegate = self
            cell.index = indexPath.row
            if let image =  self.listImage?[indexPath.row-1] {
                cell.imageView.image = image
            }
            return cell
        }
    }
    
    private func deleteItem(index: Int){
        listImage?.remove(at: index - 1)
        listImageBase64?.remove(at: index - 1)
        self.didSetMenuSuccess?()
        self.delegate?.imageListChangeAction(listBase64: self.listImageBase64)
    }
    
    func didSelectItem(indexPath: IndexPath) {
        self.delegate?.didSelectItem(indexPath: indexPath)
    }
    
}

extension CollectionViewImageGridViewModel: Image1x1CollectionViewCellDelegate {
    func didDeleteAction(index: Int) {
        self.deleteItem(index: index)
    }
}
