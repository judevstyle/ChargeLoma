//
//  PostUserRegisterUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 21/1/2565 BE.
//

import Foundation
import Combine

protocol PostUserRegisterUseCase {
    func execute(request: PostUserRegisterRequest) -> AnyPublisher<UserRegisterData?, Error>
}

struct PostUserRegisterUseCaseImpl: PostUserRegisterUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository = UserRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: PostUserRegisterRequest) -> AnyPublisher<UserRegisterData?, Error> {
        return self.repository
            .userRegister(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
