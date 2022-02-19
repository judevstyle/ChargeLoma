//
//  SeeAllFavoriteViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 17/2/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol SeeAllFavoriteProtocolInput {
    func getStationFavorite()
}

protocol SeeAllFavoriteProtocolOutput: class {
    var didGetStationFavoriteSuccess: (() -> Void)? { get set }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
    
    func getItemStationData(_ tableView: UITableView, indexPath: IndexPath) -> StationFavoriteData?
}

protocol SeeAllFavoriteProtocol: SeeAllFavoriteProtocolInput, SeeAllFavoriteProtocolOutput {
    var input: SeeAllFavoriteProtocolInput { get }
    var output: SeeAllFavoriteProtocolOutput { get }
}

class SeeAllFavoriteViewModel: SeeAllFavoriteProtocol, SeeAllFavoriteProtocolOutput {
    var input: SeeAllFavoriteProtocolInput { return self }
    var output: SeeAllFavoriteProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getStationFavoriteUseCase: GetStationFavoriteUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: UIViewController? = nil
    
    init(
        vc: SeeAllFavoriteViewController,
        getStationFavoriteUseCase: GetStationFavoriteUseCase = GetStationFavoriteUseCaseImpl()
    ) {
        self.vc = vc
        self.getStationFavoriteUseCase = getStationFavoriteUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetStationFavoriteSuccess: (() -> Void)?
    
    fileprivate var listStationFavorite: [StationFavoriteData]? = []
    
    func getStationFavorite() {
        self.listStationFavorite?.removeAll()
        var request = FavoriteRequest()
        request.page = 1
        request.lang = Language.current.name
        self.getStationFavoriteUseCase.execute(request: request).sink { completion in
            debugPrint("getStationFavoriteUseCase \(completion)")
            self.vc?.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                self.listStationFavorite = items
                self.didGetStationFavoriteSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        guard let count = listStationFavorite?.count, count != 0 else { return 0 }
        return count
    }
    
    func getItem(index: Int) -> StationFavoriteData? {
        guard let item = listStationFavorite?[index] else { return nil }
        return item
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as! FavoriteTableViewCell
        cell.selectionStyle = .none
        cell.favorite = self.listStationFavorite?[indexPath.item]
        return cell
    }
    
    func getItemViewCellHeight() -> CGFloat {
        return 90
    }
    
    func getItemStationData(_ tableView: UITableView, indexPath: IndexPath) -> StationFavoriteData? {
        return self.listStationFavorite?[indexPath.item]
    }
}
