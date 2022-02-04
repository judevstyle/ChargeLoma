//
//  ForYouViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol ForYouProtocolInput {
}

protocol ForYouProtocolOutput: class {
    
    func getCellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func getNumberOfItemsInSection(_ collectionView: UICollectionView, section: Int) -> Int
}

protocol ForYouProtocol: ForYouProtocolInput, ForYouProtocolOutput {
    var input: ForYouProtocolInput { get }
    var output: ForYouProtocolOutput { get }
}

class ForYouViewModel: ForYouProtocol, ForYouProtocolOutput {
    var input: ForYouProtocolInput { return self }
    var output: ForYouProtocolOutput { return self }
    
    // MARK: - Properties
    private var vc: ForYouViewController
    
    init(
        vc: ForYouViewController
    ) {
        self.vc = vc
    }
    
    // MARK - Data-binding OutPut

    
    func getCellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForYouRecentlyCollectionViewCell.identifier, for: indexPath) as! ForYouRecentlyCollectionViewCell
            cell.viewModel.input.setViewController(vc: vc)
            cell.viewModel.input.getStationFavorite()
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForYouLastedCollectionViewCell.identifier, for: indexPath) as! ForYouLastedCollectionViewCell
            return cell
        } else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForYouInfoCollectionViewCell.identifier, for: indexPath) as! ForYouInfoCollectionViewCell
            cell.viewModel.input.setViewController(vc: vc)
//            cell.viewModel.input.getInformation()
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func getNumberOfItemsInSection(_ collectionView: UICollectionView, section: Int) -> Int {
        return 3
    }
}
