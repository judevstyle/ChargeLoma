//
//  GetFavoriteUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Combine

protocol GetFavoriteUseCase {
    func execute(request: FavoriteRequest) -> AnyPublisher<FavoriteData?, Error>
}

struct GetFavoriteUseCaseImpl: GetFavoriteUseCase {
    
    private let repository: FavoriteRepository
    
    init(repository: FavoriteRepository = FavoriteRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: FavoriteRequest) -> AnyPublisher<FavoriteData?, Error> {
        return self.repository
            .getFavorite(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
