//
//  GetPlugStationUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 23/1/2565 BE.
//

import Foundation
import Combine

protocol GetPlugStationUseCase {
    func execute(request: GetPlugStationRequest) -> AnyPublisher<[PlugStationData]?, Error>
}

struct GetPlugStationUseCaseImpl: GetPlugStationUseCase {
    
    private let repository: PlugStationRepository
    
    init(repository: PlugStationRepository = PlugStationRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: GetPlugStationRequest) -> AnyPublisher<[PlugStationData]?, Error> {
        return self.repository
            .getPlugStation(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
