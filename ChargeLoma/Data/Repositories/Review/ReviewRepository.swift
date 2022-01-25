//
//  ReviewRepository.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 22/1/2565 BE.
//

import Foundation
import Combine
import Moya

protocol ReviewRepository {
    func getReview(request: GetReviewRequest) -> AnyPublisher<GetReviewResponse, Error>
}

final class ReviewRepositoryImpl: ChargeLoma.ReviewRepository {
    private let provider: MoyaProvider<ReviewAPI> = MoyaProvider<ReviewAPI>()

    func getReview(request: GetReviewRequest) -> AnyPublisher<GetReviewResponse, Error> {
        return self.provider
            .cb
            .request(.getReview(request: request))
            .map(GetReviewResponse.self)
    }
    
}
