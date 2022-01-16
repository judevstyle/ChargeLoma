//
//  SearchStationViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 14/1/2565 BE.
//

import Foundation
import UIKit
import Combine
import GoogleMaps

public protocol SearchStationViewModelDelegate {
    func didSuccessSelectedLocation(placeItem: PlaceItem?, type: TypeDirectionMap)
}

protocol SearchStationProtocolInput {
    func setDelegate(delegate: SearchStationViewModelDelegate, type: TypeDirectionMap)
    func getAutoComplete(request: GetPlaceAutoCompleteRequest)
    func didSelectPlace(item: PlaceItem)
}

protocol SearchStationProtocolOutput: class {

    var didGetPlaceAutoCompleteSuccess: (() -> Void)? { get set }
    var didGetPlaceDetailSuccess: (() -> Void)? { get set }

    func getListResultPlace() -> [PlaceItem]
}

protocol SearchStationProtocol: SearchStationProtocolInput, SearchStationProtocolOutput {
    var input: SearchStationProtocolInput { get }
    var output: SearchStationProtocolOutput { get }
}

class SearchStationViewModel: SearchStationProtocol, SearchStationProtocolOutput {
    var input: SearchStationProtocolInput { return self }
    var output: SearchStationProtocolOutput { return self }
    
    // MARK: - UseCase
    private var getPlaceAutoCompleteUseCase: GetPlaceAutoCompleteUseCase
    private var getPlaceDetailUseCase: GetPlaceDetailUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: SearchStationViewController
    
    //Place
    public var listSearchResultPlace: [PlaceItem] = []
    
    public var delegate: SearchStationViewModelDelegate?
    public var typeSelectMap: TypeDirectionMap = .sourceLocation
    init(
        vc: SearchStationViewController,
        getPlaceAutoCompleteUseCase: GetPlaceAutoCompleteUseCase = GetPlaceAutoCompleteUseCaseImpl(),
        getPlaceDetailUseCase: GetPlaceDetailUseCase = GetPlaceDetailUseCaseImpl()
    ) {
        self.vc = vc
        self.getPlaceAutoCompleteUseCase = getPlaceAutoCompleteUseCase
        self.getPlaceDetailUseCase = getPlaceDetailUseCase
    }
    
    // MARK - Data-binding OutPut
    
    var didGetPlaceAutoCompleteSuccess: (() -> Void)?
    var didGetPlaceDetailSuccess: (() -> Void)?
}

extension SearchStationViewModel {
    
    func setDelegate(delegate: SearchStationViewModelDelegate, type: TypeDirectionMap) {
        self.delegate = delegate
        self.typeSelectMap = type
    }
    
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
        getPlaceDetail(placeId: placeId, structuredFormatting: item.structuredFormatting)
    }
    
    private func getPlaceDetail(placeId: String, structuredFormatting: PredictionsStructuredFormatting?) {
        self.vc.startLoding()
        var request: GetPlaceDetailRequest = GetPlaceDetailRequest()
        request.placeId = placeId
        self.getPlaceDetailUseCase.execute(request: request).sink { completion in
            debugPrint("getPlaceDetailUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if var item = resp {
                item.structuredFormatting = structuredFormatting
                self.delegate?.didSuccessSelectedLocation(placeItem: item, type: self.typeSelectMap)
                self.vc.navigationController?.dismiss(animated: true, completion: nil)
            }
        }.store(in: &self.anyCancellable)
    }
}

