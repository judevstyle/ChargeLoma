//
//  GetStationFavoriteUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/1/2565 BE.
//

import Foundation
import Combine

protocol GetStationFavoriteUseCase {
    func execute(request: FavoriteRequest) -> AnyPublisher<[StationFavoriteData]?, Error>
}

struct GetStationFavoriteUseCaseImpl: GetStationFavoriteUseCase {
    
    private let repository: FavoriteRepository
    
    init(repository: FavoriteRepository = FavoriteRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: FavoriteRequest) -> AnyPublisher<[StationFavoriteData]?, Error> {
        return self.repository
            .getStationFavorite(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
