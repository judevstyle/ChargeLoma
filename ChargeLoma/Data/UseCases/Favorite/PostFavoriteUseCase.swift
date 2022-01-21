//
//  PostFavoriteUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Combine

protocol PostFavoriteUseCase {
    func execute(request: FavoriteRequest) -> AnyPublisher<FavoriteData?, Error>
}

struct PostFavoriteUseCaseImpl: PostFavoriteUseCase {
    
    private let repository: FavoriteRepository
    
    init(repository: FavoriteRepository = FavoriteRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: FavoriteRequest) -> AnyPublisher<FavoriteData?, Error> {
        return self.repository
            .postFavorite(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
