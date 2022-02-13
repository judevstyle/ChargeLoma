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
    func didSelectedPlugStation(_ item: PlugStationData)
    func didSelectedPlugTypeMaster(_ item: PlugTypeData, power: Int)
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
    private var getFindAllPlugTypeMasterUseCase: GetFindAllPlugTypeMasterUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: ChoosePlugViewController
    
    public var stId: String?
    
    //ImageStation
    public var listPlugStation: [PlugStationData] = []
    
    public var listPlugTypeMaster: [PlugTypeData] = []
    
    private var selectedPlugStation: PlugStationData? = nil
    private var selectedPlugTypeMaster: PlugTypeData? = nil
    
    public var delegate: ChoosePlugViewModelDelegate?
    
    init(
        vc: ChoosePlugViewController,
        getPlugStationUseCase: GetPlugStationUseCase = GetPlugStationUseCaseImpl(),
        getFindAllPlugTypeMasterUseCase: GetFindAllPlugTypeMasterUseCase = GetFindAllPlugTypeMasterUseCaseImpl()
    ) {
        self.vc = vc
        self.getPlugStationUseCase = getPlugStationUseCase
        self.getFindAllPlugTypeMasterUseCase = getFindAllPlugTypeMasterUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetPlugStationSuccess: (() -> Void)?
    
    func getPlugStation() {
        self.vc.startLoding()
        if let stId = self.stId, !stId.isEmpty {
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
        } else {
            self.getFindAllPlugTypeMasterUseCase.execute().sink { completion in
                debugPrint("getFindAllPlugTypeMasterUseCase \(completion)")
                self.vc.stopLoding()
            } receiveValue: { resp in
                if let item = resp {
                    self.listPlugTypeMaster = item
                    self.didGetPlugStationSuccess?()
                }
            }.store(in: &self.anyCancellable)
        }
    }
    
    func setupPrepare(_ stId: String, delegate: ChoosePlugViewModelDelegate) {
        self.stId = stId
        self.delegate = delegate
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        if self.listPlugStation.count != 0 {
            return self.listPlugStation.count
        } else {
            return self.listPlugTypeMaster.count
        }
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlugTableViewCell.identifier, for: indexPath) as! PlugTableViewCell
        cell.selectionStyle = .none
        
        if self.listPlugStation.count != 0 {
            cell.itemPlugStationData = self.listPlugStation[indexPath.row]
        } else {
            cell.itemPlugTypeData = self.listPlugTypeMaster[indexPath.row]
        }

        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 80
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {
        
        if self.listPlugStation.count != 0 {
            self.selectedPlugStation = self.listPlugStation[indexPath.row]

            if let selected = self.selectedPlugStation {
                self.delegate?.didSelectedPlugStation(selected)
            }
            self.vc.navigationController?.popViewController(animated: true)
        } else {
            self.selectedPlugTypeMaster = self.listPlugTypeMaster[indexPath.row]
            
            NavigationManager.instance.pushVC(to: .modalAddPower(delegate: self), presentation: .Present(withNav: false, modalTransitionStyle:      .crossDissolve, modalPresentationStyle: .overFullScreen))
        }
    
    }
}

extension ChoosePlugViewModel: ModalAddPowerViewControllerDelegate {
    func didSubmitPower(power: Int) {
        
        if let selected = self.selectedPlugStation {
            self.delegate?.didSelectedPlugStation(selected)
        } else {
            if let selected = self.selectedPlugTypeMaster {
                self.delegate?.didSelectedPlugTypeMaster(selected, power: power)
            }
        }
        
        self.vc.navigationController?.popViewController(animated: true)
    }
}
