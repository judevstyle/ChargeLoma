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
    func getRecentlyReview(request: GetReviewRequest) -> AnyPublisher<GetReviewResponse, Error>
    func postReview(request: PostReviewRequest) -> AnyPublisher<PostReviewResponse, Error>
    func getTopReview() -> AnyPublisher<GetTopReviewResponse, Error>
    func getReviewByUser(request: GetReviewRequest) -> AnyPublisher<GetReviewResponse, Error>
}

final class ReviewRepositoryImpl: ChargeLoma.ReviewRepository {
    private let provider: MoyaProvider<ReviewAPI> = MoyaProvider<ReviewAPI>()

    func getReview(request: GetReviewRequest) -> AnyPublisher<GetReviewResponse, Error> {
        return self.provider
            .cb
            .request(.getReview(request: request))
            .map(GetReviewResponse.self)
    }
    
    func getRecentlyReview(request: GetReviewRequest) -> AnyPublisher<GetReviewResponse, Error> {
        return self.provider
            .cb
            .request(.getRecentlyReview(request: request))
            .map(GetReviewResponse.self)
    }
    
    func postReview(request: PostReviewRequest) -> AnyPublisher<PostReviewResponse, Error> {
        return self.provider
            .cb
            .request(.createrReview(request: request))
            .map(PostReviewResponse.self)
    }
    
    func getTopReview() -> AnyPublisher<GetTopReviewResponse, Error> {
        return self.provider
            .cb
            .request(.getTopReviewer)
            .map(GetTopReviewResponse.self)
    }
    
    func getReviewByUser(request: GetReviewRequest) -> AnyPublisher<GetReviewResponse, Error> {
        return self.provider
            .cb
            .request(.getReviewByUser(request: request))
            .map(GetReviewResponse.self)
    }
    
}
