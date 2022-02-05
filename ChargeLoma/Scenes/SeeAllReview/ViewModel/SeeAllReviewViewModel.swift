//
//  SeeAllReviewViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 6/2/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol SeeAllReviewProtocolInput {
    func setListReview(items: [ReviewData])
    func getReview()
}

protocol SeeAllReviewProtocolOutput: class {
    var didGetReviewSuccess: (() -> Void)? { get set }
    
    //TableView
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
}

protocol SeeAllReviewProtocol: SeeAllReviewProtocolInput, SeeAllReviewProtocolOutput {
    var input: SeeAllReviewProtocolInput { get }
    var output: SeeAllReviewProtocolOutput { get }
}

class SeeAllReviewViewModel: SeeAllReviewProtocol, SeeAllReviewProtocolOutput {
    var input: SeeAllReviewProtocolInput { return self }
    var output: SeeAllReviewProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getPlugTypeCategoryUseCase: GetPlugTypeCategoryUseCase
    private var getFindAllProviderMasterUseCase: GetFindAllProviderMasterUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: SeeAllReviewViewController

    public var listReview: [ReviewData] = []
    
    init(
        vc: SeeAllReviewViewController,
        getPlugTypeCategoryUseCase: GetPlugTypeCategoryUseCase = GetPlugTypeCategoryUseCaseImpl(),
        getFindAllProviderMasterUseCase: GetFindAllProviderMasterUseCase = GetFindAllProviderMasterUseCaseImpl()
    ) {
        self.vc = vc
        self.getPlugTypeCategoryUseCase = getPlugTypeCategoryUseCase
        self.getFindAllProviderMasterUseCase = getFindAllProviderMasterUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetReviewSuccess: (() -> Void)?
    
    func setListReview(items: [ReviewData]) {
        self.listReview = items
    }
    
    func getReview() {
        self.didGetReviewSuccess?()
    }

}

extension SeeAllReviewViewModel {
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        return self.listReview.count
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier, for: indexPath) as! ReviewTableViewCell
        cell.selectionStyle = .none
        if self.listReview[indexPath.row].ReviewImg?.count ?? 0 > 0 {
            let width = ((vc.view.frame.width-32) / 3.0)
            cell.setupCollectionHeight(width)
        } else {
            cell.setupCollectionHeight(0)
        }
        cell.data = listReview[indexPath.row]
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

