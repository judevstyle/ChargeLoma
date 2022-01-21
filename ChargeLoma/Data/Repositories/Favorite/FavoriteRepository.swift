//
//  FavoriteRepository.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Combine
import Moya

protocol FavoriteRepository {
    func getFavorite(request: FavoriteRequest) -> AnyPublisher<GetFavoriteResponse, Error>
    func postFavorite(request: FavoriteRequest) -> AnyPublisher<PostFavoriteResponse, Error>
    func deleteFavorite(stId: String) -> AnyPublisher<DeleteFavoriteResponse, Error>
}

final class FavoriteRepositoryImpl: ChargeLoma.FavoriteRepository {
    private let provider: MoyaProvider<FavoriteAPI> = MoyaProvider<FavoriteAPI>()

    func getFavorite(request: FavoriteRequest) -> AnyPublisher<GetFavoriteResponse, Error> {
        return self.provider
            .cb
            .request(.getFavorite(request: request))
            .map(GetFavoriteResponse.self)
    }
    
    func postFavorite(request: FavoriteRequest) -> AnyPublisher<PostFavoriteResponse, Error> {
        return self.provider
            .cb
            .request(.postFavorite(request: request))
            .map(PostFavoriteResponse.self)
    }
    
    func deleteFavorite(stId: String) -> AnyPublisher<DeleteFavoriteResponse, Error> {
        return self.provider
            .cb
            .request(.deleteFavorite(stId: stId))
            .map(DeleteFavoriteResponse.self)
    }
    
}
