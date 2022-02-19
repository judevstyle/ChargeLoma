//
//  GetTopReviewUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 17/2/2565 BE.
//

import Foundation
import Combine

protocol GetTopReviewUseCase {
    func execute() -> AnyPublisher<[TopReviewData]?, Error>
}

struct GetTopReviewUseCaseImpl: GetTopReviewUseCase {
    
    private let repository: ReviewRepository
    
    init(repository: ReviewRepository = ReviewRepositoryImpl()) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[TopReviewData]?, Error> {
        return self.repository
            .getTopReview()
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
