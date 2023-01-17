//
//  GetStationFindOneUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 8/1/2565 BE.
//

import Foundation
import Foundation
import Combine

protocol GetStationFindOneUseCase {
    func execute(request: GetStationFindOneRequest) -> AnyPublisher<StationData?, Error>
}

struct GetStationFindOneUseCaseImpl: GetStationFindOneUseCase {
    
    private let repository: StationRepository
    
    init(repository: StationRepository = StationRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: GetStationFindOneRequest) -> AnyPublisher<StationData?, Error> {
        return self.repository
            .getFindOne(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
