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
    func userRegister(request: PostUserRegisterRequest) -> AnyPublisher<PostUserRegisterResponse, Error>
    func userAuth(request: PostUserAuthRequest) -> AnyPublisher<PostUserRegisterResponse, Error>
    func userProfile() -> AnyPublisher<GetUserProfileRssponse, Error>
}

final class UserRepositoryImpl: ChargeLoma.UserRepository {
    private let provider: MoyaProvider<UserAPI> = MoyaProvider<UserAPI>()

    func userRegister(request: PostUserRegisterRequest) -> AnyPublisher<PostUserRegisterResponse, Error> {
        return self.provider
            .cb
            .request(.postUserRegister(request: request))
            .map(PostUserRegisterResponse.self)
    }
    
    func userAuth(request: PostUserAuthRequest) -> AnyPublisher<PostUserRegisterResponse, Error> {
        return self.provider
            .cb
            .request(.postUserAuth(request: request))
            .map(PostUserRegisterResponse.self)
    }
    
    func userProfile() -> AnyPublisher<GetUserProfileRssponse, Error> {
        return self.provider
            .cb
            .request(.getUserProfile)
            .map(GetUserProfileRssponse.self)
    }
    
}
