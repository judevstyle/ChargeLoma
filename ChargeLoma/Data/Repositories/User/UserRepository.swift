//
//  UserRepository.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Combine
import Moya

protocol UserRepository {
    func userRegister(request: PostUpdateUserRequest) -> AnyPublisher<PostUpdateUserResponse, Error>
    func userAuth(request: PostUserAuthRequest) -> AnyPublisher<PostUpdateUserResponse, Error>
    func userProfile() -> AnyPublisher<GetUserProfileRssponse, Error>
    func updateUserProfile(request: PostUpdateUserRequest) -> AnyPublisher<GetUserProfileRssponse, Error>
}

final class UserRepositoryImpl: ChargeLoma.UserRepository {
    private let provider: MoyaProvider<UserAPI> = MoyaProvider<UserAPI>()

    func userRegister(request: PostUpdateUserRequest) -> AnyPublisher<PostUpdateUserResponse, Error> {
        return self.provider
            .cb
            .request(.postUserRegister(request: request))
            .map(PostUpdateUserResponse.self)
    }
    
    func userAuth(request: PostUserAuthRequest) -> AnyPublisher<PostUpdateUserResponse, Error> {
        return self.provider
            .cb
            .request(.postUserAuth(request: request))
            .map(PostUpdateUserResponse.self)
    }
    
    func userProfile() -> AnyPublisher<GetUserProfileRssponse, Error> {
        return self.provider
            .cb
            .request(.getUserProfile)
            .map(GetUserProfileRssponse.self)
    }
    
    func updateUserProfile(request: PostUpdateUserRequest) -> AnyPublisher<GetUserProfileRssponse, Error> {
        return self.provider
            .cb
            .request(.updateUserProfile(request: request))
            .map(GetUserProfileRssponse.self)
    }
    
}
