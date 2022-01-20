//
//  StationDetailViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 19/1/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol StationDetailProtocolInput {
    func getStationDetail()
    func setStId(_ stId: String)
}

protocol StationDetailProtocolOutput: class {
    var didGetStationSuccess: (() -> Void)? { get set }
    var didGetStationError: (() -> Void)? { get set }
    
    func getDataStation() -> StationData?
    
    //TableView
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int, type: StationDetailTableViewType) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath, type: StationDetailTableViewType) -> UITableViewCell
    func getItemViewCellHeight(type: StationDetailTableViewType) -> CGFloat
    
}

protocol StationDetailProtocol: StationDetailProtocolInput, StationDetailProtocolOutput {
    var input: StationDetailProtocolInput { get }
    var output: StationDetailProtocolOutput { get }
}

class StationDetailViewModel: StationDetailProtocol, StationDetailProtocolOutput {
    var input: StationDetailProtocolInput { return self }
    var output: StationDetailProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getStationFindOneUseCase: GetStationFindOneUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: StationDetailViewController
    
    public var dataStation: StationData?
    public var stId: String?
    
    init(
        vc: StationDetailViewController,
        getStationFindOneUseCase: GetStationFindOneUseCase = GetStationFindOneUseCaseImpl()
    ) {
        self.vc = vc
        self.getStationFindOneUseCase = getStationFindOneUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetStationSuccess: (() -> Void)?
    var didGetStationError: (() -> Void)?
    
    func setStId(_ stId: String) {
        self.stId = stId
    }
    
    func getStationDetail() {
        self.vc.startLoding()
        var request: GetStationFindOneRequest = GetStationFindOneRequest()
        request.lang = LanguageEnvironment.shared.current?.name ?? "th"
        request.stId = self.stId
        self.getStationFindOneUseCase.execute(request: request).sink { completion in
            debugPrint("getStationFindOneUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            debugPrint(resp)
            if let item = resp {
                self.dataStation = item
                self.didGetStationSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getDataStation() -> StationData? {
        return self.dataStation
    }
}

extension StationDetailViewModel {
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int, type: StationDetailTableViewType) -> Int {
        switch type {
        case .plugTableView:
            return self.dataStation?.plugMapping?.count ?? 0
        case .reviewTableView:
            return 0
        }
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath, type: StationDetailTableViewType) -> UITableViewCell {
        switch type {
        case .plugTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: PlugTableViewCell.identifier, for: indexPath) as! PlugTableViewCell
            cell.selectionStyle = .none
            cell.item = self.dataStation?.plugMapping?[indexPath.item]
            return cell
        case .reviewTableView:
            return UITableViewCell()
        }
    }
    
    func getItemViewCellHeight(type: StationDetailTableViewType) -> CGFloat {
        switch type {
        case .plugTableView:
            return 80
        case .reviewTableView:
            return 0
        }
    }
    
}

public enum StationDetailTableViewType {
    case plugTableView
    case reviewTableView
}
