//
//  PostReviewUseCase.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 7/2/2565 BE.
//

import Foundation
import Combine

protocol PostReviewUseCase {
    func execute(request: PostReviewRequest) -> AnyPublisher<PostReviewResponse?, Error>
}

struct PostReviewUseCaseImpl: PostReviewUseCase {
    
    private let repository: ReviewRepository
    
    init(repository: ReviewRepository = ReviewRepositoryImpl()) {
        self.repository = repository
    }

    func execute(request: PostReviewRequest) -> AnyPublisher<PostReviewResponse?, Error> {
        return self.repository
            .postReview(request: request)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
