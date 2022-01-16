//
//  DetailStationViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 11/1/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol DetailStationProtocolInput {
    func getDetailStation()
    func setStId(_ stId: String)
}

protocol DetailStationProtocolOutput: class {
    var didGetStationSuccess: (() -> Void)? { get set }
    var didGetStationError: (() -> Void)? { get set }
    
    func getDataStation() -> StationData?
    
    //TableView
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int, type: DetailStationTableViewType) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath, type: DetailStationTableViewType) -> UITableViewCell
    func getItemViewCellHeight(type: DetailStationTableViewType) -> CGFloat
    
}

protocol DetailStationProtocol: DetailStationProtocolInput, DetailStationProtocolOutput {
    var input: DetailStationProtocolInput { get }
    var output: DetailStationProtocolOutput { get }
}

class DetailStationViewModel: DetailStationProtocol, DetailStationProtocolOutput {
    var input: DetailStationProtocolInput { return self }
    var output: DetailStationProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getStationFindOneUseCase: GetStationFindOneUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: DetailStationViewController
    
    public var dataStation: StationData?
    public var stId: String?
    
    init(
        vc: DetailStationViewController,
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
    
    func getDetailStation() {
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

extension DetailStationViewModel {
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int, type: DetailStationTableViewType) -> Int {
        switch type {
        case .plugTableView:
            return self.dataStation?.plugMapping?.count ?? 0
        case .reviewTableView:
            return 0
        }
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath, type: DetailStationTableViewType) -> UITableViewCell {
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
    
    func getItemViewCellHeight(type: DetailStationTableViewType) -> CGFloat {
        switch type {
        case .plugTableView:
            return 80
        case .reviewTableView:
            return 0
        }
    }
    
}

public enum DetailStationTableViewType {
    case plugTableView
    case reviewTableView
}
