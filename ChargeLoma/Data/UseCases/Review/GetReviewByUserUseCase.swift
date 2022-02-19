//
//  GetReviewByUserUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 17/2/2565 BE.
//

import Foundation
import Combine

protocol GetReviewByUserUseCase {
    func execute(request: GetReviewRequest) -> AnyPublisher<[ReviewData]?, Error>
}

struct GetReviewByUserUseCaseImpl: GetReviewByUserUseCase {
    
    private let repository: ReviewRepository
    
    init(repository: ReviewRepository = ReviewRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: GetReviewRequest) -> AnyPublisher<[ReviewData]?, Error> {
        return self.repository
            .getReviewByUser(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
