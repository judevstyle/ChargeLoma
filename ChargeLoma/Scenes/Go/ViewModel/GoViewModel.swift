//
//  GoViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/1/2565 BE.
//

import Foundation
import UIKit
import Combine
import GoogleMaps
import CoreLocation

protocol GoProtocolInput {
    func getStationFilter()
    func getDirection(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D)
}

protocol GoProtocolOutput: class {
    var didStationFilterSuccess: (() -> Void)? { get set }
    var didStationFilterError: (() -> Void)? { get set }
    
    var didGetDirectionSuccess: (() -> Void)? { get set }
    
    func getListStation() -> [StationData]
    func getListRoute() -> [RouteItem]
}

protocol GoProtocol: GoProtocolInput, GoProtocolOutput {
    var input: GoProtocolInput { get }
    var output: GoProtocolOutput { get }
}

class GoViewModel: GoProtocol, GoProtocolOutput {
    var input: GoProtocolInput { return self }
    var output: GoProtocolOutput { return self }
    
    // MARK: - UseCase
    private var postStationFilterUseCase: PostStationFilterUseCase
    private var getPlaceDirectionUseCase: GetPlaceDirectionUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: GoViewController
    public var listStation: [StationData] = []
    public var listRoute: [RouteItem] = []
    
    init(
        vc: GoViewController,
        getPlaceDirectionUseCase: GetPlaceDirectionUseCase = GetPlaceDirectionUseCaseImpl(),
        postStationFilterUseCase: PostStationFilterUseCase = PostStationFilterUseCaseImpl()
    ) {
        self.vc = vc
        self.postStationFilterUseCase = postStationFilterUseCase
        self.getPlaceDirectionUseCase = getPlaceDirectionUseCase
    }
    
    // MARK - Data-binding OutPut
    var didStationFilterSuccess: (() -> Void)?
    var didStationFilterError: (() -> Void)?
    
    var didGetDirectionSuccess: (() -> Void)?
    
    func getStationFilter() {
        self.vc.startLoding()
        
        var request: PostStationFilterRequest = PostStationFilterRequest()
        request.lang = LanguageEnvironment.shared.current?.name ?? "en"
        DataManager.instance.getPlugTypeMaster().forEach({ item in
            if let pTypeId = item.pTypeId {
                request.plug.append(pTypeId)
            }
        })
        
        DataManager.instance.getProviderMaster().forEach({ item in
            if let pvId = item.pvId {
                request.provider.append(pvId)
            }
        })
        
        request.status = [1,2,3]
        
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
    
    func getDirection(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D) {
        var request: GetPlaceDirectionRequest = GetPlaceDirectionRequest()
        request.origin = "\(sourceLocation.latitude),\(sourceLocation.longitude)"
        request.destination = "\(destinationLocation.latitude),\(destinationLocation.longitude)"
        self.getPlaceDirectionUseCase.execute(request: request).sink { completion in
            debugPrint("getPlaceDirectionUseCase \(completion)")
            self.vc.stopLoding()
        } receiveValue: { resp in
            if let items = resp {
                self.listRoute = items
                self.didGetDirectionSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
}

extension GoViewModel {
    func getListStation() -> [StationData] {
        return self.listStation
    }
    
    func getListRoute() -> [RouteItem] {
        return self.listRoute
    }
}

public enum TypeDirectionMap {
    case sourceLocation
    case destinationLocation
}
