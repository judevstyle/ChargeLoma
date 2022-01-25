//
//  ChoosePlugViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 23/1/2565 BE.
//

import Foundation
import UIKit
import Combine

public protocol ChoosePlugViewModelDelegate {
    func didSelectedPlug(_ item: PlugStationData)
}

protocol ChoosePlugProtocolInput {
    func getPlugStation()
    func setupPrepare(_ stId: String, delegate: ChoosePlugViewModelDelegate)
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
}

protocol ChoosePlugProtocolOutput: class {
    var didGetPlugStationSuccess: (() -> Void)? { get set }
    
    //TableView
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat

}

protocol ChoosePlugProtocol: ChoosePlugProtocolInput, ChoosePlugProtocolOutput {
    var input: ChoosePlugProtocolInput { get }
    var output: ChoosePlugProtocolOutput { get }
}

class ChoosePlugViewModel: ChoosePlugProtocol, ChoosePlugProtocolOutput {
    
    var input: ChoosePlugProtocolInput { return self }
    var output: ChoosePlugProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getPlugStationUseCase: GetPlugStationUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: ChoosePlugViewController
    
    public var stId: String?
    
    //ImageStation
    public var listPlugStation: [PlugStationData] = []
    
    public var delegate: ChoosePlugViewModelDelegate?
    
    init(
        vc: ChoosePlugViewController,
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
    
    func setupPrepare(_ stId: String, delegate: ChoosePlugViewModelDelegate) {
        self.stId = stId
        self.delegate = delegate
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        return self.listPlugStation.count
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlugTableViewCell.identifier, for: indexPath) as! PlugTableViewCell
        cell.selectionStyle = .none
        cell.itemPlugTypeData = self.listPlugStation[indexPath.row]
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 80
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {
        let selectItem = self.listPlugStation[indexPath.row]
        self.delegate?.didSelectedPlug(selectItem)
        self.vc.navigationController?.popViewController(animated: true)
    }
}
