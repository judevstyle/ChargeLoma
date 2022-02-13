//
//  PostStationUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 13/2/2565 BE.
//

import Foundation
import Combine

protocol PostStationUseCase {
    func execute(request: PostStationRequest) -> AnyPublisher<PostStationResponse?, Error>
}

struct PostStationUseCaseImpl: PostStationUseCase {
    
    private let repository: StationRepository
    
    init(repository: StationRepository = StationRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: PostStationRequest) -> AnyPublisher<PostStationResponse?, Error> {
        return self.repository
            .createStation(request: request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
