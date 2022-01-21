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
    
    //Favorite
    func getFavorite()
    func postFavorite()
    func deleteFavorite()
}

protocol StationDetailProtocolOutput: class {
    var didGetStationSuccess: (() -> Void)? { get set }
    var didGetFavoriteSuccess: (() -> Void)? { get set }
    
    func getDataStation() -> StationData?
    
    //TableView
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int, type: StationDetailTableViewType) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath, type: StationDetailTableViewType) -> UITableViewCell
    func getItemViewCellHeight(type: StationDetailTableViewType) -> CGFloat
    
    func getIsFavorite() -> Bool
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
    
    //Favorite
    private var getFavoriteUseCase: GetFavoriteUseCase
    private var postFavoriteUseCase: PostFavoriteUseCase
    private var deleteFavoriteUseCase: DeleteFavoriteUseCase
    
    //ImageStations
    private var getImageStationUseCase: GetImageStationUseCase
    
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: StationDetailViewController
    
    public var dataStation: StationData?
    public var stId: String?
    public var isFavorite: Bool = false
    
    init(
        vc: StationDetailViewController,
        getStationFindOneUseCase: GetStationFindOneUseCase = GetStationFindOneUseCaseImpl(),
        getFavoriteUseCase: GetFavoriteUseCase = GetFavoriteUseCaseImpl(),
        postFavoriteUseCase: PostFavoriteUseCase = PostFavoriteUseCaseImpl(),
        deleteFavoriteUseCase: DeleteFavoriteUseCase = DeleteFavoriteUseCaseImpl(),
        getImageStationUseCase: GetImageStationUseCase = GetImageStationUseCaseImpl()
    ) {
        self.vc = vc
        self.getStationFindOneUseCase = getStationFindOneUseCase
        self.getFavoriteUseCase = getFavoriteUseCase
        self.postFavoriteUseCase = postFavoriteUseCase
        self.deleteFavoriteUseCase = deleteFavoriteUseCase
        self.getImageStationUseCase = getImageStationUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetStationSuccess: (() -> Void)?
    var didGetFavoriteSuccess: (() -> Void)?
    
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
            if let item = resp {
                self.dataStation = item
                self.didGetStationSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getDataStation() -> StationData? {
        return self.dataStation
    }
    
    func getIsFavorite() -> Bool {
        return self.isFavorite
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

//MARK: - Favorite
extension StationDetailViewModel {
    func getFavorite() {
        self.vc.startLoding()
        var request: FavoriteRequest = FavoriteRequest()
        request.stId = self.stId ?? ""
        self.getFavoriteUseCase.execute(request: request).sink { completion in
            debugPrint("getFavoriteUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                self.isFavorite = item.isFavorite ?? false
                self.didGetFavoriteSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func postFavorite() {
        self.vc.startLoding()
        var request: FavoriteRequest = FavoriteRequest()
        request.stId = self.stId ?? ""
        self.postFavoriteUseCase.execute(request: request).sink { completion in
            debugPrint("postFavoriteUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp, item.stId == self.stId {
                self.isFavorite = true
                self.didGetFavoriteSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func deleteFavorite() {
        self.vc.startLoding()
        self.deleteFavoriteUseCase.execute(stId: self.stId ?? "").sink { completion in
            debugPrint("deleteFavoriteUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp, item.data == true {
                self.isFavorite = false
                self.didGetFavoriteSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
}

public enum StationDetailTableViewType {
    case plugTableView
    case reviewTableView
}
