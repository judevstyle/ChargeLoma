//
//  ChooseProviderViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/2/2565 BE.
//

import Foundation
import UIKit
import Combine

public protocol ChooseProviderViewModelDelegate {
    func didSelectedProvider(_ item: ProviderData)
}

protocol ChooseProviderProtocolInput {
    func getProviderMaster()
    func setupPrepare(delegate: ChooseProviderViewModelDelegate)
    func setProviderMaster(listProvider: [ProviderData])
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath)
}

protocol ChooseProviderProtocolOutput: class {
    var didGetProviderMasterSuccess: (() -> Void)? { get set }
    
    //TableView
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat

}

protocol ChooseProviderProtocol: ChooseProviderProtocolInput, ChooseProviderProtocolOutput {
    var input: ChooseProviderProtocolInput { get }
    var output: ChooseProviderProtocolOutput { get }
}

class ChooseProviderViewModel: ChooseProviderProtocol, ChooseProviderProtocolOutput {
    
    var input: ChooseProviderProtocolInput { return self }
    var output: ChooseProviderProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getFindAllProviderMasterUseCase: GetFindAllProviderMasterUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: ChooseProviderViewController
    
    //ImageStation
    public var listProviderMaster: [ProviderData] = []
    
    public var delegate: ChooseProviderViewModelDelegate?
    
    init(
        vc: ChooseProviderViewController,
        getFindAllProviderMasterUseCase: GetFindAllProviderMasterUseCase = GetFindAllProviderMasterUseCaseImpl()
    ) {
        self.vc = vc
        self.getFindAllProviderMasterUseCase = getFindAllProviderMasterUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetProviderMasterSuccess: (() -> Void)?
    
    func setProviderMaster(listProvider: [ProviderData]) {
        self.listProviderMaster = listProvider
    }
    
    func getProviderMaster() {
        if self.listProviderMaster.count == 0 {
            self.vc.startLoding()
            self.getFindAllProviderMasterUseCase.execute().sink { completion in
                debugPrint("getFindAllProviderMasterUseCase \(completion)")
                self.vc.stopLoding()
            } receiveValue: { resp in
                if let item = resp {
                    self.listProviderMaster = item
                    self.didGetProviderMasterSuccess?()
                }
            }.store(in: &self.anyCancellable)
        } else {
            self.didGetProviderMasterSuccess?()
        }
    }
    
    func setupPrepare(delegate: ChooseProviderViewModelDelegate) {
        self.delegate = delegate
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        return self.listProviderMaster.count
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProviderTableViewCell.identifier, for: indexPath) as! ProviderTableViewCell
        cell.selectionStyle = .none
        cell.provider = self.listProviderMaster[indexPath.row]
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 80
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath) {
        let selectItem = self.listProviderMaster[indexPath.row]
        self.delegate?.didSelectedProvider(selectItem)
        self.vc.navigationController?.popViewController(animated: true)
    }
}
