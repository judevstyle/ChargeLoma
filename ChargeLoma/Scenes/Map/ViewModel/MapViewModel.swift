//
//  MapViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import UIKit
import Combine

protocol MapProtocolInput {
    func getStationFilter()
}

protocol MapProtocolOutput: class {
    var didStationFilterSuccess: (() -> Void)? { get set }
    var didStationFilterError: (() -> Void)? { get set }
    
    func getListStation() -> [StationData]
    
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
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: MapViewController
    
    public var listStation: [StationData] = []
    
    init(
        vc: MapViewController,
        postStationFilterUseCase: PostStationFilterUseCase = PostStationFilterUseCaseImpl()
    ) {
        self.vc = vc
        self.postStationFilterUseCase = postStationFilterUseCase
    }
    
    // MARK - Data-binding OutPut
    var didStationFilterSuccess: (() -> Void)?
    var didStationFilterError: (() -> Void)?
    
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
}

extension MapViewModel {
    func getListStation() -> [StationData] {
        return self.listStation
    }
}

