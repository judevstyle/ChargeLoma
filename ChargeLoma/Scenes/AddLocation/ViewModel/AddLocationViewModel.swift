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
    func setStationData(stationData: StationData?)
    func setSelectedProviderList(items: [ProviderData])
    
    func getProviderMaster()
    func getPlugStation()
    
    func didSetPlugTypeRequest(item: PlugTypeData?, power: Int)
    func didSelectLocation(centerMapCoordinate: CLLocationCoordinate2D)
    func setSelectLocation(centerMapCoordinate: CLLocationCoordinate2D)
    func didSelectCheckBox(isSelected: Bool, type: ServiceOtherType)
    
    func setClearResetValue()
    
    func createStation(stationName: String, stationNameTH: String, stationDesc: String, tel: String, typeService: String, is24hr: Bool, addr: String, addrTH: String, servicetimeOpen: String?, servicetimeClose: String?, isServiceCharge: Bool, serviceRate: Double?, statusApprove: String, stationStatus: Int, note: String?,imgBase64:String)
}

protocol AddLocationProtocolOutput: class {
    
    var didSetStationDataSuccess: (() -> Void)? { get set }
    var didGetAllProviderMasterSuccess: (() -> Void)? { get set }
    var didGetProviderMasterSuccess: (() -> Void)? { get set }
    var didSetPlugTypeRequestSuccess: (() -> Void)? { get set }
    var didGetGeoCodeSuccess: ((String?) -> Void)? { get set }
    var didGetAllPlugTypeSuccess: (() -> Void)? { get set }
    
    var didUpdateStationSuccess: (() -> Void)? { get set }
    
    func getStationData() -> StationData?
    
    func getListAllProviderList() -> [ProviderData]
    func getListAllPlugTypeList() -> [PlugTypeData]
    
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
    private var getFindAllProviderMasterUseCase: GetFindAllProviderMasterUseCase
    private var getFindAllPlugTypeMasterUseCase: GetFindAllPlugTypeMasterUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: AddLocationViewController

    //TableView Provider
    public var listAllProviderList: [ProviderData] = []
    public var listSelectedProviderList: [ProviderData] = []
    
    //TableView PlugTypeMaster
    public var listAllPlugTypeData: [PlugTypeData] = []
    public var listSelectedPlugTypeData: [PlugTypeData] = []
    public var listPlugMappingData: [PlugMappingRequest] = []
    
    //Select Location
    public var centerMapCoordinate: CLLocationCoordinate2D? = nil
    
    
    public var stationData: StationData? = nil
    
    var didSetStationDataSuccess: (() -> Void)?
    
    var didGetAllProviderMasterSuccess: (() -> Void)?
    var didGetProviderMasterSuccess: (() -> Void)?
    
    var didGetAllPlugTypeSuccess: (() -> Void)?
    var didSetPlugTypeRequestSuccess: (() -> Void)?
    var didGetGeoCodeSuccess: ((String?) -> Void)?
    var didUpdateStationSuccess: (() -> Void)?
    
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
        postStationUseCase: PostStationUseCase = PostStationUseCaseImpl(),
        getFindAllProviderMasterUseCase: GetFindAllProviderMasterUseCase = GetFindAllProviderMasterUseCaseImpl(),
        getFindAllPlugTypeMasterUseCase: GetFindAllPlugTypeMasterUseCase = GetFindAllPlugTypeMasterUseCaseImpl()
    ) {
        self.vc = vc
        self.getPlugStationUseCase = getPlugStationUseCase
        self.getGeocodePlaceUseCase = getGeocodePlaceUseCase
        self.postStationUseCase = postStationUseCase
        self.getFindAllProviderMasterUseCase = getFindAllProviderMasterUseCase
        self.getFindAllPlugTypeMasterUseCase = getFindAllPlugTypeMasterUseCase
    }
    
    func setStationData(stationData: StationData?) {
        self.stationData = stationData
        
    }
    
    func getStationData() -> StationData? {
        return self.stationData
    }
    
    func setSelectedProviderList(items: [ProviderData]) {
        self.listSelectedProviderList = items
    }
    
    func getListAllProviderList() -> [ProviderData] {
        return self.listAllProviderList
    }
    
    func getListAllPlugTypeList() -> [PlugTypeData] {
        return self.listAllPlugTypeData
    }
    
    func getProviderMaster() {
        self.vc.startLoding()
        self.getFindAllProviderMasterUseCase.execute().sink { completion in
            debugPrint("getFindAllProviderMasterUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                self.listAllProviderList = item
                self.didGetAllProviderMasterSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getPlugStation() {
        self.vc.startLoding()
        self.getFindAllPlugTypeMasterUseCase.execute().sink { completion in
            debugPrint("getFindAllPlugTypeMasterUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                self.listAllPlugTypeData = item
                self.didGetAllPlugTypeSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }

    func getNumberOfRowsInSection(_ tableView: UITableView, section: Int, type: AddLocationTableViewType) -> Int {
        switch type {
        case .tableProviderView:
            return self.listSelectedProviderList.count
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
            cell.provider = listSelectedProviderList[indexPath.row]
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
                cell.itemPlugTypeData = self.listSelectedPlugTypeData[index]
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
            listSelectedPlugTypeData.append(item)
            var plugMapping: PlugMappingRequest = PlugMappingRequest()
            plugMapping.pTypeId = item.pTypeId
            plugMapping.qty = 1
            plugMapping.power = "\(power)"
            listPlugMappingData.append(plugMapping)
            didSetPlugTypeRequestSuccess?()
        }
    }
    
    func createStation(stationName: String, stationNameTH: String, stationDesc: String, tel: String, typeService: String, is24hr: Bool, addr: String, addrTH: String, servicetimeOpen: String?, servicetimeClose: String?, isServiceCharge: Bool, serviceRate: Double?, statusApprove: String, stationStatus: Int, note: String?,imgBase64:String) {
        self.vc.startLoding()
        var request = PostStationRequest()
        if let station = getStationData()  {
            request.stId = station.stId
        }
        
        request.stationImg = imgBase64
        
        
        
//        if Language.current == Language.thai {
            request.stationNameTh = stationNameTH
            request.addrTh = addrTH

//        }else{
            
            request.stationNameEn = stationName
            request.addrEn = addr

//        }
        
        request.stationDesc = stationDesc
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
        request.pvId = self.listSelectedProviderList.first?.pvId
        
        request.PlugMapping = self.listPlugMappingData
        
        self.postStationUseCase.execute(request: request).sink { completion in
            debugPrint("postStationUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let status = resp?.success, status == true {
                self.didUpdateStationSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func setClearResetValue() {
        self.listPlugMappingData.removeAll()
        self.listSelectedPlugTypeData.removeAll()
        self.didSetPlugTypeRequestSuccess?()
    
        self.listSelectedProviderList.removeAll()
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
        self.listSelectedPlugTypeData.remove(at: index)
        self.listPlugMappingData.remove(at: index)
    }
}

//Location
extension AddLocationViewModel {
    func setSelectLocation(centerMapCoordinate: CLLocationCoordinate2D) {
        self.centerMapCoordinate = centerMapCoordinate
    }
    
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
