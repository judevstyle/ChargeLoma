//
//  ForYouLastedViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 2/2/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol ForYouLastedProtocolInput {
    func getRecentlyReview()
    func setViewController(vc: UIViewController?)
}

protocol ForYouLastedProtocolOutput: class {
    var didGetRecentlyReviewSuccess: (() -> Void)? { get set }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
    
    func getItemReviewData(_ tableView: UITableView, indexPath: IndexPath) -> ReviewData?
}

protocol ForYouLastedProtocol: ForYouLastedProtocolInput, ForYouLastedProtocolOutput {
    var input: ForYouLastedProtocolInput { get }
    var output: ForYouLastedProtocolOutput { get }
}

class ForYouLastedViewModel: ForYouLastedProtocol, ForYouLastedProtocolOutput {
    var input: ForYouLastedProtocolInput { return self }
    var output: ForYouLastedProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getGetRecentlyReviewUseCase: GetRecentlyReviewUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: UIViewController? = nil
    
    init(
        getGetRecentlyReviewUseCase: GetRecentlyReviewUseCase = GetRecentlyReviewUseCaseImpl()
    ) {
        self.getGetRecentlyReviewUseCase = getGetRecentlyReviewUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetRecentlyReviewSuccess: (() -> Void)?
    
    fileprivate var listReview: [ReviewData]? = []
    
    func getRecentlyReview() {
        self.listReview?.removeAll()
        var request = GetReviewRequest()
        request.page = 1
        request.limit = 100
        self.getGetRecentlyReviewUseCase.execute(request: request).sink { completion in
            debugPrint("getStationFavoriteUseCase \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                self.listReview = items
                self.didGetRecentlyReviewSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func setViewController(vc: UIViewController?) {
        self.vc = vc
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        guard let count = listReview?.count, count != 0 else { return 0 }
        return count
    }
    
    func getItem(index: Int) -> ReviewData? {
        guard let item = listReview?[index] else { return nil }
        return item
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewForYouTableViewCell.identifier, for: indexPath) as! ReviewForYouTableViewCell
        cell.selectionStyle = .none
        if self.listReview?[indexPath.row].ReviewImg?.count ?? 0 > 0 {
            cell.setupCollectionHeight(200)
        } else {
            cell.setupCollectionHeight(0)
        }
        cell.data = self.listReview?[indexPath.item]
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func getItemReviewData(_ tableView: UITableView, indexPath: IndexPath) -> ReviewData? {
        return self.listReview?[indexPath.item]
    }
}
