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
    
    //ImageStation
    func getImageStation()
    
    //Review
    func getReview()
}

protocol StationDetailProtocolOutput: class {
    var didGetStationSuccess: (() -> Void)? { get set }
    var didGetFavoriteSuccess: (() -> Void)? { get set }
    var didGetImageStationSuccess: (() -> Void)? { get set }
    var didGetReviewSuccess: (() -> Void)? { get set }
    
    func getDataStation() -> StationData?
    
    //TableView
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int, type: StationDetailTableViewType) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath, type: StationDetailTableViewType) -> UITableViewCell
    func getItemViewCellHeight(type: StationDetailTableViewType) -> CGFloat
    
    func getIsFavorite() -> Bool
    
    func getListImageStation() -> [ImageStationData]
    func getListStrImageStation() -> [String]?
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
    
    //Review
    private var getReviewUseCase: GetReviewUseCase
    
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: StationDetailViewController
    
    public var dataStation: StationData?
    public var stId: String?
    public var isFavorite: Bool = false
    
    //ImageStation
    public var listImageStation: [ImageStationData] = []
    
    //Review
    public var listReview: [ReviewData] = []
    
    init(
        vc: StationDetailViewController,
        getStationFindOneUseCase: GetStationFindOneUseCase = GetStationFindOneUseCaseImpl(),
        getFavoriteUseCase: GetFavoriteUseCase = GetFavoriteUseCaseImpl(),
        postFavoriteUseCase: PostFavoriteUseCase = PostFavoriteUseCaseImpl(),
        deleteFavoriteUseCase: DeleteFavoriteUseCase = DeleteFavoriteUseCaseImpl(),
        getImageStationUseCase: GetImageStationUseCase = GetImageStationUseCaseImpl(),
        getReviewUseCase: GetReviewUseCase = GetReviewUseCaseImpl()
    ) {
        self.vc = vc
        self.getStationFindOneUseCase = getStationFindOneUseCase
        self.getFavoriteUseCase = getFavoriteUseCase
        self.postFavoriteUseCase = postFavoriteUseCase
        self.deleteFavoriteUseCase = deleteFavoriteUseCase
        self.getImageStationUseCase = getImageStationUseCase
        self.getReviewUseCase = getReviewUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetStationSuccess: (() -> Void)?
    var didGetFavoriteSuccess: (() -> Void)?
    var didGetImageStationSuccess: (() -> Void)?
    var didGetReviewSuccess: (() -> Void)?

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
    
    func getListImageStation() -> [ImageStationData] {
        return self.listImageStation
    }
    
    func getListStrImageStation() -> [String]? {
        var listStr: [String] = []
        self.listImageStation.forEach({ item in
            if let path = item.imgPath {
                listStr.append(path)
            }
        })
        return listStr
    }
}

extension StationDetailViewModel {
    
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int, type: StationDetailTableViewType) -> Int {
        switch type {
        case .plugTableView:
            return self.dataStation?.plugMapping?.count ?? 0
        case .reviewTableView:
            if self.listReview.count > 5 {
                return 5 + 1
            } else {
                return self.listReview.count
            }
        }
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath, type: StationDetailTableViewType) -> UITableViewCell {
        switch type {
        case .plugTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: PlugTableViewCell.identifier, for: indexPath) as! PlugTableViewCell
            cell.selectionStyle = .none
            cell.itemPlugMapping = self.dataStation?.plugMapping?[indexPath.item]
            return cell
        case .reviewTableView:
            if self.listReview.count > 5 {
                if indexPath.item == 5 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: SeeAllTableViewCell.identifier, for: indexPath) as! SeeAllTableViewCell
                    cell.selectionStyle = .none
                    cell.title = "อ่านรีวิวทั้งหมด"
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier, for: indexPath) as! ReviewTableViewCell
                    cell.selectionStyle = .none
                    if self.listReview[indexPath.row].ReviewImg?.count ?? 0 > 0 {
                        let width = ((vc.view.frame.width-32) / 3.0)
                        cell.setupCollectionHeight(width)
                    } else {
                        cell.setupCollectionHeight(0)
                    }
                    
                    cell.data = listReview[indexPath.row]
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier, for: indexPath) as! ReviewTableViewCell
                cell.selectionStyle = .none
                if self.listReview[indexPath.row].ReviewImg?.count ?? 0 > 0 {
                    let width = ((vc.view.frame.width-32) / 3.0)
                    cell.setupCollectionHeight(width)
                } else {
                    cell.setupCollectionHeight(0)
                }
                
                cell.data = listReview[indexPath.row]
                return cell
            }
        }
    }
    
    func getItemViewCellHeight(type: StationDetailTableViewType) -> CGFloat {
        switch type {
        case .plugTableView:
            return 80
        case .reviewTableView:
            return UITableView.automaticDimension
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

//MARK: - ImageStation
extension StationDetailViewModel {
    func getImageStation() {
        self.vc.startLoding()
        var request: GetImageStationRequest = GetImageStationRequest()
        request.qureyStamp = ""
        request.page = 1
        request.stId = self.stId ?? ""
        request.limit = 10
        self.getImageStationUseCase.execute(request: request).sink { completion in
            debugPrint("getImageStationUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                self.listImageStation = item.data ?? []
            }
            self.didGetImageStationSuccess?()
        }.store(in: &self.anyCancellable)
    }
}

//MARK: - Review
extension StationDetailViewModel {
    func getReview() {
        self.vc.startLoding()
        var request: GetReviewRequest = GetReviewRequest()
        request.stId = self.stId ?? ""
        self.getReviewUseCase.execute(request: request).sink { completion in
            debugPrint("getReviewUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                self.listReview = item
            }
            self.didGetReviewSuccess?()
        }.store(in: &self.anyCancellable)
    }
}

public enum StationDetailTableViewType {
    case plugTableView
    case reviewTableView
}
