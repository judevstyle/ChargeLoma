//
//  ForYouInfoViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 15/1/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol ForYouInfoProtocolInput {
    func getInformation()
    func setViewController(vc: UIViewController?)
}

protocol ForYouInfoProtocolOutput: class {
    var didGetInformationSuccess: (() -> Void)? { get set }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
}

protocol ForYouInfoProtocol: ForYouInfoProtocolInput, ForYouInfoProtocolOutput {
    var input: ForYouInfoProtocolInput { get }
    var output: ForYouInfoProtocolOutput { get }
}

class ForYouInfoViewModel: ForYouInfoProtocol, ForYouInfoProtocolOutput {
    var input: ForYouInfoProtocolInput { return self }
    var output: ForYouInfoProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getInformationFindAllUseCase: GetInformationFindAllUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: UIViewController? = nil
    
    init(
        getInformationFindAllUseCase: GetInformationFindAllUseCase = GetInformationFindAllUseCaseImpl()
    ) {
        self.getInformationFindAllUseCase = getInformationFindAllUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetInformationSuccess: (() -> Void)?
    
    fileprivate var listInformation: [InformationItem]? = []
    
    func getInformation() {
        self.listInformation?.removeAll()
        var request = GetInformationFindAllRequest()
        request.page = 1
        self.getInformationFindAllUseCase.execute(request: request).sink { completion in
            debugPrint("getInformationFindAllUseCase \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                self.listInformation = items
                self.didGetInformationSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func setViewController(vc: UIViewController?) {
        self.vc = vc
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        guard let count = listInformation?.count, count != 0 else { return 0 }
        return count
    }
    
    func getItemOrder(index: Int) -> InformationItem? {
        guard let itemOrder = listInformation?[index] else { return nil }
        return itemOrder
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as! ContentTableViewCell
        cell.selectionStyle = .none
        cell.item = listInformation?[indexPath.item]
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 250
    }
}
