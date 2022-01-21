//
//  PostUserAuthUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Combine

protocol PostUserAuthUseCase {
    func execute(request: PostUserAuthRequest) -> AnyPublisher<UserRegisterData?, Error>
}

struct PostUserAuthUseCaseImpl: PostUserAuthUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository = UserRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: PostUserAuthRequest) -> AnyPublisher<UserRegisterData?, Error> {
        return self.repository
            .userAuth(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
