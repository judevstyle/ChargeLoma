//
//  GetRecentlyReviewUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 2/2/2565 BE.
//

import Foundation
import Combine

protocol GetRecentlyReviewUseCase {
    func execute(request: GetReviewRequest) -> AnyPublisher<[ReviewData]?, Error>
}

struct GetRecentlyReviewUseCaseImpl: GetRecentlyReviewUseCase {
    
    private let repository: ReviewRepository
    
    init(repository: ReviewRepository = ReviewRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: GetReviewRequest) -> AnyPublisher<[ReviewData]?, Error> {
        return self.repository
            .getRecentlyReview(request: request)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
