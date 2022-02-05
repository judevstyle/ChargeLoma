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
}

protocol AddReviewProtocolOutput: class {
    var didGetPlugStationSuccess: (() -> Void)? { get set }
    
    func getStId() -> String?
    
    //TableView
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat

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
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: AddReviewViewController
    
    public var stId: String?
    
    //ImageStation
    public var listPlugStation: [PlugStationData] = []
    
    init(
        vc: AddReviewViewController,
        getPlugStationUseCase: GetPlugStationUseCase = GetPlugStationUseCaseImpl()
    ) {
        self.vc = vc
        self.getPlugStationUseCase = getPlugStationUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetPlugStationSuccess: (() -> Void)?
    
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
        cell.itemPlugTypeData = self.listPlugStation[indexPath.row]
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
}
