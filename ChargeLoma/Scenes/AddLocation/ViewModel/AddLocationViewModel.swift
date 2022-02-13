//
//  AddLocationViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 9/2/2565 BE.
//

import Foundation
import UIKit
import Combine
import GoogleMaps

protocol AddLocationProtocolInput {
    func setProviderList(items: [ProviderData])
    func didSetPlugTypeRequest(item: PlugTypeData?, power: Int)
    func didSelectLocation(centerMapCoordinate: CLLocationCoordinate2D)
    func didSelectCheckBox(isSelected: Bool, type: ServiceOtherType)
    
    func setClearResetValue()
    
    func createStation(stationName: String, stationDesc: String, tel: String, typeService: String, is24hr: Bool, addr: String, servicetimeOpen: String?, servicetimeClose: String?, isServiceCharge: Bool, serviceRate: Int?, statusApprove: String, stationStatus: Int, note: String?)
}

protocol AddLocationProtocolOutput: class {
    var didGetProviderMasterSuccess: (() -> Void)? { get set }
    var didSetPlugTypeRequestSuccess: (() -> Void)? { get set }
    var didGetGeoCodeSuccess: ((String?) -> Void)? { get set }
    
    //TableView
    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int, type: AddLocationTableViewType) -> Int
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath, type: AddLocationTableViewType) -> UITableViewCell
    func getItemViewCellHeight(type: AddLocationTableViewType) -> CGFloat

}

protocol AddLocationProtocol: AddLocationProtocolInput, AddLocationProtocolOutput {
    var input: AddLocationProtocolInput { get }
    var output: AddLocationProtocolOutput { get }
}

class AddLocationViewModel: AddLocationProtocol, AddLocationProtocolOutput {
    
    var input: AddLocationProtocolInput { return self }
    var output: AddLocationProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getPlugStationUseCase: GetPlugStationUseCase
    private var getGeocodePlaceUseCase: GetGeocodePlaceUseCase
    private var postStationUseCase: PostStationUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: AddLocationViewController

    //TableView Provider
    public var listProviderList: [ProviderData] = []
    
    //TableView PlugTypeMaster
    public var listPlugTypeData: [PlugTypeData] = []
    public var listPlugMappingData: [PlugMappingRequest] = []
    
    //Select Location
    public var centerMapCoordinate: CLLocationCoordinate2D? = nil
    
    var didGetProviderMasterSuccess: (() -> Void)?
    var didSetPlugTypeRequestSuccess: (() -> Void)?
    var didGetGeoCodeSuccess: ((String?) -> Void)?
    
    
    //CheckBox
    
    public var isParking: Bool = false
    public var isFoodShop: Bool = false
    public var isCoffeeShop: Bool = false
    public var isToilet: Bool = false
    public var isMarket: Bool = false
    public var isSleep: Bool = false
    public var isWifi: Bool = false
    public var isOther: Bool = false
    
    init(
        vc: AddLocationViewController,
        getPlugStationUseCase: GetPlugStationUseCase = GetPlugStationUseCaseImpl(),
        getGeocodePlaceUseCase: GetGeocodePlaceUseCase = GetGeocodePlaceUseCaseImpl(),
        postStationUseCase: PostStationUseCase = PostStationUseCaseImpl()
    ) {
        self.vc = vc
        self.getPlugStationUseCase = getPlugStationUseCase
        self.getGeocodePlaceUseCase = getGeocodePlaceUseCase
        self.postStationUseCase = postStationUseCase
    }
    
    func setProviderList(items: [ProviderData]) {
        self.listProviderList = items
//        self.didGetProviderMasterSuccess?()
    }

    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int, type: AddLocationTableViewType) -> Int {
        switch type {
        case .tableProviderView:
            return self.listProviderList.count
        case .tablePlugView:
            return self.listPlugMappingData.count != 0 ? (self.listPlugMappingData.count + 1) : 1
        }
    }
    
    func getItemViewCell(_ tableView: UITableView, indexPath: IndexPath, type: AddLocationTableViewType) -> UITableViewCell {
        switch type {
        case .tableProviderView:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProviderTableViewCell.identifier, for: indexPath) as! ProviderTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .systemGray5
            cell.provider = listProviderList[indexPath.row]
            return cell
        case .tablePlugView:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SelectPlugTableViewCell.identifier, for: indexPath) as! SelectPlugTableViewCell
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PlugTableViewCell.identifier, for: indexPath) as! PlugTableViewCell
                cell.selectionStyle = .none
                let index = indexPath.row - 1
                cell.delegate = self
                cell.itemPlugTypeData = self.listPlugTypeData[index]
                cell.btnDelete.isHidden = false
                cell.bgBadge.isHidden = false
                cell.titleBadge.isHidden = false
                cell.power = Int(self.listPlugMappingData[index].power ?? "0")
                cell.index = index
                return cell
            }
        }
    }
    
    func getItemViewCellHeight(type: AddLocationTableViewType) -> CGFloat {
        return 80
    }
    
    func didSetPlugTypeRequest(item: PlugTypeData?, power: Int) {
        if let item = item {
            listPlugTypeData.append(item)
            var plugMapping: PlugMappingRequest = PlugMappingRequest()
            plugMapping.pTypeId = item.pTypeId
            plugMapping.qty = 1
            plugMapping.power = "\(power)"
            listPlugMappingData.append(plugMapping)
            didSetPlugTypeRequestSuccess?()
        }
    }
    
    func createStation(stationName: String, stationDesc: String, tel: String, typeService: String, is24hr: Bool, addr: String, servicetimeOpen: String?, servicetimeClose: String?, isServiceCharge: Bool, serviceRate: Int?, statusApprove: String, stationStatus: Int, note: String?) {
        self.vc.startLoding()
        var request = PostStationRequest()
        request.stationNameTh = stationName
        request.stationNameEn = stationName
        request.stationDesc = stationDesc
        request.addrEn = addr
        request.addrTh = addr
        request.lat = self.centerMapCoordinate?.latitude
        request.lng = self.centerMapCoordinate?.longitude
        request.typeService = typeService
        request.is24hr = is24hr
        if is24hr == true {
            request.servicetimeOpen = "24 ชม."
        } else {
            request.servicetimeOpen = servicetimeOpen
        }
        request.servicetimeClose = ""
        request.isServiceCharge = isServiceCharge
        request.serviceRate = serviceRate
        request.statusApprove = statusApprove
        request.stationStatus = stationStatus
        request.note = note
        request.tel = tel
        
        request.isServiceParking = isParking
        request.isServiceFood = isFoodShop
        request.isServiceCoffee = isCoffeeShop
        request.isServiceRestroom = isToilet
        request.isServiceShoping = isMarket
        request.isServiceRestarea = isSleep
        request.isServiceWifi = isWifi
        request.isServiceOther = isOther
        
//        Provider
        request.pvId = self.listProviderList.first?.pvId
        
        request.PlugMapping = self.listPlugMappingData
        
        self.postStationUseCase.execute(request: request).sink { completion in
            debugPrint("postStationUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let status = resp?.success, status == true {
                NavigationManager.instance.switchTabbar(index: 0)
            }
        }.store(in: &self.anyCancellable)
    }
    
    func setClearResetValue() {
        self.listPlugMappingData.removeAll()
        self.listPlugTypeData.removeAll()
        self.didSetPlugTypeRequestSuccess?()
    
        self.listProviderList.removeAll()
        self.didGetProviderMasterSuccess?()
    
        
        self.centerMapCoordinate = nil
        self.didGetGeoCodeSuccess?("")
    }

}

public enum AddLocationTableViewType {
    case tableProviderView
    case tablePlugView
}

extension AddLocationViewModel: PlugTableViewCellDelegate {
    func didHandleDelete(index: Int?) {
        if let index = index {
            deleteListPlugTypeData(index: index)
            didSetPlugTypeRequestSuccess?()
        }
    }
    
    private func deleteListPlugTypeData(index: Int) {
        self.listPlugTypeData.remove(at: index)
        self.listPlugMappingData.remove(at: index)
    }
}

//Location
extension AddLocationViewModel {
    func didSelectLocation(centerMapCoordinate: CLLocationCoordinate2D) {
        self.centerMapCoordinate = centerMapCoordinate
        self.getGeocodePlace()
    }
    
    private func getGeocodePlace() {
        guard let lat = self.centerMapCoordinate?.latitude, let lng = self.centerMapCoordinate?.longitude else { return }
        self.vc.startLoding()
        var request = GetGeocodePlaceRequest()
        request.latlng = "\(lat),\(lng)"
        self.getGeocodePlaceUseCase.execute(request: request).sink { completion in
            debugPrint("getGeocodePlaceUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp?.results?.first {
                let title = item.formattedAddress
                self.didGetGeoCodeSuccess?(title)
            }
        }.store(in: &self.anyCancellable)
    }
}

extension AddLocationViewModel {
    func didSelectCheckBox(isSelected: Bool, type: ServiceOtherType) {
        switch type {
        case .parking:
            isParking = isSelected
        case .foodShop:
            isFoodShop = isSelected
        case .coffeeShop:
            isCoffeeShop = isSelected
        case .toilet:
            isToilet = isSelected
        case .market:
            isMarket = isSelected
        case .sleep:
            isSleep = isSelected
        case .wifi:
            isWifi = isSelected
        case .other:
            isOther = isSelected
        }
    }
}

public enum ServiceOtherType {
    case parking
    case foodShop
    case coffeeShop
    case toilet
    case market
    case sleep
    case wifi
    case other
}
