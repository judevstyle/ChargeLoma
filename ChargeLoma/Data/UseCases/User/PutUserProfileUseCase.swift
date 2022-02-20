//
//  PutUserProfileUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 19/2/2565 BE.
//

import Foundation
import Combine

protocol PutUserProfileUseCase {
    func execute(request: PostUpdateUserRequest) -> AnyPublisher<UserProfileData?, Error>
}

struct PutUserProfileUseCaseImpl: PutUserProfileUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository = UserRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: PostUpdateUserRequest) -> AnyPublisher<UserProfileData?, Error> {
        return self.repository
            .updateUserProfile(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
