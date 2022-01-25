//
//  GetReviewUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 22/1/2565 BE.
//

import Foundation
import Combine

protocol GetReviewUseCase {
    func execute(request: GetReviewRequest) -> AnyPublisher<[ReviewData]?, Error>
}

struct GetReviewUseCaseImpl: GetReviewUseCase {
    
    private let repository: ReviewRepository
    
    init(repository: ReviewRepository = ReviewRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: GetReviewRequest) -> AnyPublisher<[ReviewData]?, Error> {
        return self.repository
            .getReview(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
