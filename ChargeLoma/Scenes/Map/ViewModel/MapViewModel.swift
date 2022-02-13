//
//  MapViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import UIKit
import Combine
import GoogleMaps

protocol MapProtocolInput {
    func getStationFilter()
    func didSelectMarkerAt(_ mapView: GMSMapView, marker: GMSMarker) -> Bool
    
    func getAutoComplete(request: GetPlaceAutoCompleteRequest)
    
    func didSelectPlace(item: PlaceItem)
}

protocol MapProtocolOutput: class {
    var didStationFilterSuccess: (() -> Void)? { get set }
    var didStationFilterError: (() -> Void)? { get set }
    
    var didGetPlaceAutoCompleteSuccess: (() -> Void)? { get set }
    var didGetPlaceDetailSuccess: (() -> Void)? { get set }
    
    func getListStation() -> [StationData]
    
    func getListResultPlace() -> [PlaceItem]
    
    func getLocationSelectedPlace() -> PlaceItem?
}

protocol MapProtocol: MapProtocolInput, MapProtocolOutput {
    var input: MapProtocolInput { get }
    var output: MapProtocolOutput { get }
}

class MapViewModel: MapProtocol, MapProtocolOutput {
    var input: MapProtocolInput { return self }
    var output: MapProtocolOutput { return self }
    
    // MARK: - UseCase
    private var postStationFilterUseCase: PostStationFilterUseCase
    private var getPlaceAutoCompleteUseCase: GetPlaceAutoCompleteUseCase
    private var getPlaceDetailUseCase: GetPlaceDetailUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: MapViewController
    
    public var listStation: [StationData] = []
    
    //Place
    public var listSearchResultPlace: [PlaceItem] = []
    public var dataLocationPlace: PlaceItem?
    
    init(
        vc: MapViewController,
        postStationFilterUseCase: PostStationFilterUseCase = PostStationFilterUseCaseImpl(),
        getPlaceAutoCompleteUseCase: GetPlaceAutoCompleteUseCase = GetPlaceAutoCompleteUseCaseImpl(),
        getPlaceDetailUseCase: GetPlaceDetailUseCase = GetPlaceDetailUseCaseImpl()
    ) {
        self.vc = vc
        self.postStationFilterUseCase = postStationFilterUseCase
        self.getPlaceAutoCompleteUseCase = getPlaceAutoCompleteUseCase
        self.getPlaceDetailUseCase = getPlaceDetailUseCase
    }
    
    // MARK - Data-binding OutPut
    var didStationFilterSuccess: (() -> Void)?
    var didStationFilterError: (() -> Void)?
    
    var didGetPlaceAutoCompleteSuccess: (() -> Void)?
    var didGetPlaceDetailSuccess: (() -> Void)?
    
    func getStationFilter() {
        self.vc.startLoding()
        
        var request: PostStationFilterRequest = PostStationFilterRequest()
        request.lang = LanguageEnvironment.shared.current?.name ?? "en"
        
        let storeFilter = StoreManager.shared.getMapFilter()
        storeFilter?.plugId?.forEach({ plugId in
            if let plugId = plugId {
                request.plug.append(plugId)
            }
        })
        
        storeFilter?.providerId?.forEach({ pvId in
            if let pvId = pvId {
                request.provider.append(pvId)
            }
        })
        
        request.status.append(0)
        
        storeFilter?.statusIndex?.forEach({ statusIndex in
            if let statusIndex = statusIndex {
                request.status.append(statusIndex)
            }
        })
        
        self.postStationFilterUseCase.execute(request: request).sink { completion in
            debugPrint("postStationFilterUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                self.listStation = items
                self.didStationFilterSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func didSelectMarkerAt(_ mapView: GMSMapView, marker: GMSMarker) -> Bool {
        
        return false
    }
}

extension MapViewModel {
    func getListStation() -> [StationData] {
        return self.listStation
    }
}

extension MapViewModel {
    func getAutoComplete(request: GetPlaceAutoCompleteRequest) {
        self.vc.startLoding()
        self.getPlaceAutoCompleteUseCase.execute(request: request).sink { completion in
            debugPrint("getPlaceAutoCompleteUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                self.listSearchResultPlace = items
                self.didGetPlaceAutoCompleteSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getListResultPlace() -> [PlaceItem] {
        if self.listSearchResultPlace.count > 5 {
            var items: [PlaceItem] = []
            self.listSearchResultPlace.enumerated().forEach({ index, item in
                if index < 5 {
                    items.append(item)
                }
            })
            return items
        } else {
            return self.listSearchResultPlace
        }
    }
    
    func didSelectPlace(item: PlaceItem) {
        guard let placeId = item.placeId else { return }
        getPlaceDetail(placeId: placeId)
    }
    
    private func getPlaceDetail(placeId: String) {
        self.vc.startLoding()
        var request: GetPlaceDetailRequest = GetPlaceDetailRequest()
        request.placeId = placeId
        self.getPlaceDetailUseCase.execute(request: request).sink { completion in
            debugPrint("getPlaceDetailUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let item = resp {
                self.dataLocationPlace = item
                self.didGetPlaceDetailSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getLocationSelectedPlace() -> PlaceItem? {
        return self.dataLocationPlace
    }
}

