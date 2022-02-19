//
//  UsersHitViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 17/2/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol UsersHitProtocolInput {
    func getTopReview()
}

protocol UsersHitProtocolOutput: class {
    var didGetTopReviewSuccess: (() -> Void)? { get set }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
    
    func getItemData(_ tableView: UITableView, indexPath: IndexPath) -> TopReviewData?
}

protocol UsersHitProtocol: UsersHitProtocolInput, UsersHitProtocolOutput {
    var input: UsersHitProtocolInput { get }
    var output: UsersHitProtocolOutput { get }
}

class UsersHitViewModel: UsersHitProtocol, UsersHitProtocolOutput {
    var input: UsersHitProtocolInput { return self }
    var output: UsersHitProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getTopReviewUseCase: GetTopReviewUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: UIViewController? = nil
    
    init(
        vc: UsersHitViewController,
        getTopReviewUseCase: GetTopReviewUseCase = GetTopReviewUseCaseImpl()
    ) {
        self.vc = vc
        self.getTopReviewUseCase = getTopReviewUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetTopReviewSuccess: (() -> Void)?
    
    fileprivate var listTopReview: [TopReviewData]? = []
    
    func getTopReview() {
        self.listTopReview?.removeAll()
        self.getTopReviewUseCase.execute().sink { completion in
            debugPrint("getTopReviewUseCase \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                self.listTopReview = items
                self.didGetTopReviewSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        guard let count = listTopReview?.count, count != 0 else { return 0 }
        return count
    }
    
    func getItem(index: Int) -> TopReviewData? {
        guard let item = listTopReview?[index] else { return nil }
        return item
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopReviewTableViewCell.identifier, for: indexPath) as! TopReviewTableViewCell
        cell.selectionStyle = .none
        cell.index = indexPath.item
        cell.item = self.listTopReview?[indexPath.item]
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 95
    }
    
    func getItemData(_ tableView: UITableView, indexPath: IndexPath) -> TopReviewData? {
        return self.listTopReview?[indexPath.item]
    }
}
