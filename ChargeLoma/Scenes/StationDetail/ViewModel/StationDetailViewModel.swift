//
//  StationDetailViewModel.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 8/1/2565 BE.
//

import Foundation
import UIKit
import Combine

protocol StationDetailProtocolInput {
    func getStationDetail()
    func setStId(_ stId: String)
}

protocol StationDetailProtocolOutput: class {
    var didGetStationSuccess: (() -> Void)? { get set }
    var didGetStationError: (() -> Void)? { get set }
    
    func getDataStation() -> StationData?
    
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
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var vc: StationDetailViewController
    
    public var dataStation: StationData?
    public var stId: String?
    
    init(
        vc: StationDetailViewController,
        getStationFindOneUseCase: GetStationFindOneUseCase = GetStationFindOneUseCaseImpl()
    ) {
        self.vc = vc
        self.getStationFindOneUseCase = getStationFindOneUseCase
    }
    
    // MARK - Data-binding OutPut
    var didGetStationSuccess: (() -> Void)?
    var didGetStationError: (() -> Void)?
    
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
            debugPrint(resp)
            if let item = resp {
                self.dataStation = item
                self.didGetStationSuccess?()
            }
        }.store(in: &self.anyCancellable)
    }
    
    func getDataStation() -> StationData? {
        return self.dataStation
    }
    
}


