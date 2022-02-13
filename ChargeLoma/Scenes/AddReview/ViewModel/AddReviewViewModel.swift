//
//  AddReviewViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 23/1/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol AddReviewProtocolInput {
    func setStId(_ stId: String)
    func setListPlug(items: [PlugStationData])
    
    func createReview(request: PostReviewRequest)
}

protocol AddReviewProtocolOutput: class {
    var didGetPlugStationSuccess: (() -> Void)? { get set }
    
    var didPostReviewSuccess: (() -> Void)? { get set }
    
    func getStId() -> String?
    
    //TableView
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
    
    func getSelectedPlug() -> PlugStationData?

}

protocol AddReviewProtocol: AddReviewProtocolInput, AddReviewProtocolOutput {
    var input: AddReviewProtocolInput { get }
    var output: AddReviewProtocolOutput { get }
}

class AddReviewViewModel: AddReviewProtocol, AddReviewProtocolOutput {
    
    var input: AddReviewProtocolInput { return self }
    var output: AddReviewProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getPlugStationUseCase: GetPlugStationUseCase
    private var postReviewUseCase: PostReviewUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: AddReviewViewController
    
    public var stId: String?
    
    //ImageStation
    public var listPlugStation: [PlugStationData] = []
    
    init(
        vc: AddReviewViewController,
        getPlugStationUseCase: GetPlugStationUseCase = GetPlugStationUseCaseImpl(),
        postReviewUseCase: PostReviewUseCase = PostReviewUseCaseImpl()
    ) {
        self.vc = vc
        self.getPlugStationUseCase = getPlugStationUseCase
        self.postReviewUseCase = postReviewUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetPlugStationSuccess: (() -> Void)?
    var didPostReviewSuccess: (() -> Void)?
    
    func getPlugStation() {
        self.vc.startLoding()
        var request: GetPlugStationRequest = GetPlugStationRequest()
        request.stId = self.stId
        self.getPlugStationUseCase.execute(request: request).sink { completion in
            debugPrint("getPlugStationUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                self.listPlugStation = item
                self.didGetPlugStationSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func setStId(_ stId: String) {
        self.stId = stId
    }
    
    func getStId() -> String? {
        return self.stId
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        return self.listPlugStation.count
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlugTableViewCell.identifier, for: indexPath) as! PlugTableViewCell
        cell.selectionStyle = .none
        cell.itemPlugStationData = self.listPlugStation[indexPath.row]
        cell.setBaseBG()
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 80
    }
    
    func setListPlug(items: [PlugStationData]) {
        self.listPlugStation = items
        self.didGetPlugStationSuccess?()
    }
    
    func getSelectedPlug() -> PlugStationData? {
        return self.listPlugStation.first
    }
    
    func createReview(request: PostReviewRequest) {
        self.vc.startLoding()
        self.postReviewUseCase.execute(request: request).sink { completion in
            debugPrint("postReviewUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                self.didPostReviewSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
}
