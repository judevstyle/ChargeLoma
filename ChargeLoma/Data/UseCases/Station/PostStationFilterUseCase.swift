//
//  PostStationFilterUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 30/12/2564 BE.
//

import Foundation
import Combine

protocol PostStationFilterUseCase {
    func execute(request: PostStationFilterRequest) -> AnyPublisher<[StationData]?, Error>
}

struct PostStationFilterUseCaseImpl: PostStationFilterUseCase {
    
    private let repository: StationRepository
    
    init(repository: StationRepository = StationRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(request: PostStationFilterRequest) -> AnyPublisher<[StationData]?, Error> {
        return self.repository
            .postStationFilter(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
