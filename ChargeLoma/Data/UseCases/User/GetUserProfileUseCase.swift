//
//  GetUserProfileUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Combine

protocol GetUserProfileUseCase {
    func execute() -> AnyPublisher<UserProfileData?, Error>
}

struct GetUserProfileUseCaseImpl: GetUserProfileUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository = UserRepositoryImpl()) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<UserProfileData?, Error> {
        return self.repository
            .userProfile()
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
