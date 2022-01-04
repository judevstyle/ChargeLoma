//
//  StationRepository.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 4/1/2565 BE.
//

import Foundation
import Combine
import Moya

protocol StationRepository {
    func postStationFilter(request: PostStationFilterRequest) -> AnyPublisher<PostStationFilterResponse, Error>
}

final class StationRepositoryImpl: ChargeLoma.StationRepository {
    private let provider: MoyaProvider<StationAPI> = MoyaProvider<StationAPI>()

    func postStationFilter(request: PostStationFilterRequest) -> AnyPublisher<PostStationFilterResponse, Error> {
        return self.provider
            .cb
            .request(.stationFilter(request: request))
            .map(PostStationFilterResponse.self)
    }
}
