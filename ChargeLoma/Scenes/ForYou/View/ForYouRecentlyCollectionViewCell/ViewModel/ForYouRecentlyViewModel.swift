//
//  ForYouRecentlyViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/1/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol ForYouRecentlyProtocolInput {
    func getStationFavorite()
    func setViewController(vc: UIViewController?)
}

protocol ForYouRecentlyProtocolOutput: class {
    var didGetStationFavoriteSuccess: (() -> Void)? { get set }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getItemViewCellHeight() -> CGFloat
    
    func getItemStationData(_ tableView: UITableView, indexPath: IndexPath) -> StationFavoriteData?
}

protocol ForYouRecentlyProtocol: ForYouRecentlyProtocolInput, ForYouRecentlyProtocolOutput {
    var input: ForYouRecentlyProtocolInput { get }
    var output: ForYouRecentlyProtocolOutput { get }
}

class ForYouRecentlyViewModel: ForYouRecentlyProtocol, ForYouRecentlyProtocolOutput {
    var input: ForYouRecentlyProtocolInput { return self }
    var output: ForYouRecentlyProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getStationFavoriteUseCase: GetStationFavoriteUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: UIViewController? = nil
    
    init(
        getStationFavoriteUseCase: GetStationFavoriteUseCase = GetStationFavoriteUseCaseImpl()
    ) {
        self.getStationFavoriteUseCase = getStationFavoriteUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetStationFavoriteSuccess: (() -> Void)?
    
    fileprivate var listStationFavorite: [StationFavoriteData]? = []
    
    func getStationFavorite() {
        self.listStationFavorite?.removeAll()
        var request = FavoriteRequest()
        request.page = 1
        request.lang = "th"
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
    
    func setViewController(vc: UIViewController?) {
        self.vc = vc
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
