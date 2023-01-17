//
//  GetImageStationUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Combine

protocol GetImageStationUseCase {
    func execute(request: GetImageStationRequest) -> AnyPublisher<GetImageStationResponse?, Error>
}

struct GetImageStationUseCaseImpl: GetImageStationUseCase {
    
    private let repository: StationRepository
    
    init(repository: StationRepository = StationRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: GetImageStationRequest) -> AnyPublisher<GetImageStationResponse?, Error> {
        return self.repository
            .getImageStation(request: request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
