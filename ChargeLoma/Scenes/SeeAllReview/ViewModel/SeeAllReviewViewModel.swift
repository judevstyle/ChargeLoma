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
    func setListReview(items: [ReviewData]?)
    func setUID(uid: String?)
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
    private var getReviewByUserUseCase: GetReviewByUserUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: SeeAllReviewViewController

    public var listReview: [ReviewData] = []
    
    public var uid: String? = nil
    
    init(
        vc: SeeAllReviewViewController,
        getReviewByUserUseCase: GetReviewByUserUseCase = GetReviewByUserUseCaseImpl()
    ) {
        self.vc = vc
        self.getReviewByUserUseCase = getReviewByUserUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetReviewSuccess: (() -> Void)?
    
    func setListReview(items: [ReviewData]?) {
        self.listReview = items ?? []
    }
    
    func setUID(uid: String?) {
        self.uid = uid
    }
    
    func getReview() {
        if let uid = self.uid {
            getReviewByUser(uid: uid)
        } else {
            self.didGetReviewSuccess?()
        }
    }
    
    func getReviewByUser(uid: String) {
        self.listReview.removeAll()
        var request = GetReviewRequest()
        request.uid = uid
        request.page = 1
        request.lang = Language.current.name
        self.vc.startLoding()
        self.getReviewByUserUseCase.execute(request: request).sink { completion in
            debugPrint("getReviewByUserUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                self.listReview = items
                self.didGetReviewSuccess?()
            }
        }.store(in: &self.anyCancellable)
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

