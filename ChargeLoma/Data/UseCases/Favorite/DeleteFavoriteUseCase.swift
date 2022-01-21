//
//  DeleteFavoriteUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Combine

protocol DeleteFavoriteUseCase {
    func execute(stId: String) -> AnyPublisher<DeleteFavoriteResponse?, Error>
}

struct DeleteFavoriteUseCaseImpl: DeleteFavoriteUseCase {
    
    private let repository: FavoriteRepository
    
    init(repository: FavoriteRepository = FavoriteRepositoryImpl()) {
        self.repository = repository
    }

    func execute(stId: String) -> AnyPublisher<DeleteFavoriteResponse?, Error> {
        return self.repository
            .deleteFavorite(stId: stId)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
